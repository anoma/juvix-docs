---
icon: material/car-traction-control
comments: false
---

# Control Structures

## Case Expressions

The syntax for a case expression is:

```juvix
case <expression> of {
  | <pat1> := <branch1>
  ..
  | <patN> := <branchN>
  }
```

For instance, evaluation of the following expression in the REPL yields `1`:

```juvix
Stdlib.Prelude> case 2 of { | zero := 0 | suc x := x }
1
```

## Lazy Builtins

The standard library offers several lazily evaluated builtin functions. These must be fully applied.

- `if condition branch1 branch2`: Evaluates `condition` first, returns `branch1` if true, else returns `branch2`.
- `a || b`: Lazy disjunction. Evaluates `a` first, returns true if true, else evaluates and returns `b`.
- `a && b`: Lazy conjunction. Evaluates `a` first, returns false if false, else evaluates and returns `b`.
- `a >> b`: Sequences two IO actions, lazy in the second argument.
