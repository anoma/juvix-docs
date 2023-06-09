---
icon: simple/gnuemacs
comments: true
---

## Emacs Mode

There is an [Emacs mode](https://github.com/anoma/juvix-mode) available for
Juvix. Currently, it supports syntax highlighting for well-scoped modules.

To get started, clone the Juvix Emacs mode repository:

```bash
git clone https://github.com/anoma/juvix-mode.git
```

To install it add the following lines to your Emacs configuration file:

```elisp
(push "/path/to/juvix-mode/" load-path)
(require 'juvix-mode)
```

Make sure that Juvix is installed in your `PATH`.

The Juvix major mode will be activated automatically for `.juvix` files.

### Keybindings

| Key       | Function Name           | Description                                           |
| --------- | ----------------------- | ----------------------------------------------------- |
| `C-c C-l` | `juvix-load`            | Runs the scoper and adds semantic syntax highlighting |
| `M-.`     | `juvix-goto-definition` | Go to the definition of symbol at point               |
| `C-c C-f` | `juvix-format-buffer`   | Format the current buffer                             |

### Emacs installation

Most Linux distributions contain an Emacs package which can be installed
with your package manager (`sudo apt install emacs` on Ubuntu). On
macOS, it is recommended to install Emacs Plus via Homebrew:
`brew install emacs-plus`. Using the Emacs Homebrew casks is not
recommended.

### Common problems

- Error "Symbol's value as variable is void: sh:1:"

  Make sure the juvix executable is on the Emacs' `exec-path`. Note
  that `exec-path` may be different from your shell's `PATH`. This is
  particularly common on macOS with Emacs launched from GUI instead of
  the terminal.

  The easiest way to resolve this issue is to install the
  [exec-path-from-shell](https://github.com/purcell/exec-path-from-shell)
  package (available on MELPA). Alternatively, one may set `exec-path`
  to match shell `PATH` by following the instructions from
  [EmacsWiki](https://www.emacswiki.org/emacs/ExecPath).
