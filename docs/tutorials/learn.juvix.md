---
icon: material/lambda
comments: true
search:
  boost: 2
tags:
  - tutorial
  - intermediate
  - functional-programming
---

```juvix hide
module tutorials.learn;
```

# Functional programming with Juvix

![tara-teaching](./../assets/images/tara-teaching.svg){ align=left width="280" }

Welcome to the Juvix functional programming tutorial! This thorough
guide provides a structured introduction to Juvix language features
and functional programming concepts. By the end of this tutorial,
you'll have a strong foundation in functional programming with
Juvix.

Before reading this tutorial, it is recommended to work through the [Essential Juvix](./essential.html) tutorial which introduces basic Juvix freatures. Here we focus on explaining the Juvix language more thoroughly and on employing common functional programming techniques.

## Data types and functions

Common types like `Nat`, `Int` and `Bool` are defined in the standard library. These built-in types are treated specially by the compiler, but they still have ordinary definitions like any other type.

The type `Bool` has two constructors `true` and `false`.

```juvix extract-module-statements
module Bool;

  type Bool :=
    | true
    | false;
end;
```

The constructors of a data type can be used to build elements of the type. They
can also appear as patterns in function definitions. For example, the `not`
function is defined in the standard library by:

```juvix extract-module-statements 1
module Bool-Not;

  open Bool;
  not : Bool -> Bool
    | true := false
    | false := true;
end;
```

The type of the definition is specified after the colon. In this case, `not` is
a function from `Bool` to `Bool`. The type is followed by two _function clauses_
which specify the function result depending on the shape of the arguments. When
a function call is evaluated, the first clause that matches the arguments is
used.

In contrast to languages like Python, Java or C/C++, Juvix doesn't require
parentheses for function calls. All arguments are just listed after the
function. The general pattern for function application is: `func arg1 arg2 arg3 ...`

Initial arguments that are matched against variables or wildcards in all clauses
can be moved to the left of the colon. For example,

```juvix extract-module-statements 1
module Bool-Or;
  open Bool;

  or (x : Bool) : Bool -> Bool
    | true := true
    | _ := x;
end;
```

is equivalent to

```juvix extract-module-statements 1
module Bool-Or-Altl;
  open Bool;

  or : Bool -> Bool -> Bool
    | _ true := true
    | x _ := x;
end;
```
If there is only one clause and all arguments are to the left of the colon, the
pipe `|` should be omitted:

```juvix extract-module-statements 1
module Bool-Id;
  open Bool;

  id (x : Bool) : Bool := x;
end;
```

A more complex example of a data type is the `Nat` type from the standard
library:

```juvix extract-module-statements
module Nat;

  type Nat :=
    | zero : Nat
    | suc : Nat -> Nat;
end;
```

The constructor `zero` represents `0` and `suc` represents the successor
function – `suc n` is the successor of `n`, i.e., `n+1`. For example, `suc zero`
represents `1`. The number literals `0`, `1`, `2`, etc., are just shorthands for
appropriate expressions built using `suc` and `zero`.

The constructors of a data type specify how the elements of the type can be
constructed. For instance, the above definition specifies that an element of
`Nat` is either:

- `zero`, or
- `suc n` where `n` is an element of `Nat`, i.e., it is constructed by applying
  `suc` to appropriate arguments (in this case the argument of `suc` has type
  `Nat`).

Any element of `Nat` can be built with the constructors in this way – there are
no other elements. Mathematically, this is an inductive definition, which is why
the data type is called _inductive_.

Constructors can either by specified by listing their types after colons like in
the above definition of `Nat`, or with a shorter _ADT syntax_ like in the
definition of `Bool`. The ADT syntax is similar to data type definition syntax
in functional languages like Haskell or OCaml: one lists the types of
constructor arguments separated by spaces. In this syntax, the `Nat` type could
be defined by

```juvix extract-module-statements
module Nat-Alt;

  type Nat :=
    | zero
    | suc Nat;
end;
```

If implemented directly, the above unary representation of natural numbers would
be extremely inefficient. The Juvix compiler uses a binary number representation
under the hood and implements arithmetic operations using corresponding machine
instructions, so the performance of natural number arithmetic is similar to
other programming languages. The `Nat` type is a high-level presentation of
natural numbers as seen by the user who does not need to worry about low-level
arithmetic implementation details.

One can use `zero` and `suc` in pattern matching, like any other constructors:

```juvix extract-module-statements 2
module Nat-Add;
  import Stdlib.Data.Fixity open;
  open Nat;

  syntax operator + additive;
  + : Nat -> Nat -> Nat
    | zero b := b
    | (suc a) b := suc (a + b);
end;
```

