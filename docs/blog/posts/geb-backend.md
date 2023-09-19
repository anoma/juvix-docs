---
date: 2023-09-19
readtime: 15
authors:
  - artem
categories:
  - geb
  - vampir
tags:
  - circuits
  - vampir
links:
  - Vamp-IR book: https://anoma.github.io/VampIR-Book/
  - A Vamp-IR's guide to arithmetic circuits: https://blog.anoma.net/a-vamp-irs-guide-to-arithmetic-circuits-and-perfectly-boiled-eggs/
  - Compiling Juvix programs to arithmetic circuits via Vamp-IR: https://docs.juvix.org/latest/blog/vampir-circuits/
  - Geb: https://github.com/anoma/geb
  - The Geb Pipeline Report: https://zenodo.org/record/8262747
---

# Compiling to VampIR through Geb

!!! note

    The compilation described is currently not supported by the newest version of Juvix and Geb. Changes are forthcoming.

[Before](https://docs.juvix.org/latest/blog/vampir-circuits/), we discussed the
standard normalization approach to compiling Juvix programs to VampIR. An
alternative backend is provided by the Geb project currently implemented in Lisp
providing a categorical view of the needed translations.

The post will be devoted to discussing the core ideas of Geb, the practical
steps to take in order to use the corresponding pipeline, as well as the current
limitations the backend faces.

We assume basic familiarity with categorical concepts and VampIR.

# Geb Pipeline

Geb is a developing language providing a useful interface for specifying
categorical constructs and helping define compilers in terms of functors. The
approach is inspired by a classical observation that instead of dealing with
'good' compilation procedures one can instead specify functors between
appropriate categories representing the languages one initially considers.

In the current state of development, Geb is a fairly simple category in which
one can do "basic arithmetic." It is a category freely spanned by
terminal/initial objects and finite (co)products with additional constructs for
objects representing `n`-bit natural numbers. The pipeline itself is a string of
functors between categories:

$$
\text {Lambda} \to \text {Geb} \to \text {Seq} \mathbb N
$$

which are all implemented in Lisp. The morphisms in the final category have a
fairly direct interpretation as VampIR programs.

Here, Lambda stands for an extension of STLC with natural numbers types of
different bit-width and some arithmetic, while Seq$\mathbb N$ is a category of
finite natural number sequences with morphism $$f: (x_1,\dots,x_n) \to
(y_1,\dots,y_m) $$ a VampIR function which takes in $n$ inputs with $i$-th input
of bit-length $x_i$ and spits out an $m$-tuple with $i$-th outputs of bit-length
$y_i$.

# The Practice

In this section, we describe all the practical steps one needs to take in order
to compile Juvix code to VampIR using the Geb binary.

## From Juvix to Lambda

The first step to the compilation is getting Juvix code to compile to Lambda.
The translation can be done inside of Juvix itself.

Let us create an example using one of the VampIR tests in the codebase. We
create a file `NotZero.juvix` with body

```juvix
-- This is a comment
module NotZero;

-- We need to name the module exactly the same name as the file
def intToBool : Nat -> Bool := \(x : Int) if x = 0 then false else true;

-- We need to include a function named main
-- for the compilation to succeed
main (x : Nat) : Bool := if intToBool x then 0 else 1;
```

and we want to compile it to code that is readable by the Lisp implementation of
Geb. We run

```shell
juvix compile -t geb NotZero.juvix
```

which generates a `NonZero.lisp` file with the following code:

```clojure
(defpackage #:NotZero
  (:shadowing-import-from :geb.lambda.spec #:pair #:right #:left)
  (:shadowing-import-from :geb.spec #:case)
  (:use #:common-lisp #:geb.lambda.trans #:geb.lambda.main #:geb.lambda.spec #:geb))

(in-package :NonZero)

(defparameter *entry*
  (app (lamb (list (fun-type
                        int
                        (coprod
                          so1
                          so1)))
               (lamb (list int)
                      (case-on
                        (app  (index 1)
                              (list (index 0)))
                        (bit-choice 0)
                        (bit-choice 1))))
        (list (lamb (list int)
                      (case-on
                        (lamb-eq
                          (index 0)
                          (bit-choice 0))
                        (right
                          so1
                          (unit))
                        (left
                          so1
                          (unit)))))))

```

The file generated will be used by the Geb binary where `*entry*` is a
parameter for a term to be compiled. The Lambda code produced is similar to STLC
with certain variations. In the above code, we have:

1. Unit type is `so1`
2. Unique element of the Unit type is `unit`
3. Coproduct type of `a` and `b` is `coprod a b`
4. `left` and `right` are appropriate sum-type injections
5. Function type from `a` to `b` is `fun-type a b`
6. `int` a stand-in for a type of 24-bit numbers
7. `lamb` is lambda abstraction
8. `app` is function application
9. `case-on` is sum type induction
10. `lamb-eq` predicate for checking number equality
11. `index n` is an `n`-th DeBruijn index
12. `bit-choice n` is a constructor for number `n`

## From Lambda to VampIR

After generating the file, one needs to go into the Geb repository, make a
binary, creating `geb.image` file inside the `build` folder and inside it run

```shell
./geb.image -i "NonZero.lisp" -e "NonZero:*entry*" -l -p -o "NonZero.pir"
```

This will generate a `NonZero.pir` file in `build` with the inserted Lambda code
compiled to VampIR through Geb.

One can remove `-o "NonZero.pir"` in order for the terminal to print the
relevant code instead of putting it in a separate file.

In the build directory type

```shell
./geb.image -i "NonZero.lisp" -e "NonZero:*entry*" -l -p
```

Which returns

```shell
(def entry x1 x2 = {
   (1 - (iszero x1))
 };)
```

Note that the last variable in the function is unused. This will be the case for
any compiled function and is due to a compilation side-effect when we go from
Lambda to Geb.

For further instructions on the use of the binary, consult the [Geb
documentation](https://github.com/anoma/geb).

## Interactive Mode

If one is interested in using more features than the direct compilation to
VampIR, one may use the Geb codebase interactively.

To do so, load the system as per the [Geb
documentation](https://github.com/anoma/geb), then go a package preferably using
all the relevant lambda code such as `geb.lambda.trans` by typing

```lisp
CL-USER> (in-package geb.lambda.trans)
```

Here one can compile the relevant code to several targets. `to-circuit` takes a
lambda term in an empty context and a name.

If we want to compile the identity function on natural numbers `(lamb (list int)
(index 0))` with name `id` we type

```lisp
TRANS> (to-circuit (lamb (list int) (index 0)) :id)
```

Moreover, we can compile this not to a circuit but to Geb in a nil context
(which we need to specify explicitly), e.g. by typing

```lisp
TRANS> (to-cat nil (lamb (list int) (index 0)))
```

or to Seq$\mathbb N$ in the nil context by

```lisp
TRANS> (to-seqn (lamb (list int) (index 0)))
```

For further utility function discription, please consult the relevant
documentation.

# The Theory

This section is devoted to describing the core ideas of how the compilation
occurs step-by-step.

## From Juvix to Lambda

The transformation of Juvix to Lambda is a pretty easy one compared to the
normalization approach partially due to the limitations we will discuss later.

The Juvix code gets transformed by

1. Transforming type names and rescuing needed type signatures, e.g. `Nat`
   becomes primitive `Int`
2. Unrolling recursion
3. Lifting out let-statements
4. Inlining type synonyms
5. Presenting finite indictive datatypes using sum/product type structures

Afterwards, a direct translation to STLC follows.

## From Lambda to Geb

The compilation of Lambda to Geb is actually a canonical one. Geb is secretly a
category equivalent to **_FinSet_** and in particular, is a Cartesian Closed
Category. By a classical result of Lambek-Scott, there is a unique compilation
of STLC to Geb preserving STLC structure. All other datatypes are compiled
primitively: e.g. `plus` in Lambda gets compiled to the primitive `nat-plus`.

## From Geb to Seq$\mathbb N$

The transformation to the finite-sequence category representing VampIR
operations is a bit tricky, yet the point is that each object in Geb has an
intuitive notion of bit-width. The object of `n`-bit numbers has `n`-width,
while `bool`, the coproduct of two terminal objects, has width `1`. Products
should just append the widths of its parts while coproducts should mark the left
bit entries with `0` while right ones with `1` to differentiate between the two.
Hence all the objects get encoded in this manner with morphisms following a
similar fashion.

## From Seq$\mathbb N$ to VampIR

The compilation to VampIR is a straightforward one as the morphisms in
Seq$\mathbb N$ have been chosen in such a way that the category can be directly
seen as a model of VampIR. For more detailed info on the compilation, consult
the [recent report](https://zenodo.org/record/8262747) on the pipeline by the
Juvix team.

# Limitations

After describing the Geb backend, we also need to mention current limitations
and challenges that the pipeline faces.

## Limited Interpretation Power

Currently, not all Juvix programs can be interpreted in Geb. As we have
mentioned, Geb is just a variation of **_FinSet_**, a fairly weak category. We
currently do not have support for interpreting any polymorphic type or any
infinite datatype.

Moreover, as there are no primitive function types in Geb, we also do not have a
way to make internal function definitions via constraints in VampIR the way the
normalizer compilation does.

However, these issues are to be addressed in a newer version of Geb, which will
significantly enhance the expressive power of the language.

## Heap Exhaustion for Functions of Natural Number

While Geb seems like a good candidate to do "categorical arithmetic" in and
hence to compile to arithmetic circuits, the fact that the primitive
constructions are very minimal serves as a reason for an exponential blow-up. An
object representing `n`-bit natural number `nat-wdth n` is analyzed as a `2^n`
coproduct of terminal objects. So even if we have primitives for natural
numbers, for `curry` and `uncurry` operations the functions get analyzed
bit-by-bit, causing a blow-up.

If one compiles complicated functions, even working with 2-bit numbers can cause
a heap exhaust.

However, there are forthcoming enhancements to the pipeline. Future
optimizations of Lambda will include a "smart" version of beta-reduction
allowing for the removal of unnecessary lambda and function application
occurences. This will effectively eliminate all blow-up problems having to do
with compiling relevant Juvix code.
