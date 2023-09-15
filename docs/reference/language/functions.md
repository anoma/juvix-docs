---
icon: material/function-variant
comments: false
---

# Function declarations

A function declaration consists of a type signature followed by a group
of _function clauses_.

In the following example, we define a function `multiplyByTwo`.

```juvix
--8<------ "docs/reference/language/functions.juvix:multiplyByTwo"
```

The first line `multiplyByTwo : Nat -> Nat` is the type signature and the
second line `| n := 2 * n;` is a function clause.

## Pattern matching

A function may have more than one function clause. When a function is
called, it will pattern match on the input, and the first clause that matches
the arguments is used.

The following function has two clauses:

```juvix
--8<-- "docs/reference/language/functions.juvix:negateBoolean"
```

When `neg` is called with `true`, the first clause is used and the function
returns `false`. Similarly, when `neg` is called with `false`, the second clause
is used and the function returns `true`.

## Short definitions

Initial function arguments that are matched against variables or
wildcards in all clauses can be moved to the left of the colon in the
function definition. For example,

```juvix
--8<-- "docs/reference/language/functions.juvix:moveToLeft"
```

is equivalent to

```juvix
--8<-- "docs/reference/language/functions.juvix:add"
```

If there is only one clause with no patterns, then the pipe `|` must be omitted:

```juvix
--8<-- "docs/reference/language/functions.juvix:shortDefinitions"
```

## Mutually recursive functions

Function declarations can depend on each other recursively. In the
following example, we define a function that checks if a number is
`even` by calling a function that checks if a number is `odd`.

```juvix
--8<-- "docs/reference/language/functions.juvix:mutuallyRecursive"
```

## Anonymous functions

Anonymous functions, or _lambdas_, are introduced with the syntax:

```juvix
\{| pat1 .. patN_1 := clause1
  | ..
  | pat1 .. patN_M := clauseM }
```

The first pipe `|` is optional. Instead of `\` one can also use the Unicode
alternative – `λ`.

An anonymous function just lists all clauses of a function without
naming it. Any function declaration can be converted to use anonymous
functions:

```juvix
--8<-- "docs/reference/language/functions.juvix:anonymousFunctions"
```
