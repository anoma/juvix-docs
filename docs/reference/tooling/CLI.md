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
- `--numeric-version` Show only the version number
- `-h,--help` Show this help text

## Global Command flags

- `--no-colors` Disable globally ANSI formatting
- `--vscode` Enable VSCode compatible output
- `--show-name-ids` Show the unique number of each identifier when
  pretty printing
- `--no-termination` Disable termination checking
- `--no-positivity` Disable positivity checking for inductive types
- `--no-coverage` Disable coverage checking for patterns
- `--no-stdlib` Do not use the standard library
- `--internal-build-dir BUILD_DIR` Directory for compiler internal output
- `--stdin` Read from Stdin
- `--offline` Disable access to network resources
- `--log-level LOG_LEVEL`  Determines how much log the compiler produces.error < warn < info < progress < verbose < debug
- `--dev-show-thread-ids` [DEV] Show the thread id when compiling a module
- `-N,--threads THREADS` Number of physical threads to run (default: auto)

## Main Commands

- `html` Generate HTML output from a Juvix file
- `typecheck` Typecheck a Juvix file
- `compile` Compile a Juvix file
- `eval` Evaluate a Juvix file

## Utility Commands

- `doctor` Perform checks on your Juvix development environment
- `init` Interactively initialize a Juvix project in the current
  directory
- `repl` Run the Juvix REPL
- `format` Format a Juvix file or Juvix project
- `clean` Delete build artifacts

## Dev Commands

```shell
juvix dev COMMAND
```

- `compile` Compile a Juvix file to an internal language
- `parse` Parse a Juvix file
- `scope` Parse and scope a Juvix file
- `highlight` Highlight a Juvix file
- `core` Subcommands related to JuvixCore
- `asm` Subcommands related to JuvixAsm
- `root` Show the root path for a Juvix project
- `termination` Subcommands related to termination checking
- `internal` Subcommands related to Internal
- `casm` Subcommands related to Cairo Assembly
- `anoma` Subcommands related to Anoma
- `nockma` Subcommands related to Nockma
- `runtime` Subcommands related to the Juvix runtime
- `repl` Run the Juvix dev REPL

## CLI Auto-completion Scripts

The Juvix CLI can generate auto-completion scripts. Follow the
instructions below for your shell.

!!! note

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
