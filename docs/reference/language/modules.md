---
icon: material/view-module
comments: false
search:
  boost: 3
---

# Module System

Modules facilitate the division of programs into separate files. In Juvix, this
is achieved through **top modules** and **local modules**. Top modules are
defined at the file's top, while local modules are nested within another module.
Local modules also serve to organize different scopes within a file.

## Syntax of `module` declaration

The syntax for defining a module is:

```text
--8<-- "docs/reference/language/syntax.md:module-syntax"
```

In this syntax:

- `<name>` represents the module's name.

- `<body>` is a sequence of Juvix statements (declarations of data types, functions, traits,
  etc.).

- The `end` keyword is used to close the module definition.

The `end` keyword is optional if the module definition is the last statement in the file.

For instance, to define a module named `Data.List`, we write:

```juvix
module Data.List;
<body>
```

### Top module naming convention

Top modules that belong to a [project](./../../howto/project.md) must follow a naming
convention. That is, if `dir` is the root of a project, then the module in
`dir/Data/List.juvix` must be named `Data.List`.

## _Import_ and _open_ statements

In order to access the definitions from another modules we use an
_import_ statement. To import some module named `Data.List` we will write

```juvix
import Data.List;
```

Now, we can access the definitions in the imported module using _qualified
names_. E.g., `Data.List.sort`.

It is possible to import modules and give them a more convenient name thus:

```juvix
import Data.List as List;
```

### Open statements

If we want to access the contents of a module without the need to qualify the
names, we use an _open statement_. The syntax is as follows:

```juvix
open Data.List;
```

Now we can simply write `sort`.

It is important to remember that when we open a
module, that module must be in scope, i.e., it must either be imported
or defined as a local module.

Since importing and opening a module is done often, there is special syntax for
that. The following statement:

```juvix
import Data.List open;
```

Is equivalent to this:

```juvix
import Data.List;
open Data.List;
```

In general, we can combine any import statement and open statement that refer to
the same module. The syntax is `<import statement> <open statement without module
name>`.

When opening a module, if we want to open an explicit subset of its definitions,
we must use the `using` keyword thus:

```juvix
open Data.List using {List; sort; reverse};
```

We can also rename symbols in an open statement thus:

```juvix
open Data.List using {List; sort as listSort; reverse as reverseList};
```

If we want to open all definitions of a module minus a subset, we
use the `hiding` keyword thus:

```juvix
open Data.List hiding {head; tail};
```

Sometimes you might want to open or hide the type constructors of a data type.
Recall that each data type defines a module containing names linked to its type
constructors. For example, if you want to hide the type constructors of a data
type, you must use the `hiding` keyword and module keyword as follows:

```juvix
import Stdlib.Prelude open hiding {module List};
```

### Reexport modules

All opened definitions are available under the current module, but
they are not exported by default. Meaning that if another module imports the current
module, it will only be able to access the definitions defined there but not
those which have been opened. If we want opened definitions to be exported, we
must use the `public` keyword thus:

```juvix
module Prelude;

import Data.List open public;
```

Now, from another module we can access definitions in `Data.List` through the
`Prelude` module.

```juvix
module MyModule;

import Prelude open;

-- List, sort, reverse, etc. are now in scope
```

## Local modules

Juvix modules have a hierarchical structure. So far we have discussed top level
modules, which have a one-to-one correspondence with files in the filesystem. On
the other hand, local modules are defined within another module. They can be
useful to group definitions within a file.

The syntax for local modules is as follows:

```juvix
module Path.To.TopModule;

module ModuleName;
  <body>
end;
```

Local module names cannot contain the `.` character.

After the definition of a local module, we can access its definitions by using
qualified names. Local modules can be opened by open statements in the same way
as top modules.

Local modules inherit the scope of the parent module. Some shadowing rules
apply, and they probably follow your intuition:

1. Opening or defining a symbol shadows inherited instances of that symbol.
2. Opening a symbol does _not_ shadow a defined instance of that symbol in the
   current module.
3. Conversely, defining a symbol in the current module does _not_ shadow an
   opened instance of that symbol.

As a consequence of 2 and 3, using a symbol that is both defined and opened
locally will result in an ambiguity error. In order to solve that, the symbol
that was opened would need to be used qualified instead.
