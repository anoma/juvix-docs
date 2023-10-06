---
icon: material/face-recognition
comments: false
search:
  boost: 3
---

# Traits

A trait is a special type of [record](./records.md) that can be used to define a
set of functions that must be implemented for a given type.

## Syntax

### Trait declarations

Traits are declared
using the `trait` keyword, followed by a record type declaration.

```text
trait
--8<------ "docs/reference/language/syntax.md:record-syntax"
```

For example, the following defines a trait `Show`. Any type `A` that implements
`Show` must provide a function `show` that takes an `A` and returns a `String`.

```juvix
--8<------ "docs/reference/language/traitShow.juvix:show"
```

### Instance declarations

An instance of a trait refers to a term of the corresponding record type, which
must implement all methods stipulated by the trait.

To declare a given term is an instance of a trait, we use the `instance`
keyword. To define an instance of a trait, we use the trait constructor of the
corresponding record type.

```text
--8<------ "docs/reference/language/syntax.md:instance-syntax"
```

For example, we could define three instances of `Show` for `String`, `Bool`, and
`Nat` as follows:

```juvix
--8<------ "docs/reference/language/traitShow.juvix:showInstances"
```

One more involved example is the following, which defines an instance of `Show`
for the type of lists:

```juvix
--8<------ "docs/reference/language/traitShow.juvix:showList"
```

## Usage

Using the `Show` trait defined above, we can define a function `showNat` that
takes a `Nat` and returns a `String`. One possible implementation is the
following:

```juvix
--8<------ "docs/reference/language/traits.juvix:usage"
```

To prevent looping during instance search, we ensure a structural decrease in
the trait parameters of instance types. Therefore, the following is rejected:

```juvix
type Box A := box A;

trait
type T A := mkT { pp : A → A };

instance
boxT {A} : {{T (Box A)}} → T (Box A) := mkT (λ{x := x});
```

We check whether each parameter is a strict subterm of some trait parameter in
the target. This ordering is included in the finite multiset extension of the
subterm ordering, hence terminating.

- Matching on implicit instances

It is possible to manually provide an instance and to match on implicit
instances, as shown below:

```juvix
--8<------ "docs/reference/language/traitShow.juvix:implicit"
```

Finally, using the `Show` trait and the function `printStringLn` and `IO` from
the standard library, we could use the instances of `Show` as follows:

```juvix
--8<------ "docs/reference/language/traitShow.juvix:main"
```
