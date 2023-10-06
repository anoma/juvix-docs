---
icon: material/rename-outline
comments: false
search:
  boost: 3
---

# Aliases

Aliases in Juvix serve as shorthand for an existing name. An alias is introduced
through the following declaration.

```text
--8<-- "docs/reference/language/syntax.md:alias-syntax"
```

These new names are interchangeable with the aliased name, and can be used in
pattern matching, qualification, and module opening.

# Application of Aliases

Aliases can be forward referenced. This means you can use an alias before it has
been declared in your code. This feature can be particularly useful when you
want to use a more intuitive or shorter name for something that is defined later
in the code.

For instance, let's define the alias `Boolean` for the `Bool` type, and we could
also alias the named constructors `true` and `false` for the Boolean type as `⊤`
(top) and `⊥` (bottom) respectively.

```juvix
--8<------ "docs/reference/language/aliases.juvix:forward"
```

Aliases can be used in local definitions, as shown in the `let` expression
below.

```juvix
--8<------ "docs/reference/language/aliases.juvix:local-alias"
```

Like any other name, aliases can be exported from a module.

```juvix
--8<------ "docs/reference/language/aliases.juvix:export"
```

We can create aliases for not only types but also terms, including functions.
For example, the binary `||` function can be aliased as `or`.

```juvix
--8<------ "docs/reference/language/aliases.juvix:or"
```
