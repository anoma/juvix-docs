---
title: Juvix Packages and Projects
---

## Juvix Packages

### [`anoma/juvix-containers`](https://github.com/anoma/juvix-containers)

Immutable container types for Juvix.

- [x] BinaryTree, Map, Queue, Set, Tree, UnbalancedSet, and much more to come.
- [x] Tests using #anoma/juvix-quickcheck.

### [`anoma/juvix-quickcheck`](https://github.com/anoma/juvix-quickcheck)

This package provides property-based testing for the Juvix programming language inspired by the popular Haskell library, QuickCheck.

- [x] Automated testing: Generate random test cases to validate properties of Juvix code.

### [`anoma/juvix-stdlib`](https://github.com/anoma/juvix-stdlib)

Shipped with Juvix, the standard library provides a set of useful functions
and types for writing Juvix programs.

## Projects using Juvix

### [`anoma/taiga-simulator`](https://github.com/anoma/taiga-simulator)

A simulator for [Taiga execution model](https://github.com/anoma/taiga) written in Juvix.

### [`anoma/juvix-e2e-demo`](https://github.com/anoma/juvix-e2e-demo)

A project for demostrating the process of generating arithmetic circuits from high-level specifications. This CodeSpace includes all the necessary compilers for circuit generation, such as Juvix, GEB, and VampIR. Furthermore, it features the Juvix VSCode extension to simplify writing Juvix programs and allows users to interact with and evaluate the resulting GEB/VampIR programs.

!!! info

    If you are using Juvix in your project, please let us know by opening an issue or a pull request to add it to this list.
