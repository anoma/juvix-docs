---
icon: material/rename-outline
comments: false
search:
  boost: 3
---
# Aliases in Juvix

Aliases in Juvix are a powerful feature that allows developers to create shorthand or substitute names for existing ones. This can greatly enhance readability and maintainability of the code.

## Syntax

The syntax for creating an alias is as follows:

```text
--8<-- "docs/reference/language/syntax.md:alias-syntax"
```

Once declared, these aliases can be used interchangeably with the original name. They can be employed in various contexts such as pattern matching, qualification, and module opening.

# Application of Aliases

One of the key features of aliases in Juvix is their ability to be forward referenced. This means you can use an alias before it has been officially declared in your code. This can be particularly useful when you want to use a more intuitive or shorter name for something that is defined later in the code.

For instance, consider the following example where we define the alias `Boolean` for the `Bool` type. We also alias the named constructors `true` and `false` for the Boolean type as `⊤` (top) and `⊥` (bottom) respectively.

```juvix
--8<------ "docs/reference/language/aliases.juvix:forward"
```

In addition to global scope, aliases can also be used in local definitions. The following `let` expression demonstrates this usage.

```juvix
--8<------ "docs/reference/language/aliases.juvix:local-alias"
```

Just like any other name, aliases can be exported from a module to be used elsewhere. Here's how to do it:

```juvix
--8<------ "docs/reference/language/aliases.juvix:export"
```

The versatility of aliases extends beyond types to terms, including functions
(operators). For example, the binary `||` function can be aliased as `or` as
shown below:

```juvix
--8<------ "docs/reference/language/aliases.juvix:or-inherit"
```
