---
date: 2022-07-25
authors: 
  - jonathan
categories:
  - implementation-notes
---

# Strictly positive data types

We follow a syntactic description of strictly positive inductive data types.

An inductive type is considered strictly positive if it either does not appear or appears strictly positively within the argument types of its constructors. A name is deemed strictly positive for an inductive type when it never appears in a negative position within the argument types of its constructors. A negative position refers to occurrences situated to the left of an arrow in a type constructor argument.

In the example below, the type `X` occurs strictly positive in `c0` and
negatively at the constructor `c1`. Therefore, `X` is not strictly
positive.

```juvix
axiom B : Type;
type X :=
    c0 : (B -> X) -> X
  | c1 : (X -> X) -> X;
```

We could also refer to positive parameters as such parameters occurring
in no negative positions. For example, the type `B` in the `c0`
constructor above is on the left of the arrow `B->X`. Then, `B` is at a
negative position. Negative parameters need to be considered when
checking strictly positive data types as they may allow defining
non-strictly positive data types.

In the example below, the type `T0` is strictly positive. However, the
type `T1` is not. Only after unfolding the type application `T0 (T1 A)`
in the data constructor `c1`, we can find out that `T1` occurs at a
negative position because of `T0`. More precisely, the type parameter
`A` of `T0` is negative.

```juvix
type T0 (A : Type) := c0 : (A -> T0 A) -> T0 A;

type T1 := c1 : T0 T1 -> T1;
```

## Bypass the strict positivity condition

To bypass the positivity check, a data type declaration can be annotated
with the keyword `positive`. Another way is to use the CLI global flag
`--no-positivity` when type checking a `Juvix` File.

```juvix
$ cat tests/negative/MicroJuvix/NoStrictlyPositiveDataTypes/E5.mjuvix
module E5;
  positive
  type T0 (A : Type) :=
    c0 : (T0 A -> A) -> T0 A;
end;
```

## Examples of non-strictly data types

- `Bad` is not strictly positive because of the negative parameter
  `A` of `Tree`.

```juvix
type Tree (A : Type) :=
    leaf : Tree A
  | node : (A -> Tree A) -> Tree A;

type Bad :=
  bad : Tree Bad -> Bad;
```

- `A` is a negative parameter.

```juvix
type B (A : Type) :=
  b : (A -> B (B A -> A)) -> B A;
```