The `syntax operator + additive` declares `+` to be an operator with the
`additive` fixity. The `+` is an ordinary function, except that function
application for `+` is written in infix notation. The definitions of the clauses
of `+` still need the prefix notation on the left-hand sides. Note that to use
this definition in the code one needs to import and open `Stdlib.Data.Fixity`.

The `a` and `b` in the patterns on the left-hand sides of the clauses are
_variables_ which match arbitrary values of the corresponding type. They can be
used on the right-hand side to refer to the values matched. For example, when
evaluating

```text
(suc (suc zero)) + zero
```

the second clause of `+` matches, assigning `suc zero` to `a` and `zero` to `b`.
Then the right-hand side of the clause is evaluated with `a` and `b` substituted
by these values:

```text
suc (suc zero + zero)
```

Again, the second clause matches, now with both `a` and `b` being `zero`. After
replacing with the right-hand side, we obtain:

```text
suc (suc (zero + zero))
```

Now the first clause matches and finally we obtain the result

```text
suc (suc zero)
```

which is just `2`.

The function `+` is defined like above in the standard library, but the Juvix
compiler treats it specially and generates efficient code using appropriate CPU
instructions.

### Evaluation order

By default, evaluation in Juvix is _eager_ (or _strict_), meaning that
the arguments to a function are fully evaluated before applying the
function. Only logical operators `||` and `&&` are treated specially
and evaluated lazily. These special functions cannot be partially
applied (see [Partial application and higher-order
functions](./learn.juvix.md#partial-application-and-higher-order-functions)
below).

## Pattern matching

The patterns in function clauses do not have to match on a single constructor –
they may be arbitrarily deep. For example, here is an (inefficient)
implementation of a function which checks whether a natural number is even:

```juvix extract-module-statements 2
module Even;
  open Nat;
  open Bool;

  isEven : Nat -> Bool
    | zero := true
    | (suc zero) := false
    | (suc (suc n)) := isEven n;
end;
```

This definition states that a natural number `n` is even if either `n` is `zero`
or, recursively, `n-2` is even.

If a subpattern is to be ignored, then one can use a wildcard `_` instead of
naming the subpattern.

```juvix extract-module-statements 2
module Positive;
  open Nat;
  open Bool;

  isPositive : Nat -> Bool
    | zero := false
    | (suc _) := true;
end;
```

The above function could also be written as:

```juvix extract-module-statements 2
module Positive-Alt;
  open Nat;
  open Bool;

  isPositive : Nat -> Bool
    | zero := false
    | _ := true;
end;
```

It is not necessary to define a separate function to perform pattern matching.
One can use the `case` syntax to pattern match an expression directly.

```jrepl
Stdlib.Prelude> case (1, 2) of (suc _, zero) := 0 | (suc _, suc x) := x | _ := 19
1
```

It is possible to name subpatterns with `@`.

```jrepl
Stdlib.Prelude> case 3 of suc n@(suc _) := n | _ := 0
2
```

## Comparisons and conditionals

The standard library includes all the expected comparison operators:
`<`, `<=`, `>`, `>=`, `==`, `/=`. Similarly to arithmetic operations,
the comparisons are in fact defined generically for different
datatypes using traits, which are out of the scope of this
tutorial. For basic usage, one can assume that the comparisons operate
on natural numbers.

For example, one may define the function `max3` using `>` and `max`
from the standard library:

```juvix extract-module-statements 1
module max3-example;
  import Stdlib.Prelude open;

  max3 (x y z : Nat) : Nat :=
    if
      | x > y := max x z
      | else := max y z;
end;
```

## Local definitions

Juvix supports local definitions with let-expressions.

```juvix extract-module-statements 1
module Let-Mult;
  import Stdlib.Prelude open;

  f (a : Nat) : Nat :=
    let
      x : Nat := a + 5;
      y : Nat := a * 7 + x;
    in x * y;
end;
```

The variables `x` and `y` are not visible outside `f`.

One can also use multi-clause definitions in `let`-expressions, with the same
syntax as definitions inside a module. For example:

```juvix extract-module-statements 2
module Let-Even;
  open Nat;
  open Bool;

  isEven : Nat -> Bool :=
    let
      isEven' : Nat -> Bool
        | zero := true
        | (suc n) := isOdd' n;
      isOdd' : Nat -> Bool
        | zero := false
        | (suc n) := isEven' n;
    in isEven';
end;
```

The functions `isEven'` and `isOdd'` are not visible outside `isEven`.

## Recursion

Juvix is a purely functional language, which means that functions have no side
effects and all variables are immutable. An advantage of functional programming
is that all expressions are _referentially transparent_ – any expression can be
replaced by its value without changing the meaning of the program. This makes it
easier to reason about programs, in particular to prove their correctness. No
errors involving implicit state are possible, because the state is always
explicit.

In a functional language, there are no imperative loops. Repetition is expressed
using recursion. In many cases, the recursive definition of a function follows
the inductive definition of a data structure the function analyses. For example,
consider the following inductive type of lists of natural numbers:

```juvix extract-module-statements 1
module NList;
  import Stdlib.Prelude open;

  type NList :=
    | nnil : NList
    | ncons : Nat -> NList -> NList;
  end;
  ```

An element of `NList` is either `nnil` (empty) or `ncons x xs` where `x : Nat`
and `xs : NList` (a list with head `x` and tail `xs`).

A function computing the length of a list may be defined by:

```juvix extract-module-statements 2
module NLength;
  import Stdlib.Prelude open;
  open NList;

  nlength : NList -> Nat
    | nnil := 0
    | (ncons _ xs) := nlength xs + 1;
end;
```

The definition follows the inductive definition of `NList`. There are two
function clauses for the two constructors. The case for `nnil` is easy – the
constructor has no arguments and the length of the empty list is `0`. For a
constructor with some arguments, one typically needs to express the result of
the function in terms of the constructor arguments, usually calling the function
recursively on the constructor's inductive arguments (for `ncons` this is the
second argument). In the case of `ncons _ xs`, we recursively call `nlength` on
`xs` and add `1` to the result.

