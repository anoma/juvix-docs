---
icon: material/function-variant
comments: true
---

# Termination

To prevent inconsistencies arising from function declarations, Juvix mandates
that every function passes its termination checker. Nevertheless, this
requirement can be challenging to meet; thus, we provide users with two distinct
methods for bypassing this check:

## Keyword

Utilize the terminating keyword to annotate function type signatures as terminating. In the following example we mark the function `fun` as terminating.

```juvix
terminating
fun : A → B;
```

!!! note

    Annotating a function with the `terminating` keyword indicates that _all_ of its function clauses meet the termination checker's criteria. For mutual recursive functions, to bypass the termination checker, all involved functions must be annotated as `terminating`.

## CLI flag

Utilizing the global CLI flag --no-termination.

```shell
juvix typecheck --no-termination MyProgram.juvix
```

!!! note

    Please note that our termination checker has certain limitations, as it only accepts a subset of recursive functions. The algorithm used in the termination checker is a minor adaptation of the one employed for checking termination in the Foetus language.
