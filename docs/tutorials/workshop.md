---
icon: material/notebook-heart
comments: true
---

# Juvix Workshop ZKSummit10 version

![tara-teaching](./../assets/images/tara-teaching.svg){ align=left width="280" }

## Introduction

In this part of the workshop, we will walk you through the process of installing Juvix, writing a simple program, and executing it. We will also introduce you to the command-line interface (CLI) and how to evaluate Juvix expressions.

### Step 1: Install Juvix Compiler

The first step is to obtain a copy of the Juvix compiler. We have several installations listed here. Choose the one that suits you best.

For convenience, we will use the Juvix extension in Visual Studio Code which will install Juvix for us.

### Step 2: Clone the Repository

First, clone the following repository:

```shell
git clone https://github.com/anoma/juvix-workshop
```

Next, open the cloned repository in Visual Studio Code.

### Step 3: Install the Juvix Extension

In the extension tab, search for "juvix" and install the extension that features the Tara logo.

### Step 4: Open HelloWorld.juvix File

Open the `HelloWorld.juvix` file. You should get a prompt to install Juvix - click on the prompt and wait for Juvix to install. After reloading the page, full semantic highlighting should appear in the Juvix file.

Here's a quick rundown of what you'll see in the file:

- The `module` declaration opens a file, it must have the same name as the file.
- We import the Juvix standard library; the `open` keyword at the end means that all the symbols in the imported module are added to the scope of the module unqualified.
- There is a function called `main`, which serves as the entry point to the program. It has type `IO`. The line below defines the body of the function. In this case, it simply calls the `printStringLn` function from the standard library with a single string argument.

You can see the type of symbols in the code by hovering over them and navigate to the definitions of symbols in the code by CMD+clicking on them. You can also open a REPL session from within the editor itself.

### Step 5: Use the CLI

The Juvix compiler can also be driven from the command line. Let's see that in action.

In the clone of the repository we made before, change directory to the `hello-world` project and compile the `HelloWorld.juvix` source file.

```shell
cd juvix-workshop
cd hello-world
juvix compile HelloWorld.juvix
./HelloWorld
```

Juvix also has a read-eval-print-loop (REPL) program that can be used to evaluate Juvix expressions. We invoke this by running `juvix repl` in the terminal.

```shell
juvix repl
```

Let's evaluate some Juvix expressions to try it out.

```
1 + 1
printStringLn "Hello"
```

We'll explore more examples in the REPL later. Stay tuned!

## Juvix Programming and Basic Concepts

In this tutorial, we will introduce you to the basic concepts of Juvix programming language. We'll cover functions, types, pattern matching, recursion, polymorphism, and iterators.

### Step 1: Create a New File

Let's start by creating a new file named `Example.juvix`. Import and open the standard library. Also, initiate a REPL (Read-Eval-Print Loop) session for this file. The REPL will provide feedback from the compiler as we write the program.

### Step 2: Functions in Juvix

Juvix is a functional language, which means we can define functions. Unlike languages like Python that use a `def` keyword to define functions, Juvix doesn't require a keyword.

Here's how to define a function:

```juvix
add1 (n : Nat) : Nat;
```

If you see an error in the REPL, it's because we're missing a function clause. The symbol `:=` separates the arguments from the body of the clause.

```juvix
add1 (n : Nat) : Nat := n + 1;
```

You can evaluate this function in the REPL. In Juvix, we apply a function to its arguments by writing the function next to its arguments, without parentheses.

Let's define another function, `maximum`, which takes two arguments:

```juvix
maximum (n : Nat) (k : Nat) : Nat := if (n < k) k n;
```

Note that calling the function with an argument of the wrong type will result in a type error:

```juvix
maximum 1 true
```

In Juvix, all functions expect precisely one argument. A function that appears to take two arguments actually takes a single argument and returns a new function.

```juvix
maximum3 : Nat -> Nat := maximum 3;
```

### Step 3: Types in Juvix

Juvix is a typed functional language, allowing you to define types. We've already seen some types like `Nat`, `Int`, and `Bool` that are defined in the standard library.

