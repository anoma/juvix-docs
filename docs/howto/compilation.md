---
icon: octicons/terminal-16
comments: true
search:
  boost: 5
---

# Program Compilation

## Example: Hello World

A Juvix file must declare a module with the same name as the file. For instance, `HelloWorld.juvix` should declare a module `HelloWorld`:

```text
--8<------ "docs/howto/compilation/HelloWorld.juvix:Hello"
```

The zero-argument function `main` is evaluated when running the program and must be defined in a file compiled to an executable.

To compile `HelloWorld.juvix`, type:

```shell
juvix compile native HelloWorld.juvix
```

## Compilation Targets

Juvix supports several targets, including `native`, `wasi` (for web assembly),
`anoma` and `cairo` among others. To see the full list use:

```shell
juvix compile --help
```

## Juvix Projects

A Juvix project is a collection of Juvix modules in one main directory
containing a `juvix.yaml` metadata file. Each module's name must match its file
path, relative to the project's root directory. For instance, if the file is
`root/Data/List.juvix`, the module should be called `Data.List`.

To initialize a Juvix project interactively in the current directory, use `juvix init`.

To verify correct project root detection by Juvix, run, for instance,

```shell
juvix dev root
```

Refer to: [Modules Reference](../reference/language/modules.md).

## Compiling to VampIR Backend

For the [VampIR](https://github.com/anoma/vamp-ir) backend, the `main` function must have type:

```text
Ty1 -> ... -> Tyn -> TyR
```

Here, `Tyi`,`TyR` are `Nat`, `Int` or `Bool`. The compiler adds an equation to the generated VampIR file that states the relationship between the input and output of the `main` function:

```text
main arg1 .. argn = out
```

Here, `arg1`, ... ,`argn` are the argument names of `main` found in the source code. If `main` returns a boolean (`Bool`), the compiler uses `1` (true) instead of `out`.

The variables `argi`,`out` in the generated file are unbound VampIR variables for which VampIR solicits witnesses during proof generation.

For example:

```juvix
main (x y : Nat) : Bool := x + y > 0;
```

Generates the equation:

```text
main x y = 1
```

The `main` input argument names in the generated VampIR file can also be specified with the `argnames` pragma:

```juvix
{-# argnames: [a, b] #-}
main (x y : Nat) : Bool := x + y > 0;
```

Generates the equation:

```text
main a b = 1
```
