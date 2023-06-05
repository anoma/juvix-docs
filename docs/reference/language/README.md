---
icon: material/label-outline
comments: true
---

Juvix is designed with a focus on safety. The Juvix compiler runs several
static analyses which guarantee the absence of runtime errors. Analyses
performed include termination and type checking. As a result, functional
programs, especially validity predicates, can be written with greater confidence
in their correctness.

Some language features in Juvix include:

- Haskell/Agda-like syntax with support for Unicode
- Type inference
- Parametric polymorphism
- User defined inductive data types
- Higher-order functions
- Referential transparency

The Juvix module system allows developers to break down their programs into
smaller, reusable modules that can be compiled separately and combined to create
larger programs. These modules can be used to build libraries, which can then be
documented using Juvix's built-in documentation generation tool, see for
example, [the Juvix standard library's website][stdlib].

[stdlib]: https://anoma.github.io/juvix-stdlib/
