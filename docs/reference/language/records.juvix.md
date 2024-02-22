---
icon: material/list-box
comments: true
search:
  boost: 3
---

```juvix hide
module records;
```

# Records

Records are a special kind of [data type](./datatypes.juvix.md). Each data constructor
within a record has named type arguments. This feature is reminiscent of
declaring a structure in languages such as C++ or Java, or akin to defining a
record in a database system.

## Syntax and Semantics

In the context of record types, a _field_ is a named type argument that is
intrinsically associated with a data constructor. The field's name functions as
an identifier or a key, enabling access to the value that is bound to the term
of the record type.

The standard syntax for declaring a record type is as follows:

```text
trait
--8<------ "docs/reference/language/syntax.md:record-syntax"
```

In this syntax:

- `<record name>` is a unique identifier for the declared record type. This name should be unique within its scope and it is case sensitive.

- `<type parameters>` are optional and represent the generic parameters that the
  record type may take, see [data types](./datatypes.juvix.md) for more information.
  They allow for greater flexibility and reusability of the record type.

- `<type-constructor>` represents the different constructors that the record type can have. Each constructor can have a different set of fields.

- `<field1-1>`, `<field1-n>`, `<fieldn-1>`, `<fieldn-n>` are the names of the fields in each constructor. These names should be unique within their constructor.

- `<type-1-n>`, `<type-n-1>`, `<type-n-n>` represent the type of the corresponding field.

!!!note

        One thing to note is that the field names are qualified by the type
        name. This means that the field names are prefixed by the type name when
        accessing them. If this is not desired, the `open` keyword can be used
        to bring the field names into scope followed by the type name.

## Usage

Records function similarly to other data types. They can be defined locally,
exported from a module, and utilized in pattern matching.

For example, here we declare the `newType` record type with the `mkNewtype` type
constructor and one field named `f`.

```juvix
type T := constructT : T;
type newtype := mkNewtype {f : T};
```

Records with multiple constructors can also be defined. Consider the `Pair`
record type that models pairs of values. The `Pair` type has a single `mkPair`
type constructor that takes two arguments, named `fst` and `snd`, of type
parameters `A` and `B`, respectively.

```juvix
type Pair (A B : Type) :=
  mkPair {
    fst : A;
    snd : B
  };
```

To utilize this type, create a `Pair` type term (a pair) using the `mkPair` type
constructor and provide values for each field.

```juvix
p1 : Pair T T :=
  mkPair (fst := constructT; snd := constructT);
```

Field names allow access to their corresponding values. For example, another
pair equivalent to the one defined above can be declared using values retrieved
via the field names.

```juvix
p1' : Pair T T :=
  mkPair (fst := Pair.fst p1; snd := Pair.snd p1);
```

One variant of the record term creation is as follows:

```juvix
p1'' : Pair T T :=
  mkPair@{
    fst := Pair.fst p1;
    snd := Pair.snd p1
  };
```

By default, the fields of a record type are qualified by the type name. To
access the fields without specifying the type name, use the `open` keyword to
bring these names into scope.

```juvix
open Pair;

flipP : Pair T T := mkPair (fst := snd p1; snd := fst p1);
```

The values of record fields can be updated. For example consider a pair of
natural numbers:

```juvix hide
import Stdlib.Data.Nat open;
```

```juvix
intPair : Pair Nat Nat := mkPair@{fst := 1; snd := 2};
```

We can update the value of the `fst` field from `1` to `2` as follows:

```juvix
updateIntPair : Pair Nat Nat := intPair@Pair{fst := 2};
```

The original value of the record field is in scope when updating. In the
following example the value of the `snd` field is updated from `2` to `3`.:

```
incrementIntPair : Pair Nat Nat := intPair@Pair{snd := snd + 1}
```

Finally, consider the declaration of a record with multiple constructors.

```juvix
type EnumRecord :=
  | C1 {
      c1a : T;
      c1b : T
    }
  | C2 {
      c2a : T;
      c2b : T
    };

p2 : Pair EnumRecord EnumRecord :=
  mkPair
    (fst := C1 (c1a := constructT; c1b := constructT);
    snd := C2 (c2a := constructT; c2b := constructT));
```
