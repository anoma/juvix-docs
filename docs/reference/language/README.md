---
icon: material/label-outline
comments: false
search:
  boost: 4
hide:
  - toc
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

## Related internal reports

An ongoing effort to specify the Juvix language and internal representations
along its semantics is being carried out in the form of internal reports. These
reports are written for our own internal use and are not intended to be read by
the public, at least for now. However, we are making them available here
for the sake of transparency.

<div style="text-align:center" markdown>

| Title                      | Doi/url                                                     | Date         |
| :------------------------- | :---------------------------------------------------------- | :----------- |
| Juvix to VampIR Pipeline   | [10.5281/zenodo.8268823](https://zenodo.org/record/8268823) | Aug 14, 2023 |
| The Core language of Juvix | [10.5281/zenodo.8297159](https://zenodo.org/record/8297159) | Aug 29, 2023 |
| Geb Pipeline               | [10.5281/zenodo.8262747](https://zenodo.org/record/8262747) | Aug 21, 2023 |
| Rethinking VampIR          | [10.5281/zenodo.8262815](https://zenodo.org/record/8262815) | Aug 29, 2023 |

</div>

[stdlib]: https://anoma.github.io/juvix-stdlib/