You can inspect their definition by using `:def` in the REPL:

```juvix
:def Bool
```

Or navigate to their definition using CMD+click.

Every type is defined by a number of constructors. For `Bool`, there are two constructors `true` and `false`. Constructors in Juvix simply gather the data of the type together.

For instance, let's look at the type `Nat`, which represents non-negative integers. The `zero` constructor represents 0, while the `suc` constructor takes one argument and represents the successor of some other number. This is a recursive datatype because the `suc` constructor takes another `Nat`.

```juvix
suc (suc (suc zero))
```

### Step 4: Pattern Matching

We can define functions by pattern matching on the constructors of a type:

```juvix
isZero : Nat -> Bool
 | zero := true;
 | (suc k) := false;
```

### Step 5: Recursive Functions

Recursive types are useful when defining recursive functions. Consider the function `even`:

```juvix
even : Nat -> Bool
  | zero := true;
  | (suc k) := not (even k);
```

Juvix will check that recursive functions will eventually terminate.

```juvix
even : Nat -> Bool
  | zero := true;
  | (suc k) := not (even (suc k));
```

### Step 6: Polymorphism

Types in Juvix can take arguments, leading to polymorphic types like `List Nat`, `List String`, and `List (List Bool)`.

Let's examine the definition of `List`:

```juvix
:def List
[1]
```

We can define polymorphic functions by defining a function that takes a type as an argument:

```juvix
length' {A} : List A -> Nat
  |  nil := 0;
  | (x :: xs) := suc (length' xs);
```

The type argument can be determined from the other arguments. So Juvix allows you to omit the type arguments by marking them as implicit by wrapping them in curly braces.

### Step 7: Iterators

Finally, let's look at iterator syntax in Juvix. This allows us to write folds from functional programming in a more readable and imperative style.

```juvix
sum (xs : List Nat) : Nat := for (acc := 0) (x in xs) x + acc;
```

In this code, we're iterating over a list. Before the iteration begins, `acc` is set to `0`. The list is then traversed from beginning to end, and at each step, `acc` is updated with the value of the body `x + acc`.

There are also iterator syntaxes for `map` where we apply a function to each element.

```juvix
mult2  (xs : List Nat) : List Nat := map (x in xs) x * 2;
```

And filters

```juvix
filterLarge (xs : List Nat) : List Nat := filter (x in xs) x < 10;
```

You can find more examples of iterators in the standard library, and it's possible to define your own.

#### Step 8: Exercises

