---
icon: material/toy-brick-outline
comments: false
search:
  boost: 3
---

```juvix hide
module reference.language.datatypes;
import Stdlib.Data.Fixity open;
```

# Defining Data Types in Juvix

A crucial aspect of any programming language is the ability to define custom
data types. In Juvix, these are known as _inductive types_. An inductive type is
a type with elements constructed from a finite set of _constructors_.

As a first example, consider the data type `Bool` with two
constructors `true` and `false`.

```juvix
type Bool :=
  | true : Bool
  | false : Bool;
```

## Syntax of Data Type Declaration

### General Declaration

The declaration of a data type in Juvix consists of the keyword `type`, followed
by a unique name, optional type parameters, and constructors.

```text
--8<-- "docs/reference/language/syntax.md:datatype-syntax"
```

In this syntax:

- `<name>` represents a unique name for the declared data type.
- `<type-parameters>` denote optional type parameters in the form `A B C ...` or
  with typing information `(A : Type)`.
- `<constructor1>` through `<constructorn>` are the constructors of the data
  type. Each constructor has a unique name and a type, which can be a function type with
  the type of the declared data type in the target.

While there are variations in the syntax for declaring a data type (see the [ADT
syntax](#adt-syntax) and [record syntax](./records.html)), the most general syntax
is the one outlined above.

!!! info "Note"

    A data type declaration implicitly declares a [module](./modules.md) with
    the same name as the data type, containing the symbols of the constructors,
    and the type of the data type itself. One can open this module to access
    these symbols or hide it to prevent access to them.

## Examples of data types

The `Unit` type has a single constructor named `unit`.

```juvix
type Unit := unit : Unit;
```

Below is a declaration of the `Nat` type unary natural numbers. It
introduces two constructors: `zero` and `suc`. For instance, `suc
zero` represents one, while `suc (suc zero)` represents two.

```juvix
type Nat :=
  | zero : Nat
  | suc : Nat -> Nat;
```

These constructors can be used as regular functions or as patterns in
pattern matching. Here is an example of a function adding two natural
numbers:

```juvix
syntax operator + additive;
+ : Nat -> Nat -> Nat
  | zero b := b
  | (suc a) b := suc (a + b);
```

# ADT syntax

As an alternative to the above syntax, we can use a more familiar and
compact syntax for declaring data types. This syntax is similar to the
ADT syntax in Haskell, OCaml or other functional languages.

```text
type <name> <type-parameters> :=
  | <constructor1> <arg1-1> ... <arg1-n>
  | ...
  | <constructorN> <argn-1> ... <argn-n>;
```

Instead of specifying the type of each constructor, we only provide the types of constructor arguments.

If a constructor as above has no arguments, then its type is the data
type being declared. If the constructor has arguments, then its type
is the function type from the types of the arguments to the data type
being declared.

For example, the `Nat` type can be declared as follows:

```juvix extract-module-statements
module Nat-ADT;
  type Nat :=
    | Z
    | S Nat;
end;
```

Another example is the `List` type, which is polymorphic in the type of its
elements.

```juvix extract-module-statements
module List-ADT;
  type List A :=
    | Nil
    | Cons A (List A);
end;
```

## Polymorphic data type

A data type can have type parameters. When a data type has a type parameter
`A`, it is referred to as _polymorphic in_ `A`.

A classic example of this concept is the `List` type, which is polymorphic in
the type of its list elements.

```juvix
  syntax operator :: cons;
  type List (A : Type) :=
    | nil : List A
    | :: : A -> List A -> List A;
```

The following function determines whether an element is in a list or not.

```juvix extract-module-statements  1
module membership;
import Stdlib.Data.Bool open using {Bool; false; ||};

isElem {A} (eq : A -> A -> Bool) (s : A) : List A -> Bool
  | nil := false
  | (x :: xs) := eq s x || isElem eq s xs;
end;
```

For more examples of inductive types and how to use them, see [the Juvix
standard library](https://anoma.github.io/juvix-stdlib/).
