# Module

```text
--8<-- [start:module-syntax]
module <name>;
  <body>
end;
--8<-- [end:module-syntax]
```
# Alias

```text
--8<-- [start:alias-syntax]
syntax alias <newName> := <originalName>;
--8<-- [end:alias-syntax]
```

# Fixity

```text
--8<-- [start:fixity-arity-syntax]
syntax fixity <name> := <arity>;
--8<-- [end:fixity-arity-syntax]
```

# Axiom

```text
--8<-- [start:axiom-syntax]
axiom <name> : <type>;
--8<-- [end:axiom-syntax]
```

# Function

```text
--8<-- [start:function-syntax]
<funName> : <argType> -> <returnType> := <body>;
--8<-- [end:function-syntax]
```

```text
--8<-- [start:function-named-arguments]
<funName> (<argName> : <argType>) : <returnType> := <body>;
--8<-- [end:function-named-arguments]
```

```text
--8<-- [start:function-pattern-matching]
<funName> : <argType> -> <returnType>
    | <pat1> := <body1>
    | ...
    | <patN> := <bodyN>;
--8<-- [end:function-pattern-matching]
```

It may have multiple patterns:

```
--8<-- [start:function-pattern-matching-multiple-arguments]
<funName> : <argType1> -> <argType2> -> <returnType>
    | <pat-1-1> <pat-1-2> := <body1>
    | ...
    | <pat-n-1> <pat-n-2> := <bodyN>;
--8<-- [end:function-pattern-matching-multiple-arguments]
```

Lambdas

```
--8<-- [start:function-lambda]
\{ | pat1 .. patN_1 := clause1
   | ..
   | pat1 .. patN_M := clauseM }
--8<-- [end:function-lambda]
```

## Data Types

```text
--8<-- [start:datatype-syntax]
type <name> <type-parameters> :=
    | <constructor1> : <type1>
    | ...
    | <constructorn> : <typen>;
--8<-- [end:datatype-syntax]
```

## Traits and Records

```text
[trait]
--8<-- [start:record-syntax]
type <record name> <type parameters> :=
    | <type-constructor-1>@{
        <field1-1> : <type-1-1>;
        ...
        <field1-n> : <type-1-n>
        }
    | ...
    | <type-constructor-n>@{
        <fieldn-1> : <type-n-1>;
        ...
        <fieldn-n> : <type-n-n>
    };
--8<-- [end:record-syntax]
```

Instances:

```text
--8<-- [start:instance-syntax]
instance
<term> : <trait> := <trait constructor>@{
    field1 := <term1>;
    ...
    fieldn := <termn>;
};
--8<-- [end:instance-syntax]
```


## Let

```text
--8<-- [start:let-syntax]
let <name> : <type> := <term>;
in <body>
--8<-- [end:let-syntax]
```

## Iterator

```text
--8<-- [start:iterator-syntax-simple]
syntax iterator <name>;
--8<-- [end:iterator-syntax-simple]
```

```text
--8<-- [start:iterator-syntax-simple-with-arguments]
syntax iterator <name> {init := <initVal>;  range := <ranges>};
--8<-- [end:iterator-syntax-simple-with-arguments]
```

```text
--8<-- [start:iterator-application-syntax]
iter (acc1 := a1; ..; accn := an) (x1 in xs1; ..; xk in xsk) {body}
--8<-- [end:iterator-application-syntax]
```

## Pragmas

```text
--8<-- [start:pragma-id-syntax]
{-# pragma_name: pragma_value #-}
identifier : Type;
--8<-- [end:pragma-id-syntax]
```

## Control

### Case

```text
--8<-- [start:case-syntax]
case <expression> of {
  | <pattern1> := <branch1>
  ..
  | <patternN> := <branchN>
}
--8<-- [end:case-syntax]
```

### If

```text
--8<-- [start:if-syntax]
if
  | <expression-1> := <branch-1>
  ..
  | <expression-n> := <branch-n>
  | else := <branch-else>
--8<-- [end:if-syntax]
```
