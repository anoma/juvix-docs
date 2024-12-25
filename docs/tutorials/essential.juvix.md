---
icon: material/notebook-heart
comments: true
search:
  boost: 2
tags:
  - tutorial
  - beginner
---

```juvix hide
module tutorials.essential;

import Stdlib.Prelude open;
```

# Essential Juvix

![tara-teaching](./../assets/images/tara-teaching.svg){ align=left width="280" }

Welcome to the essential Juvix tutorial! This brief guide will introduce you to
basic Juvix language features and allow you to quickly get up to speed with
programming in Juvix. After working through this tutorial, you should be able to
write simple Juvix programs and have a basic understanding of common patterns
and language concepts. Let's get started on your Juvix journey!

## Juvix REPL

After [installing Juvix](../howto/installing.md), launch the Juvix REPL:

```shell
juvix repl
```

The response should be similar to:

```jrepl
Juvix REPL version 0.6.8: https://juvix.org. Run :help for help
OK loaded: ./.juvix-build/stdlib/Stdlib/Prelude.juvix
Stdlib.Prelude>
```

Currently, the REPL supports evaluating expressions but it does not yet support
adding new definitions. To see the list of available REPL commands type `:help`.

## Basic expressions

You can try evaluating simple arithmetic expressions in the REPL:

```jrepl
Stdlib.Prelude> 3 + 4
7
Stdlib.Prelude> 1 + 3 * 7
22
Stdlib.Prelude> div 35 4
8
Stdlib.Prelude> mod 35 4
3
Stdlib.Prelude> sub 35 4
31
Stdlib.Prelude> sub 4 35
0
```

By default, Juvix operates on non-negative natural numbers. Natural number
subtraction is implemented by the function `sub`. Subtracting a bigger natural
number from a smaller one yields `0`.

You can also try boolean expressions

```jrepl
Stdlib.Prelude> true
true
Stdlib.Prelude> not true
false
Stdlib.Prelude> true && false
false
Stdlib.Prelude> true || false
true
Stdlib.Prelude> if | true := 1 | else := 0
1
```

and strings, pairs and lists:

```jrepl
Stdlib.Prelude> "Hello world!"
"Hello world!"
Stdlib.Prelude> (1, 2)
1, 2
Stdlib.Prelude> [1; 2; 3]
1 :: 2 :: 3 :: nil
```

The parentheses around pairs, as in `(1, 2)`, are in fact optional when no
ambiguity arises. The notation `[a; b; c]` is an abbreviation for `a :: b :: c
:: nil`, where `::` is a list "cons" operator and `nil` (also `[]`) denotes the
empty list.

