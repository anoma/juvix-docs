---
icon: material/application-parentheses
comments: false
search:
  boost: 3
---

# Fixities

Fixities in Juvix refers to the precedence and associativity of operators. A
fixity declaration is defined using the `syntax` keyword followed by `fixity`.
It specifies how an operator should be parsed in relation to other operators.

## Syntax of Fixity Declaration

The syntax for a fixity declaration varies based on the operator's arity,
associativity, and precedence.

### Arity Declaration

For an operator with no specified precedence or associativity, the arity can be
declared as follows:

```juvix
--8<------ "docs/reference/language/syntax.md:fixity-arity-syntax"
```

In this syntax,

- `<name>` represents the operator name, and
- `<arity>` can either be `none`, `unary`, or `binary`.

This declaration is equivalent to:

```juvix
syntax fixity <name> := <arity> {};
```

### Associativity Declaration

For an operator with no specified precedence, its associativity can be declared
as:

```juvix
syntax fixity <name> := <arity> { assoc := <associativity> };
```

Here, `<associativity>` can either be `left`, `right`, or `none`.

### Precedence Declaration

For an operator with no specified associativity, its precedence can be declared
relative to other operators.

- If it has equal precedence to another operator:

  ```juvix
  syntax fixity <name> := <arity> { same := otherOperatorName };
  ```

- If it has higher precedence than other operators:

  ```juvix
  syntax fixity <name> := <arity> {
      above := [otherOperatorName1;...; otherOperatorNameN] };
  ```

- If it has lower precedence than other operators:

  ```juvix
  syntax fixity <name> := <arity> {
      below := [otherOperatorName1;...; otherOperatorNameN] };
  ```

### Associativity and Precedence Declaration

For an operator with both associativity and precedence:

```juvix
syntax fixity <name> := <arity> {
    assoc := <associativity>;
    above := [otherOperatorName1;...; otherOperatorNameN]
    };
```

# Operator Alias Fixity

In Juvix, when an operator is aliased, the new alias automatically inherits the
fixity of the original operator. This behavior ensures consistency and
predictability when using aliases in place of their corresponding operators.

Consider a scenario where the `or` operator is an alias of the `||` operator.
The `or` operator will inherit the fixity of the `||` operator by default.

```juvix
--8<------ "docs/reference/language/aliases.juvix:or-inherit"
```

However, if you want to override this behavior, you can declare the alias with
`none` as its fixity.

```juvix
--8<------ "docs/reference/language/aliases.juvix:or-fixity-none"
```

## Examples of Fixity Declarations

Here are some examples of common fixity declarations for operators in Juvix's
standard library.

```juvix
--8<------ "docs/reference/language/fixity.juvix:stdlib"
```
