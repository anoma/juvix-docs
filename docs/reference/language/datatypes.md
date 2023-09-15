---
icon: material/toy-brick-outline
comments: false
---

# Data types

A data type declaration consists of:

- The `type` keyword,
- a unique name for the type,
- the `:=` symbol, and
- a non-empty list of constructor declarations (functions for
  building the elements of the data type).

The simplest data type is the `Unit` type with one constructor called
`unit`.

```juvix
type Unit := unit : Unit;
```

In the following example, we declare the type `Nat` – the unary
representation of natural numbers. This type comes with two
constructors: `zero` and `suc`.

Example elements of type `Nat`:

- number one represented by `suc zero`
- the number two represented by `suc (suc zero)`
- etc.

```juvix
--8<------ "docs/reference/language/datatypes.juvix:typeNat"
```

Constructors can be used like normal functions or in patterns when
defining functions by [pattern matching](../functions#pattern-matching).
For example, here is a function adding two natural numbers:

```juvix
--8<------ "docs/reference/language/datatypes.juvix:addNat"
```

# ADT syntax

As an alternative to the above syntax, we can use a more familiar and compact
syntax for declaring data types. This syntax is inspired by ADT syntax in Haskell.

```juvix
type <name> <type-parameters> := 
  | <constructor1> <arg1-1> ... <arg1-n> 
  | ... 
  | <constructorN> <argn-1> ... <argn-n>;
```

Different from the previous presentation, here the constructors do not have
typing information. Instead, the typing information is inferred from the
presentation. If a type constructor as above has no arguments, then its type is
the type of the data type being declared. In the case the type constructor has
arguments, then its type is the function type from the types of the arguments to
the type of the data type being declared.

For example, the `Nat` type can be declared as follows:

```juvix
type Nat := Z | S Nat;
```

Another example is the `List` type, which is polymorphic in the type of its
elements.

```juvix
type List A := Nil | Cons A (List A);
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

<!-- TODO projections  -->

<!-- import Stdlib.Prelude open hiding {Show;mkShow;module Show}; -->
