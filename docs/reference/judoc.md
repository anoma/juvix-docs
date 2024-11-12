---
icon: material/file-document-multiple-outline
comments: true
---

# Native Documentation Tool

Inspired by [Haddock](https://www.haskell.org/haddock/) and
[Agda](https://agda.readthedocs.io/en/v2.6.1.1/language/documentation.html),
Juvix has its own documentation tool called _Judoc_.

Judoc is used to document parts of your code. You can attach _Judoc
blocks_ to the following entities:

- A module.
- A type definition.
- A constructor definition.
- A function definition.
- An axiom definition.

In order to attach documentation to any of these entities, write _blocks_ of
documentation before them:

1. For modules:

```juvix
--- This module is cool
module Cool;
..
```

- For type definitions:

```juvix
--- Unary representation of natural numbers
type Nat : Type :=
  | --- Nullary constructor representing number 0
    zero : Nat
  | --- Unary constructor representing the successor of a natural number
    suc : Nat -> Nat;
```

- For functions (and likewise for axioms):

```juvix
--- The polymorphic identity function
id {A} (x : A) : A := x;
```

## Block

A _block_ can be one of:

1. A _paragraph_.
2. An _example_.

_Blocks_ are separated by a line with only `---`.
For instance, this is a sequence of two _blocks_:

```juvix
--- First block
---
--- Second block
```

Note that the following is a single block since it lacks the `---` separator:

```juvix
--- First block

--- Still first block
```

Alternatively, you can use block Judoc comments for that:

```juvix
{-- First block

Second block
---}
```

### Paragraph

A _paragraph_ is a non-empty sequence of _lines_.

For instance, the following is a paragraph with two _lines_:

```juvix
--- First line
--- Second line
```

Note that a rendered paragraph will have have no line breaks. If you want to
have line breaks, you will need to split the paragraph. Hence, the paragraph
above will be rendered as

```juvix
First line Second line
```

##### Line

A _line_ starts with `---` and is followed by a non-empty sequence of
_atoms_.

For instance, the following is a valid _line_:

```juvix
--- A ;Pair Int Bool; contains an ;Int; and a ;Bool;
```

##### Atom

An _atom_ is either:

1. A string of text (including spaces but not line breaks).
2. An inline Juvix expression surrounded by `;`.

For instance, the following are valid _atoms_:

1. `I am some text.`
2. `;Pair Int Bool;`

### Example

```juvix
--- >>> someExpression ;
```

The `someExpression` can span multiple lines and it must be ended with a `;`.
For instance:

```juvix
--- >>> 1
        + 2
        + 3;
```
