---
icon: material/reiterate
comments: true
---

# Iterators

Any identifier can be declared an iterator. The declaration has the form
```juvix
syntax iterator iter;
```
or
```juvix
syntax iterator iter {init: n; range: k};
```
where `n` and `k` specify the number of *initializers* (of the form `acc := a`) and *ranges* (of the form `x in xs`) in iterator application. If the number of initializers or ranges is not specified, then any number is allowed in iterator application.

An application of an iterator `iter` has the general form
```juvix
iter (acc1 := a1; ..; accn := an) (x1 in xs1; ..; xk in xsk) body
```
where `acci`, `xi` are patterns, `ai`, `xsi` are expressions, and `body` is an expression which can refer to the variables bound by the `acci`, `xi`.

The iterator application syntax is equivalent to
```juvix
iter \{acc1 .. accn x1 .. xk := body} a1 .. an xs1 .. xsk
```
