---
icon: material/application-parentheses
comments: true
---

# Operator Fixity

A fixity declaration, introduced by the `syntax` keyword followed by `fixity`, defines an operator's precedence and associativity. The syntax varies based on the operator's arity, associativity, and precedence.

- Arity declaration of an operator with no precedence or associativity:

```juvix
syntax fixitiy <operatorName> := <arity>;
```
Where `<arity>` is either `unary` or `binary`.

This is equivalent to:

```juvix
syntax fixitiy <operatorName> := <arity> {};
```

- Associativity declaration of an operator with no precedence:

```juvix
syntax fixitiy <operator> := <arity> { assoc := <associativity> };
```
Where `<associativity>` is either `left`, `right`, or `none`.

- Precedence declaration of an operator with no associativity:

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

- Associativity and precedence declaration of an operator:

```juvix
syntax fixitiy <operatorName> := <arity> { 
    assoc := <associativity>; 
    above := [otherOperatorName1;...; otherOperatorNameN] };
```


## Examples

Below are examples of these forms:

```juvix
--8<------ "docs/reference/language/fixity.juvix:product"
```

```juvix
--8<------ "docs/reference/language/fixity.juvix:composition"
```