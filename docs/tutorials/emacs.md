---
icon: simple/gnuemacs
comments: true
---

# Juvix Emacs mode tutorial

First, follow the instructions in the [Emacs Mode
Reference](../reference/tooling/emacs.md) to install the Juvix Emacs
mode. Once you've successfully set it up, create a file `Hello.juvix`
with the following content.

```juvix
--8<-- "docs/examples/milestone/HelloWorld/HelloWorld.juvix"
```

Type ++ctrl+c+ctrl+l++ to run the scoper and highlight the syntax.

If you make a mistake in your program, it is automatically underlined in
red with the error message popping up when you hover the mouse pointer
over the underlined part.

For example, in the following program the identifier `printStringLna`
should be underlined with the error message "Symbol not in scope".

```juvix
module Hello;

open import Stdlib.Prelude;

main : IO;
main := printStringLna "Hello world!";

end;
```

If error underlining doesn't work, make sure you have the `flycheck`
mode turned on. It should be turned on automatically when loading
`juvix-mode`, but in case this doesn't work you can enable it with
`M-x flycheck-mode`.

Let's extend our program with another definition.

```juvix
--8<-- "docs/tutorials/emacs.juvix:Hello"
```

Place the cursor on the `print` call in the function clause of `main`
and press `M-.`. The cursor will jump to the definition of `print`
above. This also works across files and for definitions from the
standard library. You can try using `M-.` to jump to the definition of
`printStringLn`.

One more feature of the Juvix Emacs mode is code formatting. To format
the content of the current buffer, type ++ctrl+c+ctrl+f++.
