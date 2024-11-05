---
icon: material/microsoft-visual-studio-code
comments: true
search:
  boost: 2
---

```juvix hide
module tutorials.vscode;
```

# Juvix VSCode extension tutorial

To install the [Juvix VSCode extension][vscode-marketplace], click on the
"Extensions" button in the left panel and search for the "Juvix" extension by
Heliax.

Once you've installed the Juvix extension, you can open a Juvix file. For
example, create a `Hello.juvix` file with the following content.

```juvix
module Hello;
  -- Importing the 'String' type from standard library prelude
  import Stdlib.Prelude open;

  main : String := "Hello world!";
end;
```

The name of the top module must coincide with the file name.

Syntax should be automatically highlighted for any file with the `.juvix` extension.
You can jump to the definition of an identifier by pressing ++f12++ or
control-clicking it. To apply the Juvix code formatter to the current file, use
++shift+ctrl+i++.

In the top right-hand corner of the editor window you should see several
buttons. Hover the mouse pointer over a button to see its description. The
functions of the buttons are as follows.

- Load file in REPL (++shift+alt+r++). Launches the Juvix REPL in a separate
  window and loads the current file into it. You can then evaluate any
  definition from the loaded file.
- Typecheck (++shift+alt+t++). Type-checks the current file.
- Compile (++shift+alt+c++). Compiles the current file. The resulting native
  executable will be left in the directory of the file.
- Evaluate (++shift+alt+x++). Evaluates the current file in the Juvix
  evaluator. The output of the program evaluation is displayed in a separate
  window.
- Html preview. Generates HTML documentation for the current file and displays
  it in a separate window.

[vscode-marketplace]:
    https://marketplace.visualstudio.com/items?itemName=heliax.juvix-mode
