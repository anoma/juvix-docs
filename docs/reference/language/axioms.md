---
icon: material/axe
comments: false
search:
  boost: 3
---

# Axiom

Axioms or postulates are used to introduce new terms or types without defining
them. This is done using the `axiom` keyword.

```text
--8<------ "docs/reference/language/syntax.md:axiom-syntax"
```

## Usage

Consider a scenario where you want to create a program that assumes _A_ as a
type, and there exists a term _x_ that belongs to this type _A_. The syntax for
such a program would be as follows:

```juvix
--8<------ "docs/reference/language/axioms.juvix"
```

## Important Considerations

It is crucial to understand that terms introduced by the `axiom` keyword do not
contain any computational content. This implies that they are merely abstract
concepts without any inherent operational value.

Consequently, programs that include axioms (which are not marked as builtins)
cannot be compiled to most targets.