In fact, you can use all functions and types from the
[Stdlib.Prelude](https://anoma.github.io/juvix-stdlib/Stdlib.Prelude.html)
module of the [standard library](https://anoma.github.io/juvix-stdlib), which is
preloaded by default.

```jrepl
Stdlib.Prelude> length [1; 2]
2
Stdlib.Prelude> isEmpty [1; 2]
false
Stdlib.Prelude> swap (1, 2)
2, 1
```

To see the type of an expression, use the `:type` REPL command:

```jrepl
Stdlib.Prelude> :type 1
Nat
Stdlib.Prelude> :type -1
Int
Stdlib.Prelude> :type true
Bool
Stdlib.Prelude> :type [1; 2; 3]
List Nat
Stdlib.Prelude> :type (1, "A")
Pair Nat String
```

The type `List Nat` is the type of lists whose elements have type `Nat`. The
type `Pair Nat String` is the type of pairs whose first component has type `Nat`
and second component has type `String`.

## Files, modules and compilation

Currently, the REPL does not support adding new definitions. To define new
functions or data types, you need to put them in a separate file and either load
the file in the REPL with `:load file.juvix`, evaluate it with the shell command
`juvix eval file.juvix`, or compile it to a binary executable with `juvix
compile native file.juvix`. To only type-check a file without evaluating it, use
`juvix typecheck file.juvix`.

To conveniently edit Juvix files, an [Emacs mode](./emacs.juvix.md) and a [VSCode
extension](./vscode.html) are available.

A Juvix file must declare a module whose name corresponds exactly to the name of
the file. For example, a file `Hello.juvix` must declare a module `Hello`:

```juvix
module Hello;
  -- Import the standard library prelude, including the 'String' type
  import Stdlib.Prelude open;

  main : String := "Hello world!";
end;
```

A file compiled to an executable must define the zero-argument function `main`
which is evaluated when running the program. The definition of `main` can have
any non-function type, e.g., `String`, `Bool`, `Nat` or `Int`. The generated executable
prints the result of evaluating `main`.

The statement

```juvix extract-module-statements
module ImportPrelude;
import Stdlib.Prelude open;
end;
```

imports the standard library prelude into the current scope.

## Functions

Function definitions in Juvix look like this:

```juvix
add (x y : Nat) : Nat := x + y;
```

In contrast to many other languages, no function definition keyword like `def`
or `fun` is required. Just the name of the function needs to be provided,
followed by its arguments and the result type. The function body is specified
after the assignment symbol (`:=`). The definition needs to be terminated with a
semicolon.

Juvix is a statically typed language, which means that the compiler enforces a
strict typing discipline with type checking done at compilation time. It is
mandatory to specify the types of the function arguments and of the result. When
the arguments have different types, they need to be given in separate
parenthesized argument groups:

```juvix
addOrMul (shouldMul : Bool) (x y : Nat) : Nat :=
  if
    | shouldMul := x * y
    | else := add x y;
```

As you see above, functions are called by listing their space-separated
arguments after the function name: `add x y` calls `add` with two arguments `x`
and `y`. This syntax is different than in mainstream imperative languages, but
common in functional languages like OCaml, Haskell or Lean. In Juvix, the
expression `add (x, y)` is a call to the function `add` with a single argument
`(x, y)` which is a pair of `x` and `y`. Using `add (x, y)` instead of `add x y`
in `addOrMul` would result in a type error.

A "function" can have zero arguments. In this way, definitions of functions and
constants / variables follow the same syntax:

```juvix extract-module-statements
module MyValue;
myValue : Nat := 42;
end;
```

Juvix functions can be parameterized by types, similar to generics in Java,
Rust, and C++. In functional programming terminology, such functions are called
_polymorphic_, functions that work uniformly on all types, without relying on
type-specific implementations. For example, here is a polymorphic identity
function which takes an argument of an arbitrary type `A` and returns it:

```juvix extract-module-statements
module IdPolymorphic;
id {A} (x : A) : A := x;
end;
```

When calling `id`, the right type to be substituted for `A` is inferred
automatically by the type checker when the function is called. For example, in
the call `id 3` the type checker infers that `A` refers to the type `Nat`.

!!! note

    The function `id` already exists in the standard library, so redefining it
    in your file may lead to name clashes.

## Local definitions

Local definitions visible only inside a function body are introduced with the
`let .. in ..` syntax:

```juvix
foo (pair : Pair Nat Nat) : Nat :=
  let
    (x, y) := pair;
    bar : Nat := 42 + y;
    bang (z : Nat) : Nat := z * bar;
  in bang (add x bar);
```

The identifiers `x`, `y`, `bar`, and `bang` are only accessible within the `foo`
function after their declaration. The definitions in a `let`-block follow the
same syntax as top-level definitions. In particular, it is possible to define
local functions, like `bang` above. Type annotations for variables or data
structure patterns are optional and can be omitted and automatically inferred
by the type checker. So for example `bar` can be written as `bar` without
specifying its type.

## Functional programming

Juvix is a purely functional language, which means that functions have no side
effects and all variables are immutable. Once a variable is assigned a value it
cannot be modified - destructive updates are simply absent from the language.
Instead of mutating existing variables or data structures, a common functional
programming pattern is to "update" them by creating new ones.

For example, a polymorphic function that swaps the components of a pair could be
implemented as follows:

```juvix
swap {A B} (pair : Pair A B) : Pair B A :=
  (snd pair, fst pair);
```

Instead of modifying the pair in place, `swap` returns a new pair with the
components swapped. The standard library functions `fst` and `snd` return the
first and second components of a pair, respectively.

Purely functional programming may at first seem exotic to a mainstream
imperative programmer, but once assimilated it offers unique advantages. Purity
guarantees that all functions are _referentially transparent_, meaning that they
always return the same result for the same arguments. This is not the case in
imperative programs, where the result of a function may depend on the implicit
global state or the call may have side effects, which is a common source of
errors. Functional programs are often more succinct, reliable, and easier to
reason about. In particular, [formal
verification](https://ethereum.org/en/developers/docs/smart-contracts/formal-verification/)
is more manageable for functional than for imperative programs.

Functional programming does require a certain shift in the developer's mindset.
Nonetheless, the learning curve of a well-designed user-focused purely
functional language should not be too steep. Juvix aims to deliver on this
promise.

## Records

A statically typed programming language would not be very useful without the
ability to define new data types. Records with named fields of specified types
are among the most common data types. In Juvix, a record type can be defined as
follows.

```juvix
type Resource := mkResource@{
  quantity : Nat;
  price : Nat;
};
```

The above defines a record type `Resource` with two fields `quantity` and
`price`, both of type `Nat`. A record of type `Resource` can be created using
the _record constructor_ `mkResource`:

```juvix
myResource : Resource := mkResource@{
  quantity := 42;
  price := 100;
};
```

The fields of a record can be accessed via their _record projections_
(`Resource.quantity` and `Resource.price` below). For example, the following
function computes the total cost of a resource:

```juvix
totalCost (r : Resource) : Nat :=
  Resource.quantity r * Resource.price r;
```

A record can be "updated" by creating a new record with some fields modified:

```juvix
addQuantity (n : Nat) (r : Resource) : Resource :=
  r@Resource{
    quantity := Resource.quantity r + n;
  };
```

The above is equivalent to:

```juvix extract-module-statements
module addQuantityPrime;
addQuantity (n : Nat) (r : Resource) : Resource :=
  mkResource@{
    quantity := Resource.quantity r + n;
    price := Resource.price r;
  };
end;
```

## Enumerations and inductive types

Enumeration types are defined like this:

```juvix extract-module-statements
module orderingModule;
type Ordering :=
  | LessThan
  | Equal
  | GreaterThan;
end;
```

The above defines a type `Ordering` with three possible values: `LessThan`,
`Equal`, and `GreaterThan`. The values of an enumeration type are its
_constructors_.

Distinguishing between different constructors can be achieved using
`case`-expressions:

```juvix
orderingToInt (ord : Ordering) : Int :=
  case ord of
  | LessThan := -1
  | Equal := 0
  | GreaterThan := 1;
```

Records and enumerations are special cases of _inductive types_ specified by a
number of constructors with arguments. Here is an example of an inductive type
with two constructors:

- `Created` which has one argument of type `Nat`
- `Consumed` which also has one argument of type `Nat`

```juvix extract-module-statements
module Tag0;
type Tag :=
  | Created@{
      commitment : Nat;
    }
  | Consumed@{
      nullifier : Nat;
    };
end;
```

Actually, it is not required to name the arguments of a constructor - their
types can be specified in a space-separated sequence instead. The names are
often omitted when the constructor has only one argument with the argument being
a record and/or the argument name being insignificant.

```juvix
type Commitment := mkCommitment@{
  commitment : Nat;
};
type Nullifier := mkNullifier@{
  nullifier : Nat;
};
type Tag :=
  | Created Commitment
  | Consumed Nullifier;
```

For most types with multiple constructors, it is considered good practice to
wrap constructor arguments into records. This makes type information more
explicit and allows to pass all constructor arguments together to a helper
function.

## Optional values

The polymorphic inductive type `Maybe` from the standard library is commonly
used to represent optional or nullable values in a type-safe manner. It is
analogous to `Option` in Rust, `option` in OCaml or `Maybe` in Haskell.

```juvix extract-module-statements
module myMaybe;
type Maybe A :=
  | nothing
  | just A;
end;
```

Here are two standard library functions commonly used with the `Maybe` type:

```juvix extract-module-statements
module myMaybeFunctions;
isJust {A} (maybeValue : Maybe A) : Bool :=
  case maybeValue of
  | nothing := false
  | just _ := true;

fromMaybe {A} (default : A) (maybeValue : Maybe A) : A :=
  case maybeValue of
  | nothing := default
  | just value := value;
end;
```

In Juvix, all functions must be total, meaning they must return a result for
every possible input. To handle cases where a function might not have a result
for certain inputs, you can use the `Maybe` type. When the result is undefined,
the function can return `nothing`.

```juvix
getCommitment (tag : Tag) : Maybe Commitment :=
  case tag of
  | Created c := just c
  | Consumed _ := nothing;

getCommitmentD (default : Commitment) (tag : Tag) : Commitment :=
  fromMaybe default (getCommitment tag);
```

The function `getCommitmentD` returns its first argument `default` if the `tag`
does not contain a commitment.

## Lists and iteration

In the Juvix standard library, the list type is defined as a polymorphic
inductive type with two constructors:

- `nil` (empty list `[]`) and
- `::` ("cons" - a non-empty list with a head and a tail).

```juvix extract-module-statements
module ListDefinition;
type List A :=
  | nil
  | :: A (List A);
end;
```

Recall that constructor arguments can be specified without naming them by
listing their types after the constructor name, like above for the arguments of
`::`. The first argument of `::` is the _head_ (first list element) and the
second argument is the _tail_ (remaining list elements).

The "cons" constructor `::` can be used in right-associative infix notation,
e.g., `1 :: 2 :: 3 :: nil` is the same as `1 :: (2 :: (3 :: nil))` which is the
same as `(::) 1 ((::) 2 ((::) 3 nil))`. So if `lst` is a list of `Nat`s, then `1
:: lst` is the list with head `1` and tail `lst`, i.e., the first element of `1
:: lst` is `1` and the remaining elements come from `lst`. When specifying all
list elements at once, a move convenient notation `[1; 2; 3]` can be used. So
`[1; 2; 3]` is the same as `1 :: [2; 3]`, `1 :: 2 :: [3]`, `1 :: 2 :: 3 :: []`
and `1 :: 2 :: 3 :: nil`.

Lists are fundamental data structures in functional programming which represent
ordered sequences of elements. Lists are often used where an imperative program
would use arrays, but these are not always directly interchangeable. To use
lists, imperative array-based code needs to be reformulated to process elements
sequentially.

In Juvix, list processing is often performed with the `for` iterator. The
expression

```
for (acc := initialValue) (x in list) {
  BODY
}
```

is evaluated as follows. First, the _accumulator_ `acc` is assigned its initial
value and made available to the body of the `for`-expression. Then each list
element is processed sequentially in the order from left to right (from
beginning to end of list). At each step, `BODY` is evaluated with the current
value of `acc` and the current element `x`. The result of evaluating `BODY`
becomes the new value of `acc`, and the iteration proceeds with the next
element. The final value of the accumulator `acc` becomes the value of the whole
`for`-expression.

For example, here is a function which sums the elements of a list of natural numbers:

```juvix
sum (lst : List Nat) : Nat :=
  for (acc := 0) (x in lst) {
    acc + x
  };
```

First, the accumulator `acc` is initialized to 0. As the list `lst` is
traversed from left to right, each element `x` is added to `acc`, updating its
value. By the end of the iteration, `acc` holds the sum of all elements in the
list.

As another example, consider a function computing the total cost of all
resources priced at more than 100 (recall `Resource` and `totalCost` defined
earlier in this tutorial).

```juvix
totalCostOfValuableResources (lst : List Resource) : Nat :=
  for (acc := 0) (r in lst) {
    if
      | Resource.price r > 100 := acc + totalCost r
      | else := acc
  };
```

The next example demonstrates how to perform iteration with multiple
accumulators. The following function `minmax` computes the minimum and the
maximum values in a list of natural numbers. The functions `min` and `max` are
defined in the standard library.

```juvix
minmax (lst : List Nat) : Pair Nat Nat :=
  for (minAcc, maxAcc := 0, 0) (x in lst) {
    min minAcc x, max maxAcc x
  };
```

You can iterate over multiple lists simultaneously with the help of the `zip`
function, which combines two lists into a list of pairs. For example, `zip [1;
2; 3] [4; 5; 6]` evaluates to `[(1, 4); (2, 5); (3, 6)]`. As an illustration,
here is an implementation of the dot product for two lists of the same length.

```juvix
dotProduct (lst1 lst2 : List Nat) : Nat :=
  for (acc := 0) (x, y in zip lst1 lst2) {
    acc + x * y
  };
```

The dot product is the sum of products of elements at corresponding positions,
e.g.,

```
dotProduct [1; 2; 3] [4; 5; 6]
= 1 * 4 + 2 * 5 + 3 * 6
= 32
```

In contrast, the following function `sumAllProducts` computes the sum of products for all possible pairs of elements from the two lists.

```juvix
sumAllProducts (lst1 lst2 : List Nat) : Nat :=
  for (acc := 0) (x in lst1) {
    for (acc' := acc) (y in lst2) {
      acc' + x * y
    }
  };
```

For example:

```
sumAllProducts [1; 2; 3] [4; 5; 6]
= 1 * 4 + 1 * 5 + 1 * 6 +
  2 * 4 + 2 * 5 + 2 * 6 +
  3 * 4 + 3 * 5 + 3 * 6
= 90
```

The `for` iterator is suitable for sequentially accumulating values from a list.
Often, we want to transform a list into a new list. The `map` and `filter`
iterators are commonly used for this purpose.

The expression

```
map (x in lst) {f x}
```

evaluates to a list obtained from `lst` by replacing each element `x` with `f
x`. For example, the following function increases the prices of all resources by
`n`.

```juvix
increaseAllPrices (n : Nat) (lst : List Resource) : List Resource :=
  map (r in lst) {
    r@Resource{
      price := Resource.price r + n
    }
  };
```

The `filter` iterator picks out elements of a list that satisfy a given
condition. For example, the following function picks resources with price
greater than `price`. The order of the elements is preserved.

```juvix
pickValuable (price : Nat) (lst : List Resource) : List Resource :=
  filter (r in lst) {
    Resource.price r > price
  };
```

Lists do not allow for random access to their elements by index. The Juvix
standard library intentionally does not provide a function to access the nth
element of a list. Such a function could easily be implemented, but it would not
be efficient. Lists are *not* arrays. If you find yourself wanting to access
list elements by numerical index, you are most likely doing something wrong:
trying to incongruently fit imperative array programming patterns into a
functional language instead of using more elegant functional techniques. If you
are used to array-based programming, the shift away from "low-level" index-based
array manipulations in favour of "high-level" list iterators and functions may
be challenging at first. The section [Common techniques](#common-techniques) at
the end of this tutorial collects some methods for solving common programming
tasks in a purely functional manner.

## Pipes

With the pipe `|>` operator, the last argument of a function can be moved to the
front: `z |> f x y` is the same as `f x y z`. This is useful for chaining
function applications which perform some processing steps in sequence: `x |>
doStep1 |> doStep2 |> doStep3 |> doStep4` is the same as `doStep4 (doStep3
(doStep2 (doStep1 x)))`. Such processing pipelines are favored over loops with
complex bodies, as they result in cleaner code, better separation of concerns
across steps, and improved modularity.

For example, recall the function `totalCostOfValuableResources` from the
previous section.

```juvix extract-module-statements
module pipes0;
totalCostOfValuableResources (lst : List Resource) : Nat :=
  for (acc := 0) (r in lst) {
    if
      | Resource.price r > 100 := acc + totalCost r
      | else := acc
  };
end;
```

The body of the `for`-expression is somewhat complex, performing three distinct
operations: checking if the price of `r` exceeds a threshold, computing the
total cost for `r`, and computing the sum. The `for`-expression can be rewritten
into a pipeline, resulting in increased readability and cleaner separation
between the performed operations.

```juvix extract-module-statements
module pipes1;
totalCostOfValuableResources (lst : List Resource) : Nat :=
  let
    isValuable (r : Resource) : Bool := Resource.price r > 100;
  in
  lst |> filter isValuable |> map totalCost |> sum;
end;
```

The iterators `map` and `filter` can be used as functions like above, with the
body becoming the first argument and the list becoming the second argument. So
`map doIt lst` is the same as `map (x in lst) {doIt x}`, and `filter doIt lst`
is the same as `filter (x in lst) {doIt x}`.

Now suppose we would like to modify `totalCostOfValuableResources` to take into
account only resources with quantity greater than 10. In the first version, we
would need to modify the `for`-expression body by inserting an extra check,
which would complicate it even further. In the second version, we just need to
add an extra step to the pipeline. There is no need to modify existing pipeline
steps.

```juvix extract-module-statements
module pipes2;
totalCostOfValuableResources (lst : List Resource) : Nat :=
  let
    isEnough (r : Resource) : Bool := Resource.quantity r > 10;
    isValuable (r : Resource) : Bool := Resource.price r > 100;
  in
  lst |> filter isEnough |> filter isValuable |> map totalCost |> sum;
end;
```

## Sets

Lists represent ordered sequences of elements with possible duplicates. They are
intended for sequential processing and do not support efficient membership
checks. If you need to check for membership, the order is not significant and
duplicates not allowed, then a `Set` is an appropriate data structure.

Sets are not in the standard library prelude, so you need to import them
separately.

```juvix
import Stdlib.Data.Set as Set open using {Set};
```

The above statement makes set functions available qualified with `Set.` and the
`Set` type available unqualified.

The following functions are available for sets.

- `Set.empty` is the empty set.
- `Set.isMember elem set` evaluates to `true` iff `elem` is in `set`.
- `Set.insert elem set` inserts `elem` into `set`, returning the updated set.
- `Set.delete elem set` removes `elem` from `set`.

As an example, here is a function which removes duplicates from a list,
preserving element order and keeping the first occurrence of each value.

```juvix
removeDuplicates (lst : List Nat) : List Nat :=
  for (acc, seen := [], Set.empty) (x in lst) {
    if
      | Set.isMember x seen := acc, seen
      | else := x :: acc, Set.insert x seen
  }
  |> fst
  |> reverse;
```

The function uses an auxiliary set `seen` to check if an element was already
encountered. The result of the `for` iteration is a pair of `(acc, seen)`, so to
get the result list we need to extract the first component `acc` with `fst`.
Since the `for` iterator goes through the list from beginning to end, the order
of the accumulated result list is reversed. The standard library function
`reverse`, as its name indicates, reverses the result list back to the original
order.

## Maps

A *map* is a data structure that represents associations from keys to values. Each
key can be associated with only one value.

In Juvix, maps are of type `Map`, however the `Map` type is not in the standard
library prelude, so it needs to be imported with the following statement:

```juvix
import Stdlib.Data.Map as Map open using {Map};
```

The following functions are supported for maps.

- `Map.empty` is the empty map.

- `Map.lookup key map` evaluates to `just value` if `key` is associated with
`value` in `map`, or to `nothing` if `key` has no association in `map`.

- `Map.insert key value map` associates `key` with `value` in `map`, overriding
any previous association if present.

- `Map.delete key map` removes the association for `key` from the `map`.

- `Map.keys map` returns the list of keys present in `map`.

- `Map.values map` returns the list of values associated with some key in `map`.

As an example of `Map` usage, consider the following function which groups
resources by their price and adds up the quantities to create one resource for
each price. The order of elements in the result list is not preserved.

```juvix
groupResourcesByPrice (lst : List Resource) : List Resource :=
  for (acc := Map.empty) (r in lst) {
    let p := Resource.price r
    in
    case Map.lookup p acc of
    | nothing := Map.insert p r acc
    | just r' := Map.insert p (addQuantity (Resource.quantity r) r') acc
  }
  |> Map.values;
```

In fact, `groupResourcesByPrice` could be written more succinctly using
`Map.insertWith`, which does not replace the value when the key is already
present, but instead combines the new and the old values using a provided
function.

```juvix extract-module-statements
module map1;
groupResourcesByPrice (lst : List Resource) : List Resource :=
  let
     combineResources (r1 r2 : Resource) : Resource :=
       addQuantity (Resource.quantity r1) r2;
  in
  for (acc := Map.empty) (r in lst) {
    Map.insertWith combineResources (Resource.price r) r acc
  }
  |> Map.values;
end;
```


In Juvix, traits provide a way to define shared behaviour for types, similarly
to traits in Rust, type classes in Haskell, and interfaces in Java. A trait
specifies a set of functions that must be implemented in an instance for a given
type. Traits allow you to write generic, reusable code by specifying constraints on
types without committing to a specific implementation.

For example, the `Eq` trait from the standard library specifies the equality
function `Eq.eq`.

```juvix extract-module-statements
module EqTrait;
trait
type Eq A :=
  mkEq@{
    eq (x y : A) : Bool;
  };
end;
```

An instance of `Eq` for a given type can be defined by implementing `Eq.eq` for
this type. Here is an `Eq` instance definition for the `Resource` type.

```juvix
instance
eqResourceI : Eq Resource :=
  mkEq@{
    eq (r1 r2 : Resource) : Bool :=
      Resource.quantity r1 == Resource.quantity r2 &&
      Resource.price r1 == Resource.price r2;
  };
```

A polymorphic function that needs an equality operation for its type parameter
can be defined generically by requiring an instance of the `Eq` trait, rather
than relying on a specific equality implementation. Then, the function can be
used with any type for which an instance of `Eq` is available. The appropriate
instance is chosen at compilation time based on the type. The corresponding
concrete equality implementation from the instance is then used.

As a trivial example, the standard library actually defines the infix equality
operator `==` in terms of the `Eq` trait.

```juvix extract-module-statements
module traits1;
== {A} {{Eq A}} (x y : A) : Bool := Eq.eq x y;
end;
```

The implicit instance argument `{{Eq A}}` specifies that wherever the function
`==` is called, an instance of `Eq` is required for the type parameter `A`. The
specific instance is automatically inferred by the type checker, separately for
each function call.

Because we have defined an instance of `Eq` for `Resource`, we can now use `==`
with resources. The type checker automatically choses `eqResourceI` as the
required instance and uses the corresponding equality implementation.

```juvix
countResource (resource : Resource) (lst : List Resource) : Nat :=
  for (acc := 0) (r in lst) {
    if
      | resource == r := acc + 1
      | else := acc
  };
```

The above function does not depend on the details of the `Resource` type. It
only requires that equality be available for the list elements. Hence, the
function can be generalized to use the `Eq` trait.

```juvix
countValue {A} {{Eq A}} (value : A) (lst : List A) : Nat :=
  for (acc := 0) (x in lst) {
    if
      | value == x := acc + 1
      | else := acc
  };
```

To use the polymorphic equality operator `==`, a type must have an instance of
the `Eq` trait. It is quite tedious to manually implement instances of `Eq` for
each user-defined type. Fortunately, an `Eq` instance may be derived
automatically if `Eq` instances already exist for the types of all record fields
or constructor arguments.

```
deriving instance
eqResourceI : Eq Resource;
```

## Debugging

Juvix does not currently have a debugger. A common way of debugging Juvix
programs is to make use of the REPL. Once you load your file into the REPL (with
`juvix repl file.juvix`, or via Emacs or VSCode), you can evaluate any function
from the file with the desired arguments and inspect the result.

Another technique is to use the `trace` function which prints its argument and
returns it.

```juvix
import Stdlib.Debug.Trace open;

combineResources (r1 r2 : Resource) : Resource :=
  trace r1 >-> trace r2 >->
  r1@Resource{
    quantity := Resource.quantity r1 + Resource.quantity r2
  };
```

The function `combineResources` first prints `r1`, then prints `r2`, then
returns updated `r1`. The sequencing operator `>->` first evaluates the
expression on the left, ignores the result, then evaluates the expression on the
right and returns it. The import above the function is necessary, because
`trace` is not in the standard library prelude.

The `failwith` function may also be useful to immediately crash with an error
message.

```juvix
import Stdlib.Debug.Fail open;

giveAllAway (lst : List Resource) : List Resource :=
  let lst' :=
    map (r in lst) {
      r@Resource{price := 0}
    };
  in
  if
    | length lst /= length lst' := failwith "Oops, something went very wrong with the mapping."
    | else := trace "Hurray!" >-> lst';
```

Finally, `assert` allows you to specify assumptions at different points in the program.

```juvix
dividePrice (n : Nat) (r : Resource) : Resource :=
  assert (n > 0) >->
  r@Resource{
    price := div (Resource.price r) n
  };
```

## Common techniques

This section lists some common programming tasks and explains how to solve them
in a purely functional manner.

### Accumulate list elements from left to right

  - Solution: use `for`.

  - Example:

    ```juvix extract-module-statements
    module ForExample;
    reverse {A} (lst : List A) : List A :=
      for (acc := []) (x in lst) {
        x :: acc
      };
    end;
    ```

### Accumulate list elements from right to left

  - Solution: use `rfor`.

  - Example:

  ```juvix
  duplicate (lst : List Nat) : List Nat :=
    rfor (acc := []) (x in lst) {
      x :: x :: acc
    };
  ```

### Check if a list is empty

  - Solution: use `isEmpty`

  - Anti-pattern: do _not_ use `length lst == 0`

  The `length` function requires computation time proportional to the length of
  its argument - it needs to traverse the entire list to compute the length. The
  `isEmpty` function runs in constant time.

### Check if a condition holds for all list elements

  - Solution: use `all`.

  - Example:

  ```juvix
  allDivisible (n : Nat) (lst : List Nat) : Bool :=
    all (x in lst) {
      mod x n == 0
    };
  ```

### Check if a condition holds for any list element

  - Solution: use `any`.

  - Example:

  ```juvix
  anyDivisible (n : Nat) (lst : List Nat) : Bool :=
    any (x in lst) {
      mod x n == 0
    };
  ```

### Keep a state when accumulating list elements

  - Solution: use an extra accumulator.

  - Example:

  ```juvix
  listToMap {A} {{Ord A}} (lst : List A) : Map Nat A :=
    for (acc, i := [], 0) (x in lst) {
      (i, x) :: acc, i + 1
    }
    |> fst
    |> Map.fromList;
  ```

### Replicate an element into a list

  - Solution: use `replicate`. The call `replicate n a` evaluates to
  `[a; a; ..; a]` with `a` repeated `n` times.

### Concatenate two lists

  - Solution: use `++`.

  - Warning: `lst1 ++ lst2` takes time proportional to the length of `lst1`.
  When used inside a loop, care must be taken to avoid excessive running time.

  - Example:

  ```juvix extract-module-statements
  module myFlatten1;
  flatten {A} (listOfLists : List (List A)) : List A :=
    rfor (acc := []) (lst in listOfLists) {
      lst ++ acc
    };
  end;
  ```

  In each step, `++` takes time proportional to the length of `lst`, so the
  total running time of `flatten` is proportional to the length of the result.

  - Anti-example:

  ```juvix
  flattenWRONG {A} (listOfLists : List (List A)) : List A :=
    for (acc := []) (lst in listOfLists) {
      acc ++ lst
    };
  ```

  In each step, `++` takes time proportional to the current length of `acc`,
  which gets longer with every step. The total running time of `flattenWRONG` is
  proportional to the square of the length of the result.


### Add an element at the back of a list


- Solution: don't do it. Lists are designed to allow adding elements efficiently
only at the front. You should _never_ accumulate list elements by adding them at
the back. Change the direction of your iteration (from `for` to `rfor` or vice
versa) or use `reverse`.

- If you _really_ need to do it: use `lst ++ [x]`, but be aware of the
inefficiency. The only legitimate use-cases are when the length of `lst` is a
known constant, or when used carefully like list concatenation.

- Legitimate use-case examples:

  - Key with 32 bytes:

  ```juvix
  key32Bytes : List Nat :=
    replicate 31 0x0 ++ [0x1];
  ```

  - Flatten a list of lists with a separator:

  ```juvix
  flattenWithSeparator {A} (sep : A) (listOfLists : List (List A)) : List A :=
    rfor (acc := []) (lst in listOfLists) {
      lst ++ [sep] ++ acc
    };
  ```

  - Anti-example:

  ```juvix
  tagsToPairWRONG (tags : List Tag) : Pair (List Nullifier) (List Commitment) :=
    for (nfs, cms := [], []) (tag in tags) {
      case tag of
        | Consumed nf := nfs ++ [nf], cms
        | Created cm := nfs, cms ++ [cm]
    };
  ```

  - Correction:

  ```juvix
  tagsToPair (tags : List Tag) : Pair (List Nullifier) (List Commitment) :=
    rfor (nfs, cms := [], []) (tag in tags) {
      case tag of
        | Consumed nf := nf :: nfs, cms
        | Created cm := nfs, cm :: cms
    };
  ```

### Iterate over a range of numbers

  - Solution: use `a to b` or `a to b step k`.

  - Examples:

    - List of numbers up to `n`:

    ```juvix
    listUpTo (n : Nat) : List Nat :=
      rfor (acc := []) (x in 1 to n) {
        x :: acc
      };
    ```

    - Divisors of a number:

    ```juvix
    divisors (n : Nat) : List Nat :=
      if
      | n == 0 := []
      | else :=
        rfor (acc := []) (x in 1 to n) {
          if
            | mod n x == 0 := x :: acc
            | else := acc
        };
    ```

    - Sum of even numbers up to `n`:

    ```juvix
    sumEvenUpTo (n : Nat) : Nat :=
      for (acc := 0) (x in 2 to n step 2) {
        acc + x
      };
    ```

### Repeat n times

  - Solution: use `iterate`.

  - Example:

  ```juvix
  random (seed : Nat) : Nat :=
    mod (1103515245 * seed + 12345) 2147483648;

  randoms (n initialSeed : Nat) : Pair Nat (List Nat) :=
    let
      update (acc : Pair Nat (List Nat)) : Pair Nat (List Nat) :=
        let seed := random (fst acc)
        in
        seed, seed :: snd acc
    in
    iterate n update (initialSeed, []);
  ```
