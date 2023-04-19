---
icon: material/microsoft-visual-studio-code
comments: true
---

# Juvix VSCode extension tutorial

To install the [Juvix VSCode extension][vscode-marketplace], click on the "Extensions" button
in the left panel and search for the "Juvix" extension by Heliax.

Once you've installed the Juvix extension, you can open a Juvix file.
For example, create a `Hello.juvix` file with the following content.

```juvix
--8<------ "docs/examples/milestone/HelloWorld/HelloWorld.juvix"
```

Syntax should be automatically highlighted for any file with `.juvix`
extension. You can jump to the definition of an identifier by pressing
++f12++ or control-clicking it. To apply the Juvix code formatter to the
current file, use ++shift+ctrl+i++.

In the top right-hand corner of the editor window you should see several
buttons. Hover the mouse pointer over a button to see its description.
The functions of the buttons are as follows.

- Load file in REPL (++shift+alt+r++). Launches the Juvix REPL in a
  separate window and loads the current file into it. You can then
  evaluate any definition from the loaded file.
- Typecheck (++shift+alt+t++). Type-checks the current file.
- Compile (++shift+alt+c++). Compiles the current file. The resulting
  native executable will be left in the directory of the file.
- Run (++shift+alt+x++). Compiles and runs the current file. The output of
  the executable run is displayed in a separate window.
- Html preview. Generates HTML documentation for the current file and
  displays it in a separate window.

[vscode-marketplace]: https://marketplace.visualstudio.com/items?itemName=heliax.juvix-mode
