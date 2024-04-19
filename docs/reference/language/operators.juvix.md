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

The `syntax` keyword, paired with `operator`, caters for functions serving as
operators. These operators often have distinct associativity and precedence from
regular functions. The pairing associates a term with one [fixity](./fixity.juvix.md),
defining its arity and potentially its precedence and associativity. This syntax
declaration has to precede the term declaration.

```text
syntax operator <name> <fixity>;
```

Where `<fixity>` is a previously declared [fixity](./fixity.juvix.md). Note that there
are already many commons of these declarations included with the standard
library. See [common fixities](./fixity.juvix.md#examples-of-fixity-declarations) for more
information.

For instance, we can define the `×` operator as a binary operator as follows:

```juvix
syntax fixity product := binary;
syntax operator × product;
type × (a : Type) (b : Type) := , : a → b → a × b;
```
