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
containing a `Package.juvix` metadata file. Each module's name must match its file
path, relative to the project's root directory. For instance, if the file is
`root/Data/List.juvix`, the module should be called `Data.List`.

To initialize a Juvix project interactively in the current directory, use `juvix init`.

To verify correct project root detection by Juvix, run, for instance,

```shell
juvix dev root
```

Refer to: [Modules Reference](../reference/language/modules.md).
