---
icon: material/office-building-plus-outline
comments: false
search:
  boost: 3
---

```juvix hide
module reference.language.builtins;
import Stdlib.Data.Fixity open;
```

# Built-ins

Juvix has support for the built-in natural type and a few functions that
are compiled to efficient primitives.

## Built-in inductive definitions

```juvix
builtin nat
type Nat :=
  | zero : Nat
  | suc : Nat → Nat;
```

## Builtin function definitions

```juvix
syntax operator + additive;
builtin nat-plus
+ : Nat → Nat → Nat
  | zero b := b
  | (suc a) b := suc (a + b);
```

## Builtin axiom definitions

```juvix extract-module-statements 
module example-print-nat;
  
  builtin IO
  axiom IO : Type;

  builtin nat-print
  axiom printNat : Nat → IO;
end;
```
