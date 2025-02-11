---
date: 2022-07-25
readtime: 5
authors:
  - jonathan
categories:
  - type-system
tags:
  - type-system
  - inductive-types
links:
  - Coq's Inductive Types: https://coq.inria.fr/distrib/current/refman/language/core/inductive.html
  - FStar's Inductive Type Families: https://www.fstar-lang.org/tutorial/book/part2/part2_inductive_type_families.html
---

# Stay Positive

Let us explore the concept of strictly positive inductive data types, a critical requirement within the Juvix framework for classifying a data type as well-typed.

An **inductive type** is considered _strictly positive_ if it either:

1. Does not appear within the argument types of its constructors, or
2. Appears strictly positively within the argument types of its constructors.

A name is considered strictly positive for an inductive type if it never appears
in a negative position within the argument types of its constructors. The term
_negative position_ denotes instances located to the left of an arrow in a type
constructor argument.

<!-- more -->

## Example

Consider the following data type `X` where `A` and `B` are types in scope:

```juvix
--8<------ "docs/blog/posts/strictly-positive-data-types/Main.juvix:typeX"
```

In this example, the type `X` occurs strictly positively in the constructor `c0`,
but negatively in the constructor `c1` in the type argument `X -> A`. Therefore,
`X` is not strictly positive.

Positive parameters can also be described as those that do not occur in negative
positions. For instance, the type `B` in the `c0` constructor above appears to
the left of the arrow `B->X`, placing `B` in a negative position. It is
essential to consider negative parameters when verifying strictly positive data
types, as they might enable the definition of non-strictly positive data types.

Let us consider another example:

```juvix
--8<------ "docs/blog/posts/strictly-positive-data-types/Main.juvix:typeT0"
```

```juvix
--8<------ "docs/blog/posts/strictly-positive-data-types/Main.juvix:typeT1"
```

In this example, the type `T0` is strictly positive, while the type `T1` is not.
It is only after unfolding the type application `T0 T1` in the data
constructor `c1` that we can determine `T1` occurs in a negative position due to
`T0`. More specifically, the type parameter `A` of `T0` is negative.

## Bypassing the Strict Positivity Condition

To bypass the positivity check in a data type declaration, you can annotate it
with the `positive` keyword. Alternatively, you can use the CLI global flag
`--no-positivity` when type checking a `Juvix` file.

```juvix
--8<------ "docs/blog/posts/strictly-positive-data-types/Main.juvix:positive-keyword"
```

## Examples of Non-Strictly Positive Data Types

- The `Bad` data type is not strictly positive due to the negative parameter `A`
  of `Tree`.

```juvix
--8<------ "docs/blog/posts/strictly-positive-data-types/Main.juvix:Tree"
```

```juvix
--8<------ "docs/blog/posts/strictly-positive-data-types/Main.juvix:Bad"
```

- `A` is a negative parameter.

```juvix
--8<------ "docs/blog/posts/strictly-positive-data-types/Main.juvix:Bad2"
```
