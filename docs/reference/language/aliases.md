---
icon: material/rename-outline
comments: true
---

# Aliases

Aliases serve as shorthand for terms, functions, and types, enhancing
readability. Introduced through the declaration,

```juvix
syntax alias <originalName> := <AlternativeName>;
```

these new names are interchangeable with the aliased name, applicable in pattern
matching, qualification, and module opening.

# Application of Aliases

Aliases can be forward referenced, permitting their use prior to declaration.
For instance, we define the alias Boolean for the `Bool` type, and their terms
`true` and `false` as `⊤` and `⊥` respectively.

```juvix
--8<------ "docs/reference/language/aliases.juvix:forward"
```

Aliases exhibit versatility in application. They can be used in local definitions, as shown in the `let` expression below.

```juvix
--8<------ "docs/reference/language/aliases.juvix:local-alias"
```

Like any other name, aliases can be exported from a module.

```juvix
--8<------ "docs/reference/language/aliases.juvix:export"
```

We can create aliases for not only types but also terms, including functions. For example, the binary `||` function can be aliased as `or`.

```juvix
--8<------ "docs/reference/language/aliases.juvix:or"
```