The exercises for this section are in [https://github.com/anoma/juvix-workshop/blob/main/exercises/Exercises.juvix](https://github.com/anoma/juvix-workshop/blob/main/exercises/Exercises.juvix). You will find the following content, and your task
is to replace the `add-solution-here` with your solution.

=== "Exercises.juvix"

    ```juvix
    -- See https://docs.juvix.org/dev/tutorials/learn/#exercises for more exercises
    module Exercises;

    import Stdlib.Prelude open;

    import Stdlib.Data.Nat.Ord;
    import Stdlib.Data.Int.Ord as Int;

    -- Delete this function when you have completed the exercises
    axiom add-solution-here : {A : Type} -> A;

    --- Write a function that computes the exponentation n^m
    exp : Nat -> Nat -> Nat := add-solution-here;

    --- Write a function that returns the last element in a list
    last {A} : List A -> Maybe A := add-solution-here;

    --- Write a function that reverses a list
    rev {A} : List A -> List A := add-solution-here;

    --- Write a function that computes the maximum element in a list of natural numbers
    maximum : List Nat -> Nat := add-solution-here;

    --- Write a function that computes the list of partial sums of a list of natural numbers
    sums : List Nat -> List Nat := add-solution-here;

    --- Write a function that return the first element in a list that satisfies a predicate
    findFirst {A} : (A -> Bool) -> List A -> Maybe A :=
    add-solution-here;

    --- Write a function that returns the longest initial sublist of elements that satisfy a predicate
    takeWhile {A} : (A -> Bool) -> List A -> List A :=
    add-solution-here;

    --- Write a function which computes the length of a longest continuous sublist of elements satisfying a predicate
    longest {A} : (A -> Bool) -> List A -> Nat :=
    add-solution-here;

    type Tree (A : Type) :=
    | leaf A
    | node (Tree A) (Tree A);

    --- Write a function that counts the total number of leaves in a tree
    countLeaves {A} : Tree A -> Nat := add-solution-here;

    --- Write a function which checks if a ;Tree; is balanced.
    --- A ;Tree; is balanced if the number of leaves in the left and right subtree of every
    --- node differ by at most 1.
    isBalanced {A} : Tree A -> Bool := add-solution-here;
    ```

=== "Solutions.juvix"

    ```juvix
    module Solutions;

    import Stdlib.Prelude open public;
    import Stdlib.Data.Nat.Ord open public;

    import Stdlib.Data.Int.Ord as Int;

    --- Write a function that computes the exponentation n^m
    exp (x : Nat) : Nat -> Nat
    | zero := 1
    | (suc n) := x * exp x n;

    --- Write a function that checks if a ;Nat; is prime
    isPrime (n : Nat) : Bool :=
    let
        go : Nat -> Bool
        | zero := true
        | (suc zero) := true
        | k@(suc k') := if (mod n k == 0) false (go k');
    in case n of {
        | zero := false
        | suc zero := false
        | suc k := go k
    };

    --- Write a function that returns the last element in a list
    last {A} : List A -> Maybe A
    | nil := nothing
    | (x :: nil) := just x
    | (_ :: xs) := last xs;

    --- Write a function that reverses a list
    rev {A : Type} (xs : List A) : List A :=
    for (acc := nil) (x in xs)
        x :: acc;

    --- Write a function that computes the maximum element in a list of natural numbers
    maximum (xs : List Nat) : Nat :=
    for (acc := 0) (x in xs)
        if (x > acc) x acc;

    --- Write a function that computes the list of partial sums of a list of natural numbers
    sums (xs : List Nat) : List Nat :=
    reverse
        $ fst
        $ for (acc, s := nil, 0) (x in xs)
            x + s :: acc, x + s;

    --- Write a function that computes the first element in a list that satisfies a predicate
    findFirst {A} (p : A -> Bool) : List A -> Maybe A
    | nil := nothing
    | (x :: xs) := if (p x) (just x) (findFirst p xs);

    --- Write a function that returns the longest initial sublist of elements that satisfy a predicate
    takeWhile {A} (p : A -> Bool) : List A -> List A
    | nil := nil
    | (x :: xs) := if (p x) (x :: takeWhile p xs) nil;

    --- Write a function which computes the length of a longest continuous sublist of elements satisfying a predicate
    longest {A : Type} (p : A -> Bool) (xs : List A) : Nat :=
    -- `len` is the length of the longest sublist found so far
    -- `len'` is the length of the longest sublist ending at the current element
    case for (len, len' := 0, 0) (x in xs)
            if (p x)
                (len, len' + 1)
                (max len len', 0) of
    {  len, len' := max len len'};

    type Tree (A : Type) :=
    | leaf A
    | node (Tree A) (Tree A);

    --- Write a function that counts the total number of leaves in a tree
    countLeaves {A} : Tree A -> Nat
    | (leaf _) := 1
    | (node l r) := countLeaves l + countLeaves r;

    --- Write a function which checks if a ;Tree; is balanced.
    --- A ;Tree; is balanced if the number of leaves in the left and right subtree of every
    --- node differ by at most 1.
    isBalanced {A} : Tree A -> Bool :=
    let
        go : Tree A ->
        Bool -- returns the value if the given tree is balanced
        × Nat -- returns the number of leaves in the given tree
        | (leaf _) := true, 1
        | (node l r) :=
            case go l, go r of
            { (isLeftBalance, nl), (isRightBalance, nr) :=
                    (isLeftBalance && isRightBalance &&
                        sub nr nl <= 1
                    && sub nl nr <= 1),
                nl + nr};
    in fst ∘ go;
    ```
