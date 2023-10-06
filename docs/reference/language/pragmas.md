---
icon: material/comment-processing
comments: false
search:
  boost: 3
---

# Pragmas in Juvix

Pragmas in Juvix are used to provide additional information to the compiler
about how to handle specific identifiers or modules. They offer a way to control
the compilation process and can be associated with identifiers by placing a
pragma comment just before the identifier declaration.

## Syntax of Pragma

The syntax for binding a pragma to an identifier is as follows:

```juvix
--8<-- "docs/reference/language/syntax.md:pragma-id-syntax"
```

For instance, the subsequent code associates the `inline` pragma with a value of
`true` to the identifier `f`.

```juvix
--8<-- "docs/reference/language/pragmas.juvix:pragma-inline"
```

Multiple pragmas can be linked with a single identifier, delineated by commas:

```juvix
--8<-- "docs/reference/language/pragmas.juvix:pragma-inline-with-unroll"
```

Pragmas associated with a module are inherited by all definitions within the
module, unless explicitly overridden. For example,

```juvix
--8<-- "docs/reference/language/pragmas.juvix:pragma-inline-module"
```

In this scenario, inlining is enabled for `f`, `g` and disabled for `h`.

Pragmas are mappings in [YAML](https://yaml.org/) syntax, albeit the outermost
braces are not mandated for the top-level mapping if it's on a single line. If
the compiler encounters any unrecognized pragmas, they will be disregarded to
ensure backwards compatibility. Although pragmas influence the compilation
process, they don't carry any semantic significance - eliminating all pragmas
should not alter the meaning of the program.

# Available Pragmas

Herein, we enumerate all currently recognized pragmas in Juvix. In the
descriptions below, `b` symbolizes a boolean (`true` or `false`), and `n`
symbolizes a non-negative number.

## Inlining Functions

- `inline: b`

  This pragma specifies whether a function should be inlined. If set to `true`,
  the function will invariably be inlined when fully applied. If set to `false`,
  the function will never be inlined, which also disables automatic inlining.

## Inlining Partial Applications

- `inline: n`

  This variant of the `inline` pragma specifies that a partial application of
  the function with at least `n` explicit arguments should always be inlined.
  For example:

  ```juvix
  --8<-- "docs/reference/language/pragmas.juvix:pragma-partial-inline"
  ```

  In the expression `compose f g`, the function `compose` will be inlined, but
  in `compose f`, it won't be.

## Unrolling Recursion

- `unroll: n`

  This pragma sets the maximum recursion unrolling depth to `n`. It only affects
  the `vampir` and `geb` backends.

## Naming Function Arguments for Generated Code

- `argnames: [arg1, .., argn]`

  This pragma sets the names of function arguments in the generated output to
  `arg1`,..,`argn`. This is primarily useful with the `vampir` backend to name
  VampIR input variables.

## Formatting

- `format: b`

  This pragma enables or disables formatting for the specified module. Adding
  the `format: false` pragma before a module makes the formatter ignore the
  module and output it verbatim.

## Specializing Functions

- Allows specialization on a per-trait or per-instance basis.

<!-- TODO for v0.5.2 -->
