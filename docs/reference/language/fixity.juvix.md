---
icon: material/application-parentheses
comments: false
search:
  boost: 3
---

```juvix hide
module reference.language.fixity;
```

# Fixities

Fixities in Juvix refer to the precedence and associativity of operators. A
fixity declaration is defined using the `syntax` keyword followed by `fixity`.
It specifies how an operator should be parsed in relation to other operators.

## Syntax of Fixity Declaration

The syntax for a fixity declaration varies based on the operator's arity,
associativity, and precedence.

### Arity Declaration

For an operator with no specified precedence or associativity, the arity can be
declared as follows:

```text
--8<------ "docs/reference/language/syntax.md:fixity-arity-syntax"
```

In this syntax,

- `<name>` represents the operator name, and
- `<arity>` can either be `none`, `unary`, or `binary`.

This declaration is equivalent to:

```text
syntax fixity <name> := <arity> {};
```

### Associativity Declaration

For an operator with no specified precedence, its associativity can be declared
as:

```text
syntax fixity <name> := <arity> { assoc := <associativity> };
```

Here, `<associativity>` can either be `left`, `right`, or `none`.

### Precedence Declaration

For an operator with no specified associativity, its precedence can be declared
relative to other operators.

- If it has equal precedence to another operator:

  ```text
  syntax fixity <name> := <arity> { same := otherOperatorName };
  ```

- If it has higher precedence than other operators:

  ```text
  syntax fixity <name> := <arity> {
      above := [otherOperatorName1;...; otherOperatorNameN] };
  ```

- If it has lower precedence than other operators:

  ```text
  syntax fixity <name> := <arity> {
      below := [otherOperatorName1;...; otherOperatorNameN] };
  ```

### Associativity and Precedence Declaration

For an operator with both associativity and precedence:

```text
syntax fixity <name> := <arity> {
    assoc := <associativity>;
    above := [otherOperatorName1;...; otherOperatorNameN]
    };
```

## Operator Alias Fixity

In Juvix, when an operator is aliased, the new alias automatically inherits the
fixity of the original operator. This behavior ensures consistency and
predictability when using aliases in place of their corresponding operators.

Consider a scenario where the `or` operator is an alias of the `||` operator.
The `or` operator will inherit the fixity of the `||` operator by default.

```juvix hide
import reference.language.aliases open;
```

```juvix extract-module-statements
module fixityInherit;
  syntax alias or := ||;
  newor (a b c : Bool) : Bool := (a or b) or c;
end;
```

However, if you want to override this behavior, you can declare the alias with
`none` as its fixity. Make sure to import `Stdlib.Data.Fixity`.

```juvix extract-module-statements
module fixityNone;
  import Stdlib.Data.Fixity open;
  syntax operator or none;
  syntax alias or := ||;
  or3 (a b c : Bool) : Bool := or (or a b) c;
end;
```

## Examples of Fixity Declarations

Here are some examples of common fixity declarations for operators in Juvix's
standard library.

```juvix extract-module-statements
module examples-from-stdlib;
syntax fixity rapp := binary {assoc := right};
syntax fixity lapp := binary {assoc := left; same := rapp};
syntax fixity seq := binary {assoc := left; above := [lapp]};

syntax fixity functor := binary {assoc := right};

syntax fixity logical := binary {assoc := right; above := [seq]};
syntax fixity comparison := binary {assoc := none; above := [logical]};

syntax fixity pair := binary {assoc := right};
syntax fixity cons := binary {assoc := right; above := [pair]};

syntax fixity step := binary {assoc := right};
syntax fixity range := binary {assoc := right; above := [step]};

syntax fixity additive := binary {assoc := left; above := [comparison; range; cons]};
syntax fixity multiplicative := binary {assoc := left; above := [additive]};

syntax fixity composition := binary {assoc := right; above := [multiplicative]};
end;
```
