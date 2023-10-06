---
icon: material/math-integral
comments: false
search:
  boost: 3
---

# Operator Syntax

The `syntax` keyword, paired with `operator`, caters for functions serving as
operators. These operators often have distinct associativity and precedence from
regular functions. The pairing associates a term with one [fixity](./fixity.md),
defining its arity and potentially its precedence and associativity. This syntax
declaration has to precede the term declaration.

```juvix
syntax operator <name> <fixity>;
```

Where `<fixity>` is a previously declared [fixity](./fixity.md). Note that there
are already many commons of these declarations included with the standard
library. See [common fixities](./fixity.md#examples-of-fixity-declarations) for more
information.

For instance, we can define the `×` operator as a binary operator as follows:

```juvix
--8<------ "docs/reference/language/operators.juvix:product"
```
