---
icon: material/rename-outline
comments: false
search:
  boost: 3
---

```juvix hide
module reference.language.aliases;
import Stdlib.Data.Fixity open;
```

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
syntax alias Boolean := Bool;
syntax alias ⊥ := false;
syntax alias ⊤ := true;

type Bool :=
  | false
  | true;

not : Boolean -> Boolean
  | ⊥ := ⊤
  | ⊤ := ⊥;
```

In addition to global scope, aliases can also be used in local definitions. The following `let` expression demonstrates this usage.

```juvix
not2 (b : Boolean) : Boolean :=
  let
    syntax alias yes := ⊤;
    syntax alias no := ⊥;
  in case b of {
       | no := yes
       | yes := no
     };
```

Just like any other name, aliases can be exported from a module to be used elsewhere. Here's how to do it:

```juvix
module ExportAlias;
  syntax alias Binary := Bool;
  syntax alias one := ⊤;
  syntax alias zero := ⊥;
end;

open ExportAlias;

syntax operator || logical;
|| : Binary -> Binary -> Binary
  | zero b := b
  | one _ := one;
```

The versatility of aliases extends beyond types to terms, including functions
(operators). For example, the binary `||` function can be aliased as `or` as
shown below:

```juvix
syntax alias or := ||;
newor (a b c : Binary) : Binary := (a or b) or c;
```
