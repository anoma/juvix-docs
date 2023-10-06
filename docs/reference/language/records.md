---
icon: material/list-box
comments: true
search:
  boost: 3
---

# Records

Records are a special kind of [data type](./datatypes.md). Each data constructor
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
  record type may take, see [data types](./datatypes.md) for more information.
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
--8<------ "docs/reference/language/records.juvix:declaringnewtype"
```

Records with multiple constructors can also be defined. Consider the `Pair`
record type that models pairs of values. The `Pair` type has a single `mkPair`
type constructor that takes two arguments, named `fst` and `snd`, of type
parameters `A` and `B`, respectively.

```juvix
--8<------ "docs/reference/language/records.juvix:pair"
```

To utilize this type, create a `Pair` type term (a pair) using the `mkPair` type
constructor and provide values for each field.

```juvix
--8<------ "docs/reference/language/records.juvix:declaringpair"
```

Field names allow access to their corresponding values. For example, another
pair equivalent to the one defined above can be declared using values retrieved
via the field names.

```juvix
--8<------ "docs/reference/language/records.juvix:viafields"
```

By default, the fields of a record type are qualified by the type name. To
access the fields without specifying the type name, use the `open` keyword to
bring these names into scope.

```juvix
--8<------ "docs/reference/language/records.juvix:openrecord"
```

Finally, consider the declaration of a record with multiple constructors.

```juvix
--8<------ "docs/reference/language/records.juvix:declaringenum"
```