Let's consider another example – a function which returns the maximum of the
numbers in a list or 0 for the empty list.

```juvix extract-module-statements 2
module NMaximum;
  import Stdlib.Prelude open;
  open NList;

    nmaximum : NList -> Nat
    | nnil := 0
    | (ncons x xs) := max x (nmaximum xs);
end;
```

Again, there is a clause for each constructor. In the case for `ncons`, we
recursively call the function on the list tail and take the maximum of the
result and the list head.

For an example of a constructor with more than one inductive argument, consider
binary trees with natural numbers in nodes.

```juvix extract-module-statements 1
module Tree;
  open Nat;

    type Tree :=
    | leaf : Nat -> Tree
    | node : Nat -> Tree -> Tree -> Tree;
end;
```

The constructor `node` has two inductive arguments (the second and the third)
which represent the left and the right subtree.

A function which produces the mirror image of a tree may be defined by:

```juvix extract-module-statements 1
module Mirror;
  open Tree;

    mirror : Tree -> Tree
    | (leaf x) := leaf x
    | (node x l r) := node x (mirror r) (mirror l);
end;
```

The definition of `mirror` follows the definition of `Tree`. There are two
recursive calls for the two inductive constructors of `node` (the subtrees).

## Partial application and higher-order functions

Strictly speaking, all Juvix functions have only one argument. Multi-argument
functions are really functions which return a function which takes the next
argument and returns a function taking another argument, and so on for all
arguments. The function type former `->` (the arrow) is right-associative.
Hence, the type, e.g., `Nat -> Nat -> Nat` when fully parenthesised becomes `Nat
-> (Nat -> Nat)`. It is the type of functions which given an argument of type
`Nat` return a function of type `Nat -> Nat` which itself takes an argument of
type `Nat` and produces a result of type `Nat`. Function application is
left-associative. For example, `f a b` when fully parenthesised becomes `(f a)
b`. So it is an application to `b` of the function obtained by applying `f` to
`a`.

Since a multi-argument function is just a one-argument function returning a
function, it can be _partially applied_ to a smaller number of arguments than
specified in its definition. The result is an appropriate function. For example,
`sub 10` is a function which subtracts its argument from `10`, and `(+) 1` is a
function which adds `1` to its argument. If the function has been declared as an
infix operator (like `+`), then for partial application one needs to enclose it
in parentheses.

A function which takes a function as an argument is a _higher-order function_.
An example is the `nmap` function which applies a given function to each element
in a list of natural numbers.

```juvix extract-module-statements 2
module NMap;
  import Stdlib.Prelude open;
  open NList;

  nmap (f : Nat -> Nat) : NList -> NList
    | nnil := nnil
    | (ncons x xs) := ncons (f x) (nmap f xs);
end;
```

The application

```text
nmap \{x := div x 2} lst
```

divides every element of `lst` by `2`, rounding down the result. The expression

```text
\{x := div x 2}
```

is an unnamed function, or a _lambda_, which divides its argument by `2`.

## Polymorphism

The type `NList` we have been working with above requires the list elements to
be natural numbers. It is possible to define lists _polymorphically_,
parameterising them by the element type. This is similar to generics in
languages like Java, C++ or Rust. Here is the polymorphic definition of lists
from the standard library:

```juvix extract-module-statements 1
module List;
  import Stdlib.Data.Fixity open;

  syntax operator :: cons;
  type List A :=
    | nil : List A
    | :: : A -> List A -> List A;
end
```

