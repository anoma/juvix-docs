---
icon: material/list-box
comments: true
search:
  boost: 3
---

```juvix hide
module reference.language.records;
```

# Records

Records are a special kind of [data type](./datatypes.juvix.md). Each
data constructor within a record has named type arguments. Records are
smilar to structures from languages such as C++ or Java, or to records in
database systems.

## Record declaration

In the context of record types, a _field_ is a named argument of an
inductive type constructor.

The general syntax for declaring a record type is as follows:

```text
trait
--8<------ "docs/reference/language/syntax.md:record-syntax"
```

In this syntax:

- `<record name>` is a unique identifier for the declared record type. This name should be unique within its scope and it is case sensitive.

- `<type parameters>` are optional and represent the generic parameters that the
  record type may take, see [data types](./datatypes.juvix.md) for more information.
  They allow for greater flexibility and reusability of the record type.

- `<type-constructor-k>` is the `k`th constructors of the record type. Each constructor can have a different set of fields.

- `<field1-1>`, `<field1-n>`, `<fieldn-1>`, `<fieldn-n>` are the names of the fields in each constructor. These names should be unique within their constructor.

- `<type-1-n>`, `<type-n-1>`, `<type-n-n>` represent the type of the corresponding field.

Typically, a record has exactly one constructor. The record
declaration syntax, however, can be used to define arbitrary inductive
types with named constructor arguments.

### Examples

We declare the `newType` record type with the `mkNewtype` type
constructor and one field `f`.

```juvix
type T := constructT : T;
type newtype := mkNewtype@{f : T};
```

Consider the `Pair` record type that models pairs of values. The
`Pair` type has a single `mkPair` constructor that takes two arguments
`fst` and `snd` of type `A` and `B` respectively.

```juvix
type Pair (A B : Type) :=
  mkPair@{
    fst : A;
    snd : B
  };
```

Here is a declaration of a "record" with multiple constructors.

```juvix
type EnumRecord :=
  | C1@{
      c1a : T;
      c1b : T
    }
  | C2@{
      c2a : T;
      c2b : T
    };
```

## Record creation

To create a value of type `Pair` from above, use the `mkPair` type
constructor and provide values for each field.

```juvix
p1 : Pair T T :=
  mkPair@{
    fst := constructT;
    snd := constructT
  };
```

An pair of `EnumRecord`s can be created as follows.

```juvix
p2 : Pair EnumRecord EnumRecord :=
  mkPair@{
    fst := C1@{c1a := constructT; c1b := constructT};
    snd := C2@{c2a := constructT; c2b := constructT};
  };
```

## Record projections

For single-constructor records, an implicit module named `<record
name>` is defined with _record projections_, i.e., functions which
allow to access the values of corresponding record fields. The record
projection for field `f` in record `R` is referred to by `R.f`.

For example, a new pair equal to `p1` defined above can be created
using values retrieved with record projections.

```juvix
p1' : Pair T T :=
  mkPair@{
    fst := Pair.fst p1;
    snd := Pair.snd p1;
  };
```

By default, the record projections are qualified by the record type name. To
access the fields without specifying the type name, use the `open` keyword to
bring record projection names into scope.

```juvix extract-module-statements
module Open-Pair;
open Pair;

flipP : Pair T T :=
  mkPair (snd p1) (fst p1);
end;
```

## Record update

The values of record fields can be updated. For example consider a pair of
natural numbers:

```juvix hide
import Stdlib.Data.Nat open;
```

```juvix
natPair : Pair Nat Nat := mkPair@{fst := 1; snd := 2};
```

We can update the value of the `fst` field from `1` to `2` as follows:

```juvix
updatedNatPair : Pair Nat Nat := natPair@Pair{fst := 2};
```

## Record puns

When using records, one often defines variables with the same names as record fields, e.g.,

```juvix
p3 : Pair Nat Nat :=
  let fst := 1;
      snd := 2;
  in mkPair@{
    fst := fst;
    snd := snd;
  };
```

With record punning, the assignment to a record field of a variable with the same name can be simplified by omitting the assignment right-hand side and the assignment symbol. For example, the above definition of `p3` can be abbreviated to:

```juvix
p3' : Pair Nat Nat :=
  let fst := 1;
      snd := 2;
  in mkPair@{fst; snd};
```

## Record patterns

Record syntax can be used in pattern matching, e.g.,

```juvix
f : Pair Nat Nat -> Nat
  | mkPair@{fst := zero; snd} := snd
  | mkPair@{fst} := fst;
```
