---
icon: material/function-variant
comments: false
search:
  boost: 3
---

```juvix hide
module reference.language.functions;
```

# Function Declarations in Juvix

In Juvix, a function declaration is composed of a type signature and the body of
the function. The type signature specifies the types of the arguments and the
return type of the function. Constants are considered to be functions with no
arguments. The body of a function can either be a single expression or a set of
function clauses when pattern matching is employed.

## Syntax of Function Declarations

The syntax for a function declaration has the following form:

```text
--8<-- "docs/reference/language/syntax.md:function-syntax"
```

Function declarations in Juvix can have variations related to named and implicit
arguments.

### Named Arguments

A named argument is an argument whose name is specified in the function type
signature before the colon. This name is then available within the scope of the
function's body.

```text
--8<-- "docs/reference/language/syntax.md:function-named-arguments"
```

For example, consider the function `multiplyByTwo` which takes a `Nat` (natural
number) and returns a `Nat`. The argument is named `n` and is used in the
function's body to return `2 * n`.

```juvix extract-module-statements 1
module example-multiply-by-two;
  import Stdlib.Data.Nat open using {Nat; *};
  multiplyByTwo (n : Nat) : Nat := 2 * n;
end;
```

The argument `n` can then be provided to `multiplyByTwo` explicitly by
name:

```juvix extract-module-statements 2
module example-multiply-by-two-application;
  import Stdlib.Data.Nat open using {Nat; *};
  multiplyByTwo (n : Nat) : Nat := 2 * n;
  four : Nat := multiplyByTwo@{n := 2};
end;
```

### Default Values

We can assign default values to function arguments. This feature allows a
function to operate without explicit argument values by using the provided
defaults.

To specify a default value for an argument, use the `:=` operator followed by
the desired value. In the following example, `x` and `y` are given default
values of `0` and `1`, respectively:


```juvix extract-module-statements 1
module default-values;
  import Stdlib.Prelude open;
  f {x : Nat := 0} {y : Nat := 1} : Nat := x + y;
end;
```

When calling this function without providing values for `x` and `y`, such as
`f`, the function will use the default values and return `1`.

!!! note

    Here are some key points to remember about using default argument values in
    Juvix:

    1. **No Referencing Previous Arguments**: Default values cannot refer to
      previous arguments. Therefore, the following code would result in a scope
      error:

        ```text
        f {n : Nat := 0} {m : Nat := n + 1} ....
        ```

    2. **Function-Specific Feature**: Only functions can have default values. Other
      constructs or types do not support this feature.

    3. **Left-Hand Side Limitation**: Only arguments on the left-hand side (LHS) of
      the `:` can have default values. The following syntax is invalid:

        ```text
        f : {n : Nat := 0} := ...
        ```

## Pattern Matching in Function Declarations

A function may consist of one or more function clauses instead of a single
expression. This is applicable when the function's argument is a data type and
we want to pattern match on that argument.

The syntax for a function declaration using pattern matching is as follows:

```text
--8<-- "docs/reference/language/syntax.md:function-pattern-matching"
```

Here `<pat1>` through `<patN>` are patterns that are matched against the
argument of the function. The corresponding body is evaluated when the pattern
matches.

For instance, consider the following function with two clauses:

```juvix extract-module-statements 1
module example-negate-boolean;
  import Stdlib.Data.Bool open;

  neg : Bool -> Bool
    | true := false
    | false := true;
end;
```

When `neg` is called with `true`, the first clause is used and the function
returns `false`. Similarly, when `neg` is called with `false`, the second clause
is used and the function returns `true`.

Note that one may pattern match multiple arguments at once. The syntax in for two arguments is as follows and can be extended to more arguments.

```text
--8<-- "docs/reference/language/syntax.md:function-pattern-matching-multiple-arguments"
```


!!! note

    Initial function arguments that match variables or wildcards in all clauses can
    be moved to the left of the colon in the function definition. For example,

    ```juvix extract-module-statements 1
    module move-to-left;
      import Stdlib.Data.Nat open;

      add (n : Nat) : Nat -> Nat
        | zero := n
        | (suc m) := suc (add n m);
    end;
    ```

    is equivalent to

    ```juvix extract-module-statements 1
      module example-add;
        import Stdlib.Data.Nat open;
        add : Nat -> Nat -> Nat
          | n zero := n
          | n (suc m) := suc (add n m);
      end;
    ```

    If there is only one clause without any patterns, the pipe `|` must be omitted.

    ```juvix extract-module-statements 1
    module short-definitons;
      import Stdlib.Data.Nat open;
      multiplyByTwo (n : Nat) : Nat := n;
    end;
    ```

## Mutually Recursive Functions

Functions in Juvix can depend on each other recursively. In the following
example, a function checks if a number is `even` by calling another function
that verifies if the number is `odd`.

```juvix extract-module-statements 3
module mutually-recursive;
  import Stdlib.Data.Nat open;
  import Stdlib.Data.Bool open;
  import Stdlib.Prelude open;

  isOdd : Nat -> Bool
    | zero := false
    | (suc n) := isEven n;

  isEven : Nat -> Bool
    | zero := true
    | (suc n) := isOdd n;
end;
```

Identifiers don't need to be defined before they are used, allowing for mutually
recursive functions/types without any special syntax. However, exceptions exist.
A symbol `f` cannot be forward-referenced in a statement `s` if a local module,
\import statement, or open statement exists between `s` and the definition of
`f`.

Functions with zero arguments (variable definitions) are not
recursive. For example, in the following `let`, the variable `x` is
not defined recursively but assigned the value of the function argument `x`
increased by `1`. For example, the value of `g 2` is `3`.

```juvix extract-module-statements 1
module non-recursive-functions;
  import Stdlib.Data.Nat open;
  g (x : Nat) : Nat := let x := x + 1 in x;
end;
```

## Anonymous Functions (Lambdas)

Anonymous functions or _lambdas_ can be defined using the following syntax:

### Syntax of `lambda` declarations

```text
--8<-- "docs/reference/language/syntax.md:function-lambda"
```

The initial pipe `|` is optional. You can use either `\` or the Unicode
alternative `λ` to denote an anonymous function.

An anonymous function lists all clauses of a function without naming it. Any
function declaration can be converted to use anonymous functions:

```juvix extract-module-statements 1
module anonymous-functions;
  import Stdlib.Data.Nat open;
  multiplyByTwo : Nat -> Nat := \{n := 2 * n};
end;
```
