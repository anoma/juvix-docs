---
icon: material/list-box
comments: true
---

# Records

A record is a special [data type](./datatypes.md) which contain one or more data
constructors, each with labeled type arguments.

For example, the following defines a record type `Person` with a single
constructor `mkPerson` that takes two arguments, `name` and `age`, of types
`String` and `Nat`, respectively.

```juvix
--8<------ "docs/reference/language/records.juvix:person"
```

In each type constructor of the record, the type arguments are called _fields_.
Each field consists of a name and type. The field's name can be used to access
to the value connected with the term of the record type.

The syntax for declaring a record type is as follows:

```text
type <record name> <type parameters> :=
    | <type-constructor1> {
        <field1-1> : <type1-n>;
        ...
        <field1-n> : <type1-n>
        }
    | ...
    | <type-constructor-n> {
        <fieldn-1> : <typen-1>;
        ...
        <fieldn-n> : <typen-n>
    };
```

## Using Records

Records are just like any other data type. They can be used in local
definitions, exported from a module, and used in pattern matching.

That is, one could define a record with a single constructor or multiple
constructors. For instance, here is an example declaring the `newType` record
type declaration with the `mkNewtype` type constructor and one filed named `f`.

```juvix
--8<------ "docs/reference/language/records.juvix:declaringnewtype"
```

We could also define a record with multiple constructors. For instance, let us
define the record type called `Pair` to model pairs of values. The `Pair`
type has a single `mkPair` type constructor that takes two arguments, called
`fst` and `snd`, of types `A` and `B`, respectively.

```juvix
--8<------ "docs/reference/language/records.juvix:pair"
```

To use this type, create a `Pair` type term (a pair) using the `mkPair` type
constructor and supplying values for each field.

```juvix
--8<------ "docs/reference/language/records.juvix:declaringpair"
```

Field names enable access to their associated values. For instance, another pair
equivalent to the one defined above can be declared using values extracted via
the field names.

```juvix
--8<------ "docs/reference/language/records.juvix:viafields"
```

The fields record type's fields are qualified by the type name by default. To
access the fields without the type name, use the `open` keyword to bring these
names into scope.

```juvix
--8<------ "docs/reference/language/records.juvix:openrecord"
```

Lastly, let us declare a record with multiple constructors.

```juvix
--8<------ "docs/reference/language/records.juvix:declaringenum"
```
