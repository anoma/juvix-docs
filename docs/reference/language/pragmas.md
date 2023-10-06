---
icon: material/comment-processing
comments: false
search:
  boost: 3
---


# Pragmas

Pragmas in Juvix are used to provide additional information to the compiler
about how to handle specific identifiers or modules. They offer a way to control
the compilation process and can be associated with identifiers by placing a
pragma comment just before the identifier declaration.

## Syntax of Pragma

The syntax for associating a pragma with an identifier is as follows:

```juvix
--8<-- "docs/reference/language/syntax.md:pragma-id-syntax"
```

For instance, the following code associates the `inline` pragma with a value of
`true` to the identifier `f`.

```juvix
--8<-- "docs/reference/language/pragmas.juvix:pragma-inline"
```

Multiple pragmas can be associated with one identifier, separated by commas:

```juvix
--8<-- "docs/reference/language/pragmas.juvix:pragma-inline-with-unroll"
```

Pragmas associated with a module are inherited by all definitions within the
module, unless explicitly overridden. For example,

```juvix
--8<-- "docs/reference/language/pragmas.juvix:pragma-inline-module"
```

In this case, inlining is enabled for `f`, `g` and disabled for `h`.

Pragmas are mappings in [YAML](https://yaml.org/) syntax, with the exception
that the outermost braces are not required for the top-level mapping if it is on
one line. If the compiler encounters any unrecognized pragmas, these will be
ignored to ensure backwards compatibility. While pragmas influence the
compilation process, they do not carry any semantic significance - removing all
pragmas should not change the meaning of the program.

# Available Pragmas

Here, we list all currently recognized pragmas in Juvix. In the descriptions
below, `b` denotes a boolean (`true` or `false`), and `n` denotes a non-negative
number.

- `inline: b`

  This pragma indicates whether a function should be inlined. If set to `true`,
  the function will always be inlined when fully applied. If set to `false`, the
  function will never be inlined. This also disables automatic inlining.

- `inline: n`

  This form of the `inline` pragma indicates that a partial application of the
  function with at least `n` explicit arguments should always be inlined. For
  example:

  ```juvix
  {-# inline: 2 #-}
  compose {A B C} (f : B -> C) (g : A -> B) (x : A) : C := f (g x);
  ```

  In the expression `compose f g`, the function `compose` will be inlined, but
  in `compose f`, it won't be.

- `unroll: n`

  This pragma sets the maximum recursion unrolling depth to `n`. It only affects
  the `vampir` and `geb` backends.

- `argnames: [arg1, .., argn]`

  This pragma sets the names of function arguments in the generated output to
  `arg1`,..,`argn`. This is primarily useful with the `vampir` backend to name
  VampIR input variables.

- `format: b`

  This pragma enables or disables formatting for the specified module. Adding
  the `format: false` pragma before a module makes the formatter ignore the
  module and output it verbatim.
