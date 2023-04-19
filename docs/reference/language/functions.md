---
comments: true
---

# Function declarations

A function declaration consists of a type signature and a group of
_function clauses_.

In the following example, we define a function `multiplyByTwo`. The
first line `multiplyByTwo : Nat -> Nat;` is the type signature and the
second line `multiplyByTwo n := 2 * n;` is a function clause.

```juvix
--8<------ "docs/reference/language/functions.juvix:multiplyByTwo"
```

A function may have more than one function clause. When a function is
called, the first clause that matches the arguments is used.

The following function has two clauses.

```juvix
--8<-- "docs/reference/language/functions.juvix:negateBoolean"
```

When `neg` is called with `true`, the first clause is used and the function
returns `false`. Similarly, when `neg` is called with `false`, the second clause
is used and the function returns `true`.

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

The first pipe `|` is optional. Instead of `\` one can also use `λ`.

An anonymous function just lists all clauses of a function without
naming it. Any function declaration can be converted to use anonymous
functions:

```juvix
--8<-- "docs/reference/language/functions.juvix:anonymousFunctions"
```

## Short definitions

A function definition can be written in one line, with the body
immediately following the signature:

```juvix
--8<-- "docs/reference/language/functions.juvix:shortDefinitions"
```
