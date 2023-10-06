---
icon: material/car-traction-control
comments: false
search:
  boost: 3
---

# Control Structures

Juvix utilizes control structures such as case expressions and lazy built-ins to
manage the flow of execution. The following sections provide an in-depth
understanding of these features.

## Case Expressions

A case expression in Juvix is a powerful tool that enables the execution of
different actions based on the *pattern* of the input expression. It provides a
way to match complex patterns and perform corresponding operations, thereby
enhancing code readability and maintainability.

### Syntax

A case expression in Juvix is defined as follows:

```text
--8<-- "docs/reference/language/syntax.md:case-syntax"
```

In this syntax:
- `<expression>` is the value against which you want to match patterns.
- `<pattern1>` through `<patternN>` are the patterns you're checking against the
  given expression.
- `<branch1>` through `<branchN>` are the respective actions or results that
  will be returned when their corresponding patterns match the input expression.

### Example

Consider the following case expression in Juvix:

```juvix
Stdlib.Prelude> case 2 of { | zero := 0 | suc x := x }
```

In this example, the input expression is `2`. The case expression checks this
input against each pattern (`zero` and `suc x`) in order. Since `2` does not
match the pattern `zero`, it moves on to the next pattern `suc x`. This pattern
matches the input `2`, where `x` equals `1`. Therefore, the corresponding branch
`x` is executed, and `1` is returned.

Thus, when evaluated, this expression returns `1`.

By using case expressions, you can write more expressive and flexible code in
Juvix. They allow for intricate pattern matching and branching logic that can
simplify complex programming tasks.

## Lazy Built-in Functions

Juvix provides several lazily evaluated built-in functions in its standard
library. These functions do not evaluate their arguments until absolutely
necessary, providing efficiency in computations. However, keep in mind that
these functions must be fully applied to work correctly.

Here are some examples of these functions:

- `if condition branch1 branch2`: This function first evaluates the `condition`.
  If the condition is true, it returns `branch1`; otherwise, it returns
  `branch2`.

- `a || b`: This is a lazy disjunction operator. It first evaluates `a`. If `a`
  is true, it returns true; otherwise, it evaluates and returns `b`.

- `a && b`: This is a lazy conjunction operator. It first evaluates `a`. If `a`
  is false, it returns false; otherwise, it evaluates and returns `b`.

- `a >> b`: This function sequences two IO actions and is lazy in the second
  argument.
