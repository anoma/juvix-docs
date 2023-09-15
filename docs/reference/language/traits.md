---
icon: material/face-recognition
comments: true
---

# Traits

## Defining traits

A trait is a special type of record that can be used to define a set of
functions that must be implemented for a given type. Traits are declared using
the `trait` keyword. 

```juvix
trait
<record type declaration>
```

Recall a record type declaration is of the form:

```juvix
type <name> <type-parameters> := 
    <constructor> { <field1> : <type1>;
                    ...
                    <fieldn> : <typen> };
```


For example, the following defines a trait `Show`. Any type `A` that implements
`Show` must provide a function `show` that takes an `A` and returns a `String`.


```juvix
trait
type Show A := mkShow { show : A → String };
```

## Defining instances

An instance of a trait refers to a term of the corresponding record type, which
must implement all methods stipulated by the trait. To declare a given term
is an instance of a trait, we use the `instance` keyword. To define an instance
of a trait, we use the trait constructor of the corresponding record type.

```juvix
instance
<term> : {{<trait>}} := <trait constructor> (
    field1 := <term1>;
    ...
    fieldn := <termn>;
);
```

## Using traits

Using the `Show` trait defined above, we can define a function `showNat` that
takes a `Nat` and returns a `String`. One possible implementation is the
following:

```juvix

```


```juvix
--8<------ "docs/reference/language/traits.juvix:usage"
```

To prevent looping during instance search, we ensure a structural decrease in the trait parameters of instance types. Therefore, the following is rejected:

```juvix
type Box A := box A;

trait
type T A := mkT { pp : A → A };

instance
boxT {A} : {{T (Box A)}} → T (Box A) := mkT (λ{x := x});
```

We check whether each parameter is a strict subterm of some trait parameter in
the target. This ordering is included in the finite multiset extension of the
subterm ordering, hence terminating.

## Matching on implicit instances

It is possible to manually provide an instance and to match on implicit
instances:

```juvix
f {A} : {{Show A}} -> A -> String
  | {{mkShow s}} x -> s x;

f' {A} : {{Show A}} → A → String
  | {{M}} x := Show.show {{M}} x;
```
