---
icon: material/car-traction-control
comments: true
---

# Control structures

## Case

A case expression has the following syntax:

```juvix
case value
| pat1 := branch1
..
| patN := branchN
```

For example, one can evaluate the following expression in the REPL:

```juvix
Stdlib.Prelude> case 2 | zero := 0 | suc x := x
1
```

## Lazy builtins

The standard library provides several builtin functions which are
treated specially and evaluated lazily. These builtins must always be
fully applied.

- `if condition branch1 branch2`. First evaluates `condition`, if true
  evaluates and returns `branch1`, otherwise evaluates and returns
  `branch2`.
- `a || b`. Lazy disjunction. First evaluates `a`, if true returns
  true, otherwise evaluates and returns `b`.
- `a && b`. Lazy conjunction. First evaluates `a`, if false returns
  false, otherwise evaluates and returns `b`.
- `a >> b`. Sequences two IO actions. Lazy in the second argument.
