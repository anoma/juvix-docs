---
title: Juvix Packages and Projects
hide:
  - navigation
  - toc
---


## Quick Start

To install a package, you must sure that you have created the `Package.juvix`
file. You can run `juvix init` to get a template `Package.juvix` file. A more
detailed description on the usage of `Package.juvix` can be found in [*How to
setup a Juvix project*](./howto/project.md). For now, one example is
provided below. Put the following in your `Package.juvix` file within 
the directory of your project.

```text
 --8<------ "docs/reference/language/Package.juvix"
```

<div class="grid cards" markdown>

- :octicons-mark-github-16: [`anoma/juvix-containers`](https://github.com/anoma/juvix-containers)

    ***


    === "Description"

        Immutable container types for Juvix.

        - [x] BinaryTree, Map, Queue, Set, Tree, UnbalancedSet, and much more to come.
        
        - [x] Tests using [anoma/juvix-test](#anomajuvix-test).
        
    === "Install"

        Add the following to your `Package.juvix` file in the `dependencies` field:

        ```text
        --8<------ "docs/Package.juvix:juvix-containers"
        ```

- :octicons-mark-github-16: [`anoma/juvix-quickcheck`](https://github.com/anoma/juvix-quickcheck)

    ***

    === "Description"

        This package provides property-based testing for the Juvix programming language inspired by the popular Haskell library, QuickCheck.

        - [x] Automated testing: Generate random test cases to validate properties of Juvix code.

    === "Install"

        Add the following to your `Package.juvix` file in the `dependencies` field:

        ```text
        --8<------ "docs/Package.juvix:juvix-quickcheck"
        ```


- :octicons-mark-github-16: [`anoma/juvix-stdlib`](https://github.com/anoma/juvix-stdlib)

    ***


    === "Description"

        Shipped with Juvix, the standard library provides a set of useful functions
        and types for writing Juvix programs.

    === "Install"

        Add the following to your `Package.juvix` file in the `dependencies` field:

        ```text
        --8<------ "docs/Package.juvix:juvix-stdlib"
        ```

- :octicons-mark-github-16: [`anoma/juvix-test`](https://github.com/anoma/juvix-test)

    ***

    === "Description"

        A unit testing framework for Juvix programs.

    === "Install"

        Add the following to your `Package.juvix` file in the `dependencies` field:

        ```text
        --8<------ "docs/Package.juvix:juvix-test"
        ```

</div>

## Projects using Juvix

<div class="grid cards" markdown>

- :octicons-mark-github-16: [`anoma/abstract-resource-machine-simulator`](https://github.com/anoma/abstract-resource-machine-simulator)

    ***

    === "Description"

        The Taiga Simulator is a [Juvix](https://juvix.org) function that simulates the [Taiga](https://github.com/anoma/taiga) execution model.

    === "Install"

        Add the following to your `Package.juvix` file in the `dependencies` field:

        ```text
        --8<------ "docs/Package.juvix:abstract-resource-machine-simulator"
        ```
    

- :octicons-mark-github-16: [`anoma/juvix-e2e-demo`](https://github.com/anoma/juvix-e2e-demo)

    ***

    A project for demostrating the process of generating arithmetic circuits from high-level specifications. This CodeSpace includes all the necessary compilers for circuit generation, such as Juvix, GEB, and VampIR. Furthermore, it features the Juvix VSCode extension to simplify writing Juvix programs and allows users to interact with and evaluate the resulting GEB/VampIR programs.

</div>

Please let us know if you are using Juvix in your project. Opening an issue or a
pull request to add it to this list.

## Other Small Example Programs

--8<-- "docs/reference/examples.md:8:"
