---
icon: material/face-recognition
comments: false
search:
  boost: 3
---

```juvix hide
module reference.language.traits;
import Stdlib.Prelude open hiding {Show; mkShow; module Show; showListI};
```

# Traits

A trait is a special type of [record](./records.juvix.md) that can be used to define a
set of functions that must be implemented for a given type.

## Trait declarations

Traits are declared
using the `trait` keyword, followed by a record type declaration.

```text
trait
--8<------ "docs/reference/language/syntax.md:record-syntax"
```

For example, the following defines a trait `Show`. Any type `A` that implements
`Show` must provide a function `show` that takes an `A` and returns a `String`.

```juvix
trait
type Show A := mkShow@{show : A -> String};
```

## Instance declarations

An instance of a trait is a value of the corresponding record type, which
must implement all methods stipulated by the trait.

To indicate that a given global definition declares an instance of a trait, we use the `instance`
keyword. To create the instance record, we use the trait constructor of the
corresponding record type.

```text
--8<------ "docs/reference/language/syntax.md:instance-syntax"
```

For example, we could define three instances of `Show` for `String`, `Bool`, and
`Nat` as follows:

```juvix
instance
showStringI : Show String := mkShow@{show := id};

instance
showBoolI : Show Bool :=
  mkShow@{
    show (x : Bool) : String :=
      if
        | x := "true"
        | else := "false";
  };

instance
showNatI : Show Nat :=
  mkShow@{
    show := natToString
  };
```

## Instance arguments

The following a bit more involved example defines an instance of `Show`
for the type of lists:

```juvix extract-module-statements
module show-list;

showList {A} {{Show A}} : List A -> String
  | nil := "nil"
  | (h :: t) := Show.show h ++str " :: " ++str showList t;

instance
showListI {A} {{Show A}} : Show (List A) :=
   mkShow@{show := showList};

end;
```

The second argument of `showList` of type `Show A` is an _instance
argument_, which is indicated by enclosing the argument type in double
braces. When calling a function, the instance arguments are typically
not provided explicity but inferred with instance resolution.

The above instance definition could be written more compactly:

```
instance
showListI {A} {{Show A}} : Show (List A) :=
   mkShow@{
     show : List A -> String
       | nil := "nil"
       | (h :: t) := Show.show h ++str " :: " ++str show t;
   };
```

In the body of `show`, the qualified `Show.show` refers to the trait projection, i.e., the record projection associated with the trait `Show`, while unqualified `show` refers to the function being defined recursively. One uses trait projections to automatically infer appropriate instance arguments.

In contrast to record projections for non-trait types, the first non-parameter argument of a trait projection is an instance argument and not ordinary explicit argument. For example, the type signature of `Show.show` is:

```
Show.show {A} : {{Show A}} -> List A -> String
```


## Instance resolution

Instance resolution is the search for a declared instance matching a
given trait type. The search includes all locally accessible instance
variables and all instances declared with the `instance` keyword. If
there is no matching instance or there is an ambiguity (more than one
instance matches), then instance resolution fails.

For example, in

```juvix
showNatList (lst : List Nat) : String := Show.show lst;
```

the implicitly inferred instance value of type `Show (List Nat)` for `Show.show lst` is `showListI {{showNatI}}`. In the first instance resolution step, we see that `Show (List Nat)` matches the type `Show (List A)` of the instance `showListI`. The type parameter `A` is treated as a variable that can match any type, `Nat` in particular. Since `showListI` has an instance argument of type `Show A`, a matching instance must be inferred for `Show Nat` in the second step. We see that `showNatI` of type `Show Nat` is a matching instance. Since in both steps there was no ambiguity (only one instance matched), instance resolution succeeds.

To prevent looping during instance search, we need to ensure that the trait parameters in instance types are structurally decreasing. Therefore, the following instance is rejected:

```
type Box A := box A;

trait
type T A := mkT@{pp : A -> A};

instance
boxT {A} {{T (Box A)}} : T (Box A) := mkT (\{x := x});
```