The constructor `::` is declared as a right-associative infix operator. The
definition has a parameter `A` which is the element type. Then `List Ty` is the
type of lists with elements of type `Ty`. For example, `List Nat` is the type of
lists of natural numbers, isomorphic to the type `NList` defined above.

Now one can define the `map` function polymorphically:

```juvix extract-module-statements 1
module Map;
  open List;

  map {A B} (f : A -> B) : List A -> List B
    | nil := nil
    | (h :: hs) := f h :: map f hs;
end;
```

This function has two _implicit type arguments_ `A` and `B`. These arguments are
normally omitted in function application – they are inferred automatically
during type checking. The curly braces indicate that the argument is implicit
and should be inferred.

In fact, the constructors `nil` and `::` also have an implicit argument: the
type of list elements. All type parameters of a data type definition become
implicit arguments of the constructors.

Usually, the implicit arguments in a function application can be inferred.
However, sometimes this is not possible and then the implicit arguments need to
be provided explicitly by enclosing them in braces:

```text
f {implArg1} .. {implArgK} arg1 .. argN
```

For example, `nil {Nat}` has type `List Nat` while `nil` by itself has type `{A : Type} -> List A`.

## Tail recursion

Any recursive call whose result is further processed by the calling function
needs to create a new stack frame to save the calling function environment. This
means that each such call will use a constant amount of memory. For example, a
function `sum` implemented as follows will use an additional amount of memory
proportional to the length of the processed list:

```juvix extract-module-statements 1
module List-Sum;
  import Stdlib.Prelude open;

  sum : List Nat -> Nat
    | nil := 0
    | (x :: xs) := x + sum xs;
end;
```

This is not acceptable if you care about performance. In an imperative language,
one would use a simple loop going over the list without any memory allocation.
In pseudocode:

```delphi
var sum : Nat := 0;

while (lst /= nil) do
begin
  sum := sum + head lst;
  lst := tail lst;
end;

result := sum;
```

Fortunately, it is possible to rewrite this function to use _tail recursion_. A
recursive call is _tail recursive_ if its result is also the result of the
calling function, i.e., the calling function returns immediately after it
without further processing. The Juvix compiler _guarantees_ that all tail calls
will be eliminated, i.e., that they will be compiled to simple jumps without
extra memory allocation. In a tail recursive call, instead of creating a new
stack frame, the old one is reused.

The following implementation of `sum` uses tail recursion.

```juvix extract-module-statements 1
module List-Sum-Tail;
  import Stdlib.Prelude open;

  sum (lst : List Nat) : Nat :=
    let
      go (acc : Nat) : List Nat -> Nat
        | nil := acc
        | (x :: xs) := go (acc + x) xs;
    in go 0 lst;
end;
```

The first argument of `go` is an _accumulator_ which holds the sum computed so
far. It is analogous to the `sum` variable in the imperative loop above. The
initial value of the accumulator is 0. The function `go` uses only constant
additional memory overall. The code generated for it by the Juvix compiler is
equivalent to an imperative loop.

Most imperative loops may be translated into tail recursive functional programs
by converting the locally modified variables into accumulators and the loop
condition into pattern matching. For example, here is an imperative pseudocode
for computing the nth Fibonacci number in linear time. The variables `cur` and
`next` hold the last two computed Fibonacci numbers.

```delphi
var cur : Nat := 0;
var next : Nat := 1;

while (n /= 0) do
begin
  tmp := next;
  next := cur + next;
  cur := tmp;
  n := n - 1;
end;

result := cur;
```

An equivalent functional program is:

```juvix extract-module-statements 1
module Fibonacci-tail;
  import Stdlib.Prelude open;

  fib : Nat -> Nat :=
      let
        go (cur next : Nat) : Nat -> Nat
          | zero := cur
          | (suc n) := go next (cur + next) n;
      in go 0 1;
end;
```

A naive definition of the Fibonacci function runs in exponential time:

```juvix extract-module-statements 1
module Fibonacci-Pattern;
  import Stdlib.Prelude open;

    fib : Nat -> Nat
      | zero := 0
      | (suc zero) := 1
      | (suc (suc n)) := fib n + fib (suc n);
end;
```

Tail recursion is less useful when the function needs to allocate memory anyway.
For example, one could make the `map` function from the previous section tail
recursive, but the time and memory use would still be proportional to the length
of the input because of the need to allocate the result list. In fact, a tail
recursive `map` needs to allocate and discard an intermediate list which is
reversed in the end to preserve the original element order:

```juvix extract-module-statements 1
module List-Map-Tail;
  import Stdlib.Prelude open hiding {map};

  map {A B} (f : A -> B) : List A -> List B :=
      let
        go (acc : List B) : List A -> List B
          | nil := reverse acc
          | (x :: xs) := go (f x :: acc) xs;
      in go nil;
end;
```

