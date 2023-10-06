---
icon: material/equal
comments: false
search:
  boost: 3
---


# Local Definitions

Local definitions in Juvix are facilitated by the `let` expression. This feature
is particularly beneficial for defining identifiers that are exclusive to a
single scope.

## Syntax of `let` Expression

The syntax for a `let` binding is as follows:

```text
--8<-- "docs/reference/language/syntax.md:let-syntax"
```

In this syntax:

- `{name}` refers to the name of the variable you want to define and should be a
  valid identifier accompanied by a type annotation.
- `{term}` is the value or computation assigned to the identifier.
- `{body}` represents the section of code where this local definition is valid.

Here's an example:

```juvix
--8<-- "docs/reference/language/lets.juvix:let-sum"
```

In this case, `x` is the identifier, `5` is the expression, and `x * x` is the
body. The result of this code would be `25`.
