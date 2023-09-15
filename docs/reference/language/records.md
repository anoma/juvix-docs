---
icon: material/list-box
comments: true
---

# Record Syntax

A record is a user-defined type housing one or more data constructors, each with
labeled type arguments. These arguments are termed as *fields* of the associated
record and consist of a name and type. The field's name is used to access to the
value linked with the term of the record type. 

```markdown
type <record name> <type parameters> := 
    <type-constructor1> { 
        <field1-1> : <type1-n>;
        ...
        <field1-n> : <type1-n> };
    ...
    <type-constructor-n> { 
        <fieldn-1> : <typen-1>;
        ...
        <fieldn-n> : <typen-n> };
```

To instantiate a term of a record type, use one of its type constructors and
provide values for each field.

## Using Records

A record type can be defined simply with one type constructor and one field, as
demonstrated in the `newtype` record type declaration below, which features the
`mkNewtype` type constructor and `f` field.

```juvix
--8<------ "docs/reference/language/records.juvix:declaringnewtype"
```

Consider defining a `Pair` record type to model pairs of values. Here, the type
has a single `mkPair` type constructor that accepts two arguments, `fst` and
`snd`, of types `A` and `B` respectively. 

```juvix
--8<------ "docs/reference/language/records.juvix:pair"
```

To utilize this type, create a `Pair` type term (a pair) using the `mkPair` type
constructor and supplying values for each field. 

```juvix
--8<------ "docs/reference/language/records.juvix:declaringpair"
```

Field names enable access to their associated values. For instance, another pair
equivalent to the one defined above can be declared using values extracted from
the previously declared pair.

```juvix
--8<------ "docs/reference/language/records.juvix:viafields"
```

Noticeably, a record type's fields are qualified by the type name by default. To
access the fields without the type name, use the `open` keyword to bring these
names into scope.

```juvix
--8<------ "docs/reference/language/records.juvix:openrecord"
```

Lastly, let us declare a record with multiple constructors.

```juvix
--8<------ "docs/reference/language/records.juvix:declaringenum"
```