---
icon: octicons/terminal-16
comments: true
---

# Compiling simple programs

A Juvix file must declare a module whose name corresponds exactly to the
name of the file. For example, a file `Hello.juvix` must declare a
module `Hello`:

```juvix
-- Hello world example. This is a comment.
module Hello;

-- Import the standard library prelude, including the 'String' type
open import Stdlib.Prelude;

main : String;
main := "Hello world!";
```

A file compiled to an executable must define the zero-argument function
`main` which is evaluated when running the program.

To compile the file `Hello.juvix` type

```shell
juvix compile Hello.juvix
```

Typing

```shell
juvix compile --help
```

will list all options to the `compile` command.

# Compilation targets

<<<<<<< Updated upstream
Juvix supports several compilation targets. The targets are specified
with the `-t` option:

```shell
juvix compile -t TARGET file.juvix
```

As a target, you can choose one of the following:

1.  `native`. This is the default. Produces a native 64bit executable
    for your machine.
2.  `wasm32-wasi`. Produces a WebAssembly binary which uses the WASI
    runtime.
3.  `vampir`. Produces a [VampIR](https://github.com/anoma/vamp-ir) input file.
4.  `geb`. Produces a [GEB](https://anoma.github.io/geb/) input file.
5.  `core`. Produces `.jvc` file.
6.  `asm`. Produces `.jva` file.

# Compilation options

To see all compilation options type `juvix compile --help`. The most
commonly used options are:

- `-t TARGET`: specify the target,
- `-g`: generate debug information and runtime assertions,
- `-O LEVEL`: set optimization level (default: 1, or 0 with `-g`).
- `-o FILE`: specify the output file.

# Juvix projects

A <u>Juvix project</u> is a collection of Juvix modules inside one main
project directory containing a `juvix.yaml` metadata file. The name of
each module must coincide with the path of the file it is defined in,
relative to the project's root directory. For example, if the file is
`root/Data/List.juvix` then the module must be called `Data.List`,
assuming `root` is the project's directory.

To interactively initialize a Juvix project in the current directory,
use `juvix init`.

To check that Juvix is correctly detecting your project's root, you can
run the command `juvix dev root File.juvix`.

See also: [Modules Reference](../reference/language/modules.md).

# Compiling to the VampIR backend

For the [VampIR](https://github.com/anoma/vamp-ir) backend, the `main` function must have type

```juvix
Ty1 -> .. -> Tyn -> TyR
```

where `Tyi`,`TyR` are `Nat`, `Int` or `Bool`. The compiler adds an equation to the generated VampIR file which states the relationship between the input and the output of the `main` function:

```
main arg1 .. argn = out
```

where `arg1`,..,`argn` are the names of the arguments of `main` found in the source code. If the result type is `Bool` (i.e., `main` returns a boolean), then instead of `out` the compiler uses `1` (true).

The variables `argi`,`out` in the generated file are unbound VampIR
variables for which VampIR solicits witnesses during proof generation.

For example, compiling

```juvix
main : Nat -> Nat -> Bool;
main x y := x + y > 0;
```

generates the equation

```
main x y = 1
```

The names of the `main` input arguments in the generated VampIR file can also be
specified with the `argnames` pragma. For example, compiling

```juvix
{-# argnames: [a, b] #-}
main : Nat -> Nat -> Bool;
main x y := x + y > 0;
```

generates the equation

```
main a b = 1
```
