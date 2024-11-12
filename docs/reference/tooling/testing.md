---
icon: material/language-haskell
comments: true
---

# Testing

### Dependencies

See [Installing dependencies](./doctor.md) for instructions on how to
set up the testing environment for the WASM compiler tests.

### Running

Run tests using:

```shell
make test
```

Or using `Stack`:

```shell
stack test
```

To run only quick tests, ignoring all slow tests:

```shell
stack test --ta '-p "! /slow tests/"'
```
