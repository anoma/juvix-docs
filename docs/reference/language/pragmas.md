---
icon: material/comment-processing
comments: true
---

# Pragma syntax

Pragmas can be associated with identifiers by placing a pragma comment just before identifier declaration. For example

```juvix
{-# inline: true #-}
f : Nat -> Nat;
```

associates the `inline` pragma with value `true` to the identifier `f`.

Multiple pragmas associated with one identifier are separated by commas:

```juvix
{-# inline: true, unroll: 100 #-}
f : Nat -> Nat;
```

Pragmas associated with a module are inherited by all definitions in the module, unless overridden. For example,

```juvix
{-# inline: true #-}
module M;
  f : Nat -> Nat := ..;

  g : Nat -> Nat := ..;

  {-# inline: false #-}
  h : Nat -> Nat := ..;
end;
```

enables inlining for `f`, `g` and disables it for `h`.

The pragmas are just mappings in [YAML](https://yaml.org/) syntax, except that the outermost braces are not required for the top-level mapping if it is on one line. Since pragmas are supposed to be backwards-compatible, the compiler will ignore any pragmas it doesn't recognize. Pragmas control how code is compiled by providing annotations to the compiler, but they have no semantic significance - removing all pragmas should not change the meaning of the program.

# Available pragmas

We list all currently recognized pragmas. Below `b` denotes a boolean (`true` or `false`), and `n` denotes a non-negative number.

- `inline: b`

  Indicates whether a function should be inlined:

  - `true`: always inline when fully applied,
  - `false`: never inline (also disables automatic inlining).

  When the `inline` pragma is not present and the optimization level is at least 1, a non-recursive fully applied function is automatically inlined if the height of the body term does not exceed the inlining depth limit, which can be specified with the `--inline` option to the compile command.

- `inline: n`

  Indicates that a partial application of the function with at least `n` explicit arguments should always be inlined. For example, with the definition

  ```juvix
  {-# inline: 2 #-}
  compose {A B C} (f : B -> C) (g : A -> B) (x : A) : C := f (g x);
  ```

  in the expression `compose f g` the function `compose` will be inlined, but in `compose f` it won't be.

- `unroll: n`

  Set the maximum recursion unrolling depth to `n`. This affects only the `vampir` and `geb` backends.

- `argnames: [arg1, .., argn]`

  Set the names of function arguments in the generated output to `arg1`,..,`argn`. This is useful primarily with the `vampir` backend to name VampIR input variables.

- `format: b`

  Enable or disable formatting for the specified module. Adding the `format: false` pragma before a module makes the formatter ignore the module and output it verbatim.
