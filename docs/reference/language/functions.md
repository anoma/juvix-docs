---
icon: material/function-variant
comments: false
search:
  boost: 3
---

# Function Declarations in Juvix

In Juvix, a function declaration is composed of a type signature and the body of
the function. The type signature specifies the types of the arguments and the
return type of the function. Constants are considered as functions with no
arguments. The body of a function can either be a single expression or a set of
function clauses when pattern matching is employed.

## Syntax of Function Declarations

The syntax for a function declaration has the following form:

```juvix
--8<-- "docs/reference/language/syntax.md:function-syntax"
```

Function declarations in Juvix can have variations related to named and implicit
arguments.

### Named Arguments

A named argument is an argument whose name is specified in the function type
signature before the colon. This name is then available within the scope of the
function's body.

```juvix
--8<-- "docs/reference/language/syntax.md:function-named-arguments"
```

For example, consider the function `multiplyByTwo` which takes a `Nat` (natural
number) and returns a `Nat`. The argument is named `n` and is used in the
function's body to return `2 * n`.

```juvix
--8<------ "docs/reference/language/functions.juvix:multiplyByTwo"
```

## Pattern Matching in Function Declarations

A function may consist of one or more function clauses instead of a single
expression. This is applicable when the function's argument is a data type and
we want to pattern match on that argument.

The syntax for a function declaration using pattern matching is as follows:

```text
--8<-- "docs/reference/language/syntax.md:function-pattern-matching"
```

Here `<pat1>` through `<patN>` are patterns that are matched against the
argument of the function. The corresponding body is evaluated when the pattern
matches.

For instance, consider the following function with two clauses:

```juvix
--8<-- "docs/reference/language/functions.juvix:negateBoolean"
```

When `neg` is called with `true`, the first clause is used and the function
returns `false`. Similarly, when `neg` is called with `false`, the second clause
is used and the function returns `true`.

Note that one may pattern match multiple arguments at once. The syntax in case
of two arguments is as follows and can be extended to more arguments.

```text
--8<-- "docs/reference/language/syntax.md:function-pattern-matching-multiple-arguments"
```


!!! note

    Initial function arguments that match variables or wildcards in all clauses can
    be moved to the left of the colon in the function definition. For example,

    ```juvix
    --8<-- "docs/reference/language/functions.juvix:moveToLeft"
    ```

    is equivalent to

    ```juvix
    --8<-- "docs/reference/language/functions.juvix:add"
    ```

    If there is only one clause without any patterns, the pipe `|` must be omitted as we see earlier.

    ```juvix
    --8<-- "docs/reference/language/functions.juvix:shortDefinitions"
    ```

## Mutually Recursive Functions

Functions in Juvix can depend on each other recursively. In the following
example, a function checks if a number is `even` by calling another function
that verifies if the number is `odd`.

```juvix
--8<-- "docs/reference/language/functions.juvix:mutuallyRecursive"
```

Identifiers don't need to be defined before they are used, allowing for mutually
recursive functions/types without any special syntax. However, exceptions exist.
A symbol `f` cannot be forward-referenced in a statement `s` if a local module,
import statement, or open statement exists between `s` and the definition of
`f`.

## Anonymous Functions (Lambdas)

Anonymous functions or _lambdas_ can be defined using the following syntax:

### Syntax of `lambda` declarations

```text
--8<-- "docs/reference/language/syntax.md:function-lambda"
```

The initial pipe `|` is optional. You can use either `\` or the Unicode
alternative `λ` to denote an anonymous function.

An anonymous function lists all clauses of a function without naming it. Any
function declaration can be converted to use anonymous functions:

```juvix
--8<-- "docs/reference/language/functions.juvix:anonymousFunctions"
```