So we have replaced stack allocation with heap allocation. This actually
decreases performance.

### Conclusion

- Use tail recursion to eliminate stack allocation.
- Do not use tail recursion to replace stack allocation with heap allocation.

## Iteration over data structures

A common use of recursion is to traverse a data structure in a specified order
accumulating some values. For example, the tail recursive `sum` function fits
this pattern.

Juvix provides special support for data structure traversals with the iterator
syntax. The standard library defines several list iterators, among them `for`
and `rfor`. We can implement the `sum` function using `for`:

```juvix extract-module-statements 1
module List-Sum-For;
  import Stdlib.Prelude open;

  sum (l : List Nat) : Nat :=
    for (acc := 0) (x in l) {x + acc};
end;
```

The above `for` iteration starts with the accumulator `acc` equal to `0` and
goes through the list `l` from left to right (from beginning to end), at each
step updating the accumulator to `x + acc` where `x` is the current list element
and `acc` is the previous accumulator value. The final value of the iteration is
the final value of the accumulator. The `for` iterator is tail recursive, i.e.,
no stack memory is allocated and the whole iteration is compiled to a loop.

The `rfor` iterator is analogous to `for` except that it goes through the list
from right to left (from end to beginning) and is not tail recursive. For
example, one can implement `map` using `rfor`:

```juvix extract-module-statements 1
module List-Map-rfor;
  import Stdlib.Prelude open hiding {map};

  map {A B} (f : A -> B) (l : List A) : List B :=
    rfor (acc := nil) (x in l) {f x :: acc};
end;
```

The iterators are just ordinary higher-order Juvix functions which can be used
with the iterator syntax. In fact, the `map` function from the standard library
can also be used with the iterator syntax. The expression

```text
map (x in l) {body}
```

is equivalent to

```text
map \{x := body} l
```

Whenever possible, it is advised to use the standard library iterators instead
of manually writing recursive functions. When reasonable, `for` should be
preferred to `rfor`. The iterators provide a readable syntax and the compiler
might be able to optimize them better than manually written recursion.

## Totality checking

By default, the Juvix compiler requires all functions to be _total_. Totality
consists of:

- [termination](../explanations/totality/termination.md) and
  [coverage](../explanations/totality/coverage.md) for function declarations,
  and
- [strict positivity](../explanations/totality/positive.md) for user-defined
  data types.

The termination check ensures that all functions are structurally recursive,
i.e., all recursive calls are on structurally smaller values – subpatterns of
the matched pattern.

However, we can still make Juvix accept a non-terminating function via the
`terminating` keyword, skipping the termination check.

```juvix extract-module-statements 1
module Non-Terminating-Log;
  import Stdlib.Prelude open;

  terminating
  log2 (n : Nat) : Nat :=
    if
      | n <= 1 := 0
      | else := suc (log2 (div n 2));
end;
```

Let us look at other examples. The termination checker rejects the
following definition of the factorial function (when the `terminating`
keyword is removed):

```juvix extract-module-statements 1
module Fact-Non-Terminating;
  import Stdlib.Prelude open;

  -- remove `terminating` to see the error
  terminating
  fact (x : Nat) : Nat :=
    if
      | x == 0 := 1
      | else := x * fact (sub x 1);
end;
```

To ensure termination, the argument to the recursive call must be a
proper subpattern of a pattern matched on in the clause. One can
reformulate this definition so that it is accepted by the termination
checker:

```juvix extract-module-statements 1
module Fact-Terminating;
  import Stdlib.Prelude open;

  fact : Nat -> Nat
    | zero := 1
    | x@(suc n) := x * fact n;
end;
```

Coverage checking ensures that there are no unhandled patterns in function
clauses or `case` expressions. For example, the following definition is rejected
because the case `suc zero` is not handled:

```
  isEven : Nat -> Bool
    | zero := true
    | (suc (suc n)) := isEven n;
```

Since coverage checking forces the user to specify the function for all input
values, it may be unclear how to implement functions which are typically
partial. For example, the `tail` function on lists is often left undefined for
the empty list. One solution is to return a default value. In the Juvix standard
library, `tail` is implemented as follows, returning the empty list when the
argument is empty.

```juvix extract-module-statements 1
module List-Tail;
  open List;

  tail {A} : List A -> List A
    | (_ :: xs) := xs
    | nil := nil;
end;
```

Another solution is to wrap the result in the `Maybe` type from the standard
library, which allows representing optional values. An element of `Maybe A` is
either `nothing` or `just x` with `x : A`.

```juvix extract-module-statements
module Maybe;

  type Maybe A :=
    | nothing : Maybe A
    | just : A -> Maybe A;
end;
```

