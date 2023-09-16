---
icon: material/toy-brick-outline
comments: false
---

# Data Types

A data type, also known as an _inductive type_, is a type with elements
constructed from a finite set of _constructors_.

In the following example, we define a data type `Bool` with two constructors,
`true` and `false`.

```juvix
--8<------ "docs/reference/language/datatypes.juvix:typeBool"
```

A declaration of a data type
consists of the keyword `type`, followed by a unique name, type parameters, and
constructors.

```text
type <name> <type-parameters> :=
    | <constructor1> : <type1>
    | ...
    | <constructorn> : <typen>;
```

The syntax for declaring a data type varies (see the [ADT syntax](#adt-syntax)
and [record syntax](./records.md)) but the most general syntax is the one above.

In this syntax:

- `<name>` represents a unique name for the declared data type.

- `<type-parameters>` denote type parameters in the form `A B C ...` or with
  typing information `(A : Type)`. These parameters are optional and define the
  return type of the constructors, i.e., `<name> <type-parameters>`.

- `<constructor1>` ... `<constructorn>` are the constructors of the data type.
  Each constructor has a unique name and a type, which can be the type of the
  declared data type or a function type from the types of the arguments to the
  type of the declared data type.

!!! info "Note"
A data type declaration implicitly declares a [module](./modules.md) with
the same name as the data type, containing the symbols of the constructors,
and the type of the data type itself. One can open this module to access
these symbols or hide it to prevent access to them.

## Example data types

The `Unit` type, the simplest data type, has a single constructor named `unit`.

```juvix
--8<------ "docs/reference/language/datatypes.juvix:unit"
```

We then declare the `Nat` type, representing unary natural numbers. It
introduces two constructors: `zero` and `suc`. For instance, `suc zero`
represents one, while `suc (suc zero)` represents two.

```juvix
--8<------ "docs/reference/language/datatypes.juvix:typeNat"
```

These constructors function as regular functions or patterns in pattern matching
when defining functions. Here is an example of a function adding two natural
numbers:

```juvix
--8<------ "docs/reference/language/datatypes.juvix:addNat"
```

# ADT syntax

As an alternative to the above syntax, we can use a more familiar and compact
syntax for declaring data types. This syntax is inspired by ADT syntax in Haskell.

```text
type <name> <type-parameters> :=
  | <constructor1> <arg1-1> ... <arg1-n>
  | ...
  | <constructorN> <argn-1> ... <argn-n>;
```

Different from the previous presentation, here the constructors do not have
typing information.

If a type constructor as above has no arguments, then its type is
the type of the data type being declared. In the case the type constructor has
arguments, then its type is the function type from the types of the arguments to
the type of the data type being declared.

For example, the `Nat` type can be declared as follows:

```juvix
--8<------ "docs/reference/language/datatypes.juvix:natADT"
```

Another example is the `List` type, which is polymorphic in the type of its
elements.

```juvix
--8<------ "docs/reference/language/datatypes.juvix:listADT"
```

## Polymorphic data type

A data type can possess type parameters. When a data type has a type parameter
`A`, it is referred to as _polymorphic in_ `A`.

A classic example of this concept is the `List` type, which is polymorphic in
the type of its list elements.

```juvix
--8<------ "docs/reference/language/datatypes.juvix:typeList"
```

The following function determines whether an element is in a list or not.

```juvix
--8<------ "docs/reference/language/datatypes.juvix:elemList"
```

For more examples of inductive types and how to use them, see [the Juvix
standard library](https://anoma.github.io/juvix-stdlib/).
