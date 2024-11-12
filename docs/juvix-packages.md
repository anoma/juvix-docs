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

??? example "Package.juvix"

    ```text
    --8<------ "docs/blog/posts/strictly-positive-data-types/Package.juvix"
    ```


<div class="grid cards" markdown>

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
</div>

## Projects using Juvix

<div class="grid cards" markdown>

- :octicons-mark-github-16: [Anoma App Library](https://github.com/anoma/anoma-applib)

    ***

    === "Description"

        A library for intent-centric application development.

    === "Install"

        Add the following to your `Package.juvix` file in the `dependencies` field:

        ```text
        --8<------ "docs/Package.juvix:anoma-applib"
        ```

</div>

Please let us know if you are using Juvix in your project. Opening an issue or a
pull request to add it to this list.

Check out other examples of Juvix programs in the [examples/milestone](./reference/examples.md).
