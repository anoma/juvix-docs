---
icon: material/equal
comments: false
search:
  boost: 3
---

```juvix hide
module reference.language.lets;
import Stdlib.Prelude open;
```

# Local Definitions

Local definitions in Juvix are facilitated by the `let` expression. This feature
is particularly beneficial for defining identifiers that are exclusive to a
single scope.

## Syntax of `let` Expression

The basic syntax of a `let` binding is as follows:

```text
--8<-- "docs/reference/language/syntax.md:let-syntax"
```

In this syntax:

- `{name}` refers to the name of the variable you want to define and should be a
  valid identifier of type `<type>`.
- `{term}` is the value or computation assigned to the identifier.
- `{body}` represents the section of code where this local definition is valid.

Here's an example:

```juvix
value : Nat :=
  let x : Nat := 5 in x * x;
```

In this case, `x` is the identifier, `5` is the expression, and `x * x` is the
body. The result of this code would be `25`.

In case of simple let-bindings as above, the type may be omitted:

```juvix
value' : Nat :=
  let x := 5 in x * x;
```

In fact, Juvix allows multiple definitions in a single let-expression
with the syntax of the definitions exactly the same as for top-level
function definitions. For example:

```juvix
sum (lst : List Nat) : Nat :=
  let
    go (acc : Nat) : List Nat -> Nat
      | nil := acc
      | (x :: xs) := go (acc + x) xs;
  in go 0 lst;
```

Another example with multiple definitions:

```juvix
isEven (n : Nat) : Bool :=
  let
    isEven' : Nat -> Bool
      | zero := true
      | (suc n) := isOdd' n;
    isOdd' : Nat -> Bool
      | zero := false
      | (suc n) := isEven' n;
  in isEven' n;
```

The functions `isEven'` and `isOdd'` are not visible outside the body of `isEven`.