We check whether each parameter is a strict subterm of some trait parameter in
the target. This ordering is included in the finite multiset extension of the
subterm ordering, hence terminating.

## Matching on implicit instances

It is possible to manually provide an instance and to match on implicit
instances, as shown below:

```juvix
f {A} {{Show A}} (x : A) : String :=
  Show.show x;

f' {A} : {{Show A}} -> A -> String
  | {{mkShow s}} x := s x;

f'' {A} : {{Show A}} -> A -> String
  | {{M}} x := Show.show {{M}} x;
```

## Example

Using the `Show` trait and the function `printStringLn` and `IO` from
the standard library, we could use the instances of `Show` as follows:

```juvix
main : IO :=
  printStringLn (Show.show true)
    >>> printStringLn (f false)
    >>> printStringLn (Show.show 3)
    >>> printStringLn (Show.show [true; false])
    >>> printStringLn (Show.show [1; 2; 3])
    >>> printStringLn (f' [1; 2])
    >>> printStringLn (f'' [true; false])
    >>> printStringLn (Show.show ["a"; "b"; "c"; "d"]);
```

## Instance coercions

A coercion from trait `T` to `T'` can be declared with the syntax
```
coercion instance
coeName {A} {{T A}} : T' A := ...
```
Coercions can be seen as instances with special resolution rules.

### Coercion resolution rules

* If a non-coercion instance can be applied in a single instance resolution step, no coercions are considered. No ambiguity results if there exists some coercion which could be applied, but a non-coercion instance exists - the non-coercion instances have priority.
* If no non-coercion instance can be applied in a single resolution step, all minimal coercion paths which lead to an applicable non-coercion instance are considered. If there is more than one, ambiguity is reported.

### Examples

The following type-checks because:

1. There is no non-coercion instance found for `U String`.
2. There are two minimal coercion paths `U` <- `U1` and `U` <- `U2`, but only one of them (`U` <- `U2`) ends in an applicable non-coercion instance (`instU2` for `U2 String`).

```juvix extract-module-statements
module coercions-1;

trait
type U A := mkU {pp : A -> A};

trait
type U1 A := mkU1 {pp : A -> A};

trait
type U2 A := mkU2 {pp : A -> A};

coercion instance
fromU1toU {A} {{U1 A}} : U A :=
  mkU@{
    pp := U1.pp
  };

coercion instance
fromU2toU {A} {{U2 A}} : U A :=
  mkU@{
    pp := U2.pp
  };

instance
instU2 : U2 String := mkU2 id;

printMain : IO := printStringLn (U.pp "X")

end;
```

The following results in an ambiguity error because:

1. There is no non-coercion instance found for `T Unit`.
2. There are two minimal coercion paths `T` <- `T1` and `T` <- `T2`, both of which end in applicable non-coercion instances.

```
trait
type T A := mkT { pp : A → A };

trait
type T1 A := mkT1 { pp : A → A };

trait
type T2 A := mkT2 { pp : A → A };

instance
unitT1 : T1 Unit := mkT1 (pp := λ{_ := unit});

instance
unitT2 : T2 Unit := mkT2 (pp := λ{_ := unit});

coercion instance
fromT1toT {A} {{T1 A}} : T A := mkT@{
  pp := T1.pp
};

coercion instance
fromT2toT {A} {{T2 A}} : T A := mkT@{
  pp := T2.pp
};

myUnit : Unit := T.pp unit;
```

The following type-checks, because there exists a non-coercion instance for `T2 String`, so the coercion `fromT1toT2` is ignored during instance resolution.

```juvix extract-module-statements
module coercions-2;

trait
type T1 A := mkT1 {pp : A -> A};

trait
type T2 A := mkT2 {pp : A -> A};

instance
instT1 {A} : T1 A :=
  mkT1@{
    pp := id
  };

coercion instance
fromT1toT2 {A} {{M : T1 A}} : T2 A :=
  mkT2@{
    pp := T1.pp {{M}}
  };

instance
instT2 : T2 String :=
  mkT2@{
    pp (s : String) : String := s ++str "!"
  };

myString : String := T2.pp "a";

end;
```
