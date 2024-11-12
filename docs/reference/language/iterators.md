---
icon: material/reiterate
comments: false
search:
  boost: 3
---

# Iterators

Any identifier can be declared as an iterator. The syntax to define an iterator is:

```text
--8<-- "docs/reference/language/syntax.md:iterator-syntax-simple"
```

or

```text
--8<-- "docs/reference/language/syntax.md:iterator-syntax-simple-with-arguments"
```

where `n` and `k` specify the number of _initializers_ (of the form `acc := a`) and _ranges_ (of the form `x in xs`) in iterator application. If the number of initializers or ranges is not specified, then any number is allowed in iterator application.

An application of an iterator `iter` has the general form

```text
iter (acc1 := a1; ..; accn := an) (x1 in xs1; ..; xk in xsk) {body}
```

where `acci`, `xi` are patterns, `ai`, `xsi` are expressions, and `body` is an expression which can refer to the variables bound by the `acci`, `xi`. The braces around `body` are optional when `body` is an atom.

The iterator application syntax is equivalent to

```text
iter \{acc1 .. accn x1 .. xk := body} a1 .. an xs1 .. xsk
```