For example, one could define the tail function as:

```juvix extract-module-statements 2
module Maybe-List-Tail;
  open List;
  open Maybe;

  tail {A} : List A -> Maybe (List A)
    | (_ :: xs) := just xs
    | nil := nothing;
end;
```

Then the user needs to explicitly check if the result of the function contains a
value or not:

```text
case tail' lst of
| just x := ...
| nothing := ...
```

## Exercises

You have now learnt essential functional programming techniques in
Juvix. To consolidate your understanding, try doing some of the
following exercises.

<!-- Include solutions as details -->

### Warm-up exercises

#### Boolean operators

Let's start by defining some functions on booleans.

The type for booleans is defined in the standard library like this:

```juvix extract-module-statements
module Bool-Ex;

  type Bool :=
    | true : Bool
    | false : Bool;
end;
```

Remember that you can import this definition by adding `import Stdlib.Prelude
open` at the beginning of your module.

Now, define the logical function `not` by using pattern matching.

!!! tip

      The type of your function should be:

      ```text
              not : Bool -> Bool;
      ```

Now, define the logical functions `and`, `or` by using pattern matching as well.
Feel free to experiment and see what happens if your patterns are not
exhaustive, i.e., if not all the cases are covered.

Next, let's define the logical function `xor`, which should return `true` if and
only if exactly one of its arguments is `true`. This time, instead of using
pattern matching, use the previously defined logical functions.

!!! tip

      Be wary of using the standard library here as it may cause name conflicts.


??? info "Solution"

    ```juvix extract-module-statements
    module SolBool;

      type Bool :=
        | true : Bool
        | false : Bool;

      not : Bool -> Bool
        | false := true
        | true := false;

      or : Bool -> Bool -> Bool
        | false b := b
        | true _ := true;

      and : Bool -> Bool -> Bool
        | true b := b
        | false _ := false;

      xor (a b : Bool) : Bool := and (not (and a b)) (or a b);
  end; ```

#### The `Maybe` type

The `NMaybe` type encapsulates an optional natural number (the preceding `N`
stands for `Nat`). The `nnothing` constructor is used when the value is missing.
On the other hand, the `njust` constructor is used when the value is present.

```juvix extract-module-statements 1
module NMaybe;
  import Stdlib.Prelude open;

  type NMaybe :=
    | nnothing : NMaybe
    | njust : Nat → NMaybe;
end;
```

Let's define a function `isJust : NMaybe -> Bool` that returns `true` when the
value is present.

??? info "Solution"

    ```juvix extract-module-statements 1
      module SolNMaybe-Just;
        import Stdlib.Prelude open;

        type NMaybe :=
          | nnothing : NMaybe
          | njust : Nat → NMaybe;

        isJust : NMaybe -> Bool
          | (njust _) := true
          | nnothing := false;
    end;
    ```

Now let's define a function `fromMaybe : Nat -> NMaybe -> Nat` that given a
`NMaybe`, returns its value if present and otherwise returns the first argument
as a default value.

??? info "Solution"

    ```juvix extract-module-statements 1
    module SolNMaybe-From;
      import Stdlib.Prelude open;

      type NMaybe :=
        | nnothing : NMaybe
        | njust : Nat → NMaybe;

      fromMaybe (d : Nat) : NMaybe -> Nat
        | (njust n) := n
        | nnothing := d;
    end;
    ```

It would be useful to have a type that represents optional values of any type.
In Juvix, we can define the polymorphic version of `NMaybe` like this:

```juvix extract-module-statements
module NMaybe-Poly;

  type Maybe A :=
    | nothing : Maybe A
    | just : A → Maybe A;
end;
```

In this definition, we parameterize the type `Maybe` with a generic type `A`.

Implement again the `fromMaybe` function, but now, for the polymorphic `Maybe`
type. Note that in function definitions we must specify the type variables. The
definition of `fromMaybe` begins with:

```text
fromMaybe {A} (d : A) : Maybe A -> A
```

Give the implementation.

??? info "Solution"

    ```juvix extract-module-statements
    module SolNMaybe-Poly-From;
      import Stdlib.Prelude open;

      fromMaybe {A} (d : A) : Maybe A -> A
        | (just n) := n
        | nothing := d;
    end;
    ```

Neat! It is indeed very easy to define polymorphic functions in Juvix.

To get some more practice, give an implementation for `maybe` which begins with:

```text
maybe {A B} (d : B) (f : A -> B) : Maybe A -> B
```

This should return the value (if present) applied to the function `f`. Otherwise
it should return the default value `d`.

