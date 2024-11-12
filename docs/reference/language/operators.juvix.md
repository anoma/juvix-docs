---
icon: material/math-integral
comments: false
search:
  boost: 3
---

```juvix hide
module reference.language.operators;
```

# Operator Syntax

The `syntax` keyword followed by `operator` declares a function to be
an operators. These operators often have distinct associativity and
precedence from regular functions. The operator declaration associates a term with
one [fixity](./fixity.juvix.md) which define its arity and potentially
its precedence and associativity. The operator syntax declaration has to
precede the term declaration.

```text
syntax operator <name> <fixity>;
```

Here `<fixity>` is a previously declared [fixity](./fixity.juvix.md). Note that there
are already many common fixities included in the standard
library. See [common fixities](./fixity.juvix.md#examples-of-fixity-declarations) for more
information.

For instance, we can define the `×` operator as a binary operator:

```juvix
syntax fixity product := binary;
syntax operator × product;
type × (a : Type) (b : Type) := , : a → b → a × b;
```
