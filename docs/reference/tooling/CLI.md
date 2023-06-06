---
icon: material/powershell
comments: true
---

# CLI

## Usage

```shell
juvix [Global options] ((-v|--version) | (-h|--help) | COMPILER_CMD | UTILITY_CMD)
```

## Informative options

- `-v,--version` Print the version and exit
- `-h,--help` Show this help text

## Global Command flags

- `--no-colors` Disable globally ANSI formatting
- `--show-name-ids` Show the unique number of each identifier when
  pretty printing
- `--only-errors` Only print errors in a uniform format (used by
  juvix-mode)
- `--no-termination` Disable termination checking
- `--no-positivity` Disable positivity checking for inductive types
- `--no-stdlib` Do not use the standard library

## Main Commands

- `html` Generate HTML output from a Juvix file
- `typecheck` Typecheck a Juvix file
- `compile` Compile a Juvix file

## Utility Commands

- `doctor` Perform checks on your Juvix development environment
- `init` Interactively initialize a Juvix project in the current
  directory

## Dev Commands

```shell
juvix dev COMMAND
```

- `parse` Parse a Juvix file
- `scope` Parse and scope a Juvix file
- `highlight` Highlight a Juvix file
- `core` Subcommands related to JuvixCore
- `asm` Subcommands related to JuvixAsm
- `root` Show the root path for a Juvix project
- `termination` Subcommands related to termination checking
- `internal` Subcommands related to Internal
- `minic` Translate a Juvix file to a subset of C

## CLI Auto-completion Scripts

The Juvix CLI can generate auto-completion scripts. Follow the
instructions below for your shell.

NB: You may need to restart your shell after installing the completion
script.

### Bash

Add the following line to your bash init script (for example
`~/.bashrc`).

```shell
eval "$(juvix --bash-completion-script juvix)"
```

### Fish

Run the following command in your shell:

```shell
juvix --fish-completion-script juvix
  > ~/.config/fish/completions/juvix.fish
```

### ZSH

Run the following command in your shell:

```shell
juvix --zsh-completion-script juvix > $DIR_IN_FPATH/_juvix
```

where `$DIR_IN_FPATH` is a directory that is present on the [ZSH FPATH
variable](https://zsh.sourceforge.io/Doc/Release/Functions.html) (which
you can inspect by running `echo $FPATH` in the shell).