??? info "Solution"

    ```juvix extract-module-statements
    module SolMaybe-Maybe;
      import Stdlib.Prelude open;

      maybe {A B} (d : B) (f : A -> B) : Maybe A -> B
        | (just n) := f n
        | nothing := d;
    end;
    ```

#### List exercises

We can define polymorphic lists as follows:

```juvix extract-module-statements
module List-Ex;
  import Stdlib.Data.Fixity open;

  syntax operator :: cons;
  type List A :=
    | nil : List A
    | :: : A -> List A -> List A;
end;
```

Let's define a function that returns the first element of a `List` if it exists.

Is beginning the definition as follows appropriate? If not, why?

```text
head {A} : List A -> A
```

Try to give an implementation for it.

??? info "Solution"

    As we know, Juvix guarantees that all functions are total.
    But we cannot return anything when the list is empty.
    Therefore it makes sense to use the `Maybe` type that we defined in the previous section.
    The proper definition of `head` should be:

    ```juvix extract-module-statements
    module Sol-Head;
      import Stdlib.Prelude open;

      head {A} : List A -> Maybe A
        | nil := nothing
        | (h :: _) := just h;
    end;
    ```

So far we have defined only functions that do not involve looping, but any
non-trivial program will require some sort of repetition, so let's tackle that.

As stated previously, the only way to express repetition in Juivx is by using
_recursion_. We say that a function is recursive if it is defined in terms of
itself, i.e., the name of the function appears in its body.

The next exercise is to define a function which returns the last element of a
list. This function will need to call itself until it reaches the last element
of the list.

```text
last {A} : List A -> Maybe A;
```

??? info "Solution"

    ```juvix extract-module-statements
    module Sol-Last;
      import Stdlib.Prelude open;

      last {A} : List A -> Maybe A
        | nil := nothing
        | (x :: nil) := just x
        | (_ :: xs) := last xs;
    end;
    ```

Next, implement a function that concatenates two lists:

```text
  concat {A} : List A -> List A -> List A
```

!!! tip

    It is enough to pattern match the first list.

??? info "Solution"

    ```juvix extract-module-statements
    module Sol-Concat;
      import Stdlib.Prelude open;

      concat {A} : List A -> List A -> List A
        | nil b := b
        | (a :: as) b := a :: concat as b;
    end;
    ```

Now write a function that concatenates a list of lists.

```text
  concatMany {A} : List (List A) -> List A
```

!!! tip

    `concat` may be helpful.

??? info "Solution"

    ```juvix extract-module-statements
    module Sol-Concat-Many;
      import Stdlib.Prelude open;

      concat {A} : List A -> List A -> List A
        | nil b := b
        | (a :: as) b := a :: concat as b;

      concatMany {A} : List (List A) -> List A
        | nil := nil
        | (a :: as) := concat a (concatMany as);
    end;
    ```

Can you give an alternative implementation that uses the `rfor` iterator? What
would happen if you used `for` instead of `rfor`?

??? info "Solution"

    ```juvix extract-module-statements
    module Sol-Concat-rfor;
      import Stdlib.Prelude open;
      import Stdlib.Data.Fixity open;

      concat {A} : List A -> List A -> List A
        | nil b := b
        | (a :: as) b := a :: concat as b;

      concatMany-iter {A} (m : List (List A)) : List A :=
        rfor (acc := nil) (l in m)
        concat l acc;
    end;
    ```

In the previous solution, if you replace `rfor` by `for`, the resulting list
will be as if the original list was reversed, but each of the nested lists keep
their original order.

Write a function that reverses a list:

- using the `for` iterator,
- using tail recursion.

??? info "Solution"

    Using the `for` iterator:

    ```juvix extract-module-statements
    module Sol-Reverse-For;
      import Stdlib.Prelude open;

      reverse {A} (xs : List A) : List A :=
        for (acc := nil) (x in xs) {x :: acc};
    end;
    ```

    Using tail recursion:

    ```juvix extract-module-statements
    module Sol-Reverse-Tail;
      import Stdlib.Prelude open;

      reverse {A} : List A -> List A :=
      let
        go (acc : List A) : List A -> List A
          | nil := acc
          | (x :: xs) := go (x :: acc) xs;
      in go nil;
    end;
    ```

#### Function composition

Let's try a different exercise. Define a function `compose` that composes two
functions `f` and `g`. It should take three arguments `f`, `g`, `x` and its only
clause's body should be `f (g x)`.

Can you make the `compose` function polymorphic and as general as possible?

??? hint

    The definition should start like this:

    ```text
        compose {A B C} ...
    ```

??? info "Solution"

    ```juvix extract-module-statements
    module Sol-Compose;

      compose {A B C} (f : B -> C) (g : A -> B) (x : A) : C :=
        f (g x);
    end;
    ```

Congratulations! Your warm-up is complete!

### More exercises

