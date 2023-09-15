---
icon: material/application-parentheses
comments: true
---

# Operator Fixity

Fixity declarations define the precedence and associativity of operators. They can be declared before the operator is defined, using one of the following forms:

- Arity declaration:

```juvix
syntax fixitiy <operatorName> := <arity>;
```
Where `<arity>` is either `unary` or `binary`.

This is equivalent to:

```juvix
syntax fixitiy <operatorName> := <arity> {};
```

- Associativity declaration for a given arity:

```juvix
syntax fixitiy <operator> := <arity> { assoc := <associativity> };
```
Where `<associativity>` is either `left`, `right`, or `none`.

- Precedence declaration:

    - Equal precedence to another operator:

    ```juvix
    syntax fixitiy <operatorName> := <arity> { same := otherOperatorName };
    ```

    - Higher precedence than other operators:

    ```juvix
    syntax fixitiy <operatorName> := <arity> { 
        above := [otherOperatorName1;...; otherOperatorNameN] };
    ```

    - Lower precedence than other operators:

    ```juvix
    syntax fixitiy <operatorName> := <arity> { 
        below := [otherOperatorName1;...; otherOperatorNameN] };
    ```

Below are examples of these forms:

```juvix
--8<------ "docs/reference/language/fixity.juvix:product"
```

```juvix
--8<------ "docs/reference/language/fixity.juvix:composition"
```