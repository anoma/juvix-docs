---
icon: material/car-traction-control
comments: false
search:
  boost: 3
---

```juvix hide
module reference.language.control;
import Stdlib.Prelude open;
```

# Control Structures

Juvix uses control structures such as case expressions, if expressions and lazy built-ins to manage the flow of execution.

## Case Expressions

A case expression in Juvix enables the execution of different actions
based on the *pattern* of the input expression. It provides a way to
match complex patterns and perform corresponding operations.

A case expression in Juvix is defined as follows:

```text
--8<-- "docs/reference/language/syntax.md:case-syntax"
```

The braces are optional when there is no ambiguity.

In this syntax:

- `<expression>` is the value against which you want to match patterns.
- `<pattern1>` through `<patternN>` are the patterns you're checking the
  given expression against.
- `<branch1>` through `<branchN>` are the respective actions or results that
  will be returned when their corresponding patterns match the input expression.

For instance:

```jrepl
Stdlib.Prelude> case 2 of { | zero := 0 | suc x := x }
```

In this example, the input expression is `2`. The case expression
checks this input against each pattern (`zero` and `suc x`) in
order. Since `2` does not match the pattern `zero`, it moves on to the
next pattern `suc x`. This pattern matches the input `2` with `x`
equal to `1` (`2` is just notation for `suc 1`). Therefore, the
corresponding branch `x` is executed, and `1` is returned.

Thus, when evaluated, this expression returns `1`.

## If Expressions

If expressions allow to select a branch based on boolean conditions. In Juvix, a single if expression can have multiple conditions and it is required to end with an else branch. The syntax of if expressions is:

```text
--8<-- "docs/reference/language/syntax.md:if-syntax"
```

The boolean expressions `<expression-1>`, ..., `<expression-n>` are evaluated in order until one of them evaluates to `true`. If `<expression-k>` is the first one which evaluates to `true`, then `<branch-k>` is evaluated as the result of the `if` expression. If none of `<expression-1>`, ..., `<expression-n>` evaluate to `true`, then `<branch-else>` is the result.

Here is an example of `if` expression use:

```juvix
cmp (x y : Nat) : Int :=
  if
    | x == y := 0
    | x < y := -1
    | else := 1;
```

## Lazy Built-in Functions

Juvix provides several lazily evaluated built-in functions in its standard
library. These functions do not evaluate their arguments until absolutely
necessary. They are required to be always fully applied.

Here are some examples of these functions:

- `ite condition branch1 branch2`: This function first evaluates the `condition`.
  If the condition is true, it returns `branch1`; otherwise, it returns
  `branch2`.

- `a || b`: This is a lazy disjunction operator. It first evaluates `a`. If `a`
  is true, it returns true; otherwise, it evaluates and returns `b`.

- `a && b`: This is a lazy conjunction operator. It first evaluates `a`. If `a`
  is false, it returns false; otherwise, it evaluates and returns `b`.

- `a >>> b`: This function sequences two IO actions and is lazy in the second
  argument.