#### Prime numbers

Define a function `prime : Nat -> Bool` which checks if a given natural number
is prime.

!!! tip

    A number is prime if it is greater than 1 and has no divisors
    other than 1 and itself.

??? info "Solution"

    ```juvix extract-module-statements
    module Sol-Prime;
      import Stdlib.Prelude open;

      prime (x : Nat) : Bool :=
      let
        go : Nat -> Bool
          | zero := true
          | (suc zero) := true
          | n@(suc k) :=
            if
              | mod x k == 0 := false
              | else := go k;
      in case x of
           | zero := false
           | suc zero := false
           | suc k := go k;
    end;
    ```

#### Half

Does Juvix accept the following definition?

```text
half : Nat -> Nat :=
  if
    | n < 2 := 0
    | else := half (sub n 2) + 1;
```

If not, how can you reformulate this definition so that it is accepted by Juvix?

??? info "Solution"

    The definition doesn't pass the termination checker.
    One way to reformulate it is as follows:

    ```juvix extract-module-statements
    module Sol-Half;
      import Stdlib.Prelude open;

      half : Nat -> Nat
      | zero := 0
      | (suc zero) := 0
      | (suc (suc n)) := half n + 1;
    end;
    ```

#### Tree map

Recall the `Tree` type from above.

```juvix extract-module-statements
module Tree-Ex;
  import Stdlib.Prelude open;

  type Tree :=
    | leaf : Nat -> Tree
    | node : Nat -> Tree -> Tree -> Tree;
end;
```

Analogously to the `map` function for lists, define a function

```text
tmap : (Nat -> Nat) -> Tree -> Tree;
```

which applies a function to all natural numbers stored in a tree.

??? info "Solution"

    ```juvix extract-module-statements
    module Sol-Tree;
      import Stdlib.Prelude open;

      type Tree :=
        | leaf : Nat -> Tree
        | node : Nat -> Tree -> Tree -> Tree;

      tmap (f : Nat -> Nat) : Tree -> Tree
        | (leaf x) := leaf (f x)
        | (node x l r) := node (f x) (tmap f l) (tmap f r);
    end;
    ```

#### Polymorphic tree

Modify the `Tree` type to be polymorphic in the element type, and then
repeat the previous exercise.

??? info "Solution"

    The `Tree` type and the `tmap` function need to be made polymorphic in the element types.

    ```juvix extract-module-statements
    module Sol-Tree-Poly;

      type Tree A :=
        | leaf : A -> Tree A
        | node : A -> Tree A -> Tree A -> Tree A;

      tmap {A B} (f : A -> B) : Tree A -> Tree B
        | (leaf x) := leaf (f x)
        | (node x l r) := node (f x) (tmap f l) (tmap f r);
    end;
    ```

    Note that only the types needed to be changed.

#### Suffixes

A _suffix_ of a list `l` is any list which can be obtained from `l` by removing
some initial elements. For example, the suffixes of `1 :: 2 :: 3 :: nil` are:

- `1 :: 2 :: 3 :: nil`,
- `2 :: 3 :: nil`,
- `3 :: nil`, and
- `nil`.

Define a function which computes the list of all suffixes of a given list,
arranged in descending order of their lengths.

??? info "Solution"

    ```juvix extract-module-statements
    module Sol-Suffixes;
      import Stdlib.Prelude open;

      suffixes {A} : List A -> List (List A)
        | nil := nil :: nil
        | xs@(_ :: xs') := xs :: suffixes xs';
    end;
    ```

#### Factorial

Write a tail recursive function which computes the factorial of a natural
number.

??? info "Solution"

    ```juvix extract-module-statements
    module Sol-Factorial;
      import Stdlib.Prelude open;

      fact : Nat -> Nat :=
      let
        go (acc : Nat) : Nat -> Nat
          | zero := acc
          | n@(suc n') := go (acc * n) n';
      in go 1;
    end;
    ```

#### List function compose

Define a function

```text
comp {A} : List (A -> A) -> A -> A
```

which composes all functions in a list. For example,

```text
comp (suc :: (*) 2 :: \{x := sub x 1} :: nil)
```

should be a function which given `x` computes `2(x - 1) + 1`.

??? info "Solution"

    ```juvix extract-module-statements
    module Sol-Comp;
      import Stdlib.Prelude open;

      comp {A} (fs : List (A -> A)) : A -> A :=
      for (acc := id) (f in fs) {f >> acc};
    end;
    ```

    where `>>` is the composition function from the standard library:

    ```juvix extract-module-statements
    module Comp-Syntax;
      import Stdlib.Data.Fixity open;

      syntax operator >> composition;
      >> {A B C} (f : B -> C) (g : A -> B) (x : A) : C := f (g x);
    end;
    ```
