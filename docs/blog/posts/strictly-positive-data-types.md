---
date: 2022-07-25
authors:
  - jonathan
categories:
  - implementation-notes
---

# Stay Positive with Your Data Types

In this blog post, we will investigate the notion of strictly positive inductive
data types, which is a condition that Juvix mandates for a data type to be
considered well-typed.

An **inductive type** is considered _strictly positive_ if it either:

1. Does not appear within the argument types of its constructors, or
2. Appears strictly positively within the argument types of its constructors.

A name is considered strictly positive for an inductive type if it never appears
in a negative position within the argument types of its constructors. The term
_negative position_ denotes instances located to the left of an arrow in a type
constructor argument.

## Example

Consider the following data type `X` where `A` and `B` are types in scope:

```juvix
--8<------ "docs/blog/posts/strictly-positive-data-types/Main.juvix:typeX"
```

In this example, the type `X` occurs strictly positive in the constructor `c0`,
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
It is only after unfolding the type application `T0 (T1 A)` in the data
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
