---
date: 2023-06-15
readtime: 15
authors:
  - lukasz
categories:
  - vampir
tags:
  - circuits
  - vampir
links:
  - Vamp-IR book: https://anoma.github.io/VampIR-Book/
  - A Vamp-IR's guide to arithmetic and circuits: https://blog.anoma.net/a-vamp-irs-guide-to-arithmetic-circuits-and-perfectly-boiled-eggs/
---

# Compiling Juvix programs to arithmetic circuits via Vamp-IR

Since version 0.3.5, the Juvix compiler supports the `vampir` target which generates [Vamp-IR][vampir-book] input files that can be compiled to various proof systems based on arithmetic circuits, like Plonk or Halo 2. Vamp-IR is a proof-system-agnostic language for writing arithmetic circuits used as an itermediate representation by Juvix.

In this post, I will not be discussing the details of VampIR or the circuit computation model, beyond what is necessary to understand how to compile Juvix programs to circuits. Instead, I will describe how high-level functional Juvix programs can be compiled to circuits, what the common pitfalls and current limitations are. The reader is assumed to have at least basic familiarity with [Vamp-IR][vampir-book].

## A simple circuit program

For a simple example of a Juvix program that can be compiled to arithmetic circuits via VampIR, we consider computing the 6-bit mid-square hash of a 16-bit number.

```juvix
module MidSquareHash;

import Stdlib.Prelude open;
import Stdlib.Data.Nat.Ord open;

--- `pow N` is 2 ^ N
pow : Nat -> Nat;
pow zero := 1;
pow (suc n) := 2 * pow n;

--- `hash N` hashes a number with max N bits (i.e. smaller than 2^N) into 6 bits
--- (i.e. smaller than 64) using the mid-square algorithm.
hash : Nat -> Nat -> Nat;
hash (suc n@(suc (suc m))) x :=
  if
    (x < pow n)
    (hash n x)
    (mod (div (x * x) (pow m)) (pow 6));
hash _ x := x * x;

main : Nat -> Nat -> Bool;
main x y := hash 16 x == y;
```

To compile this file to VampIR type

```
juvix compile -t vampir MidSquareHash.juvix
```

This should generate the `MidSquareHash.pir` file with the VampIR code.

The exact details of the hashing algorithm are not essential here. What matters is that Juvix can compile this ordinary high-level program, which uses recursion, pattern-matching, etc., into low-level VampIR representation. The user does not need to understand arithmetic circuits or VampIR beyond the basics.

The Juvix `main` function is compiled to a VampIR `main` function which is then used in an equation which connects the inputs (arguments of `main`) to the ouput of `main`. For example, for the program above the generated equation is:

```juvix
main x y = 1
```

stating that `main x y` equals `true`. The variables `x`, `y` are VampIR's private inputs.

## Controlling generated equations in the VampIR code

In principle, any Juvix program can be compiled to a circuit, subject to certain restrictions. When targeting VampIR, the `main` function must have the type

```juvix
main : ArgTy1 -> .. -> ArgTyN -> ResTy;
```

where `ArgTyK` and `ResTy` are `Nat`, `Int` or `Bool`. Since VampIR natively supports only numbers (the field elements), booleans are represented using `1` for `true` and `0` for `false`.

If the result type `ResTy` is a boolean (`Bool`), then the generated VampIR file will contain the equation

```juvix
main arg1 .. argN = 1
```

where `arg1`, .., `argN` are the names of inputs to the `main` function. By default, these are inferred from the variable names in the first clause of `main`, e.g., compiling

```juvix
main : Nat -> Nat -> Bool;
main x y := x == y;
```

will generate VampIR code similar to

```
def main x y := equals x y;

main x y = 1
```

The VampIR input variable names can also be explicitly specified with the `argnames` pragma, e.g., compiling

```juvix
{-# argnames: [a, b] #-}
main : Nat -> Nat -> Bool;
main x y := x == y;
```

will generate VampIR code similar to

```
def main x y := equals x y;

main a b = 1
```

If the result type `ResTy` is `Nat` or `Int`, then the generated equation is

```
main arg1 .. argN = out
```

Currently, all VampIR inputs (`argK`, `out`) are private and it is not possible to change the name of `out`. These technical limitation will be lifted in future Juvix versions.

## Recursion unrolling

Neither arithmetic circuits nor the VampIR intermediate representation support recursion. This means that all Juvix recursive functions need to be unrolled up to a specified depth. Currently, the default unrolling depth is 140, which may be too much or too little depending on your particular program. The unrolling depth can be specified globally on the command line with the `--unroll` option, or on a per-function basis with the `unroll` pragma. For example, using

```juvix
{-# unroll: 16 #-}
hash : Nat -> Nat -> Nat;
```

would limit the recusion depth (i.e. the number of possible nested recursive calls) for `hash` to 16. It is the responsibility of the user to ensure that the recursion unrolling depth is sufficient for all arguments that the function might be applied to in the program. In the above example, `hash` recurses on its first argument and the call to `hash` in `main` provides `16` as the first argument. Hence, no more than 16 nested recursive calls to `hash` are possible.

If the recursion unrolling depth is too small, i.e. smaller than the actual number of nested recursive calls, then the computation result may be incorrect.

## The compilation method - normalization

Currently, the Juvix compiler uses a straightforward method to translate Juvix programs to VampIR code: it simply computes the full [normal form](normal-form) of the `main` function. Because of the restrictions we imposed on its type, the normal form of the `main` function must be an applicative expression built up from variables, constants and arithmetic and boolean operations. Such an expression can be directly translated to the VampIR input format.

The disadvantage of performing full normalization is that it may super-exponentially blow up the size of the program. As explained below, this applies in particular to branching recursive functions with at least two recursive calls.

## The branching problem

With the current compilation method, any recursive function which contains two or more recursive calls to itself in its body will cause an exponential blow-up in the generated code size, and thus will most likely fail to compile.

For example, trying to compile the fast power function

```juvix
{-# unroll: 30 #-}
terminating
power' : Nat → Nat → Nat → Nat;
power' acc a b :=
  if
    (b == 0)
    acc
    (if
      (mod b 2 == 0)
      (power' acc (a * a) (div b 2))
      (power' (acc * a) (a * a) (div b 2)));

power : Nat → Nat → Nat;
power := power' 1;
```

makes the Juvix compiler hang. The pragma `unroll: 30` doesn't help, because 2^30 = 1073741824 is still a large number - this is the factor by which the program size increases during compilation.

However, the fast power function may be reformulated to use only one recusive call:

```juvix
{-# unroll: 30 #-}
terminating
power' : Nat → Nat → Nat → Nat;
power' acc a b :=
  let
    acc' : Nat := if (mod b 2 == 0) acc (acc * a);
  in if (b == 0) acc (power' acc' (a * a) (div b 2));

power : Nat → Nat → Nat;
power := power' 1;
```

With the reformulated definition, Juvix-to-VampIR compilation succeeds and it is possible to generate a ZK proof that 2^30 is indeed 1073741824.

[vampir-book]: https://anoma.github.io/VampIR-Book/
[normal-form]: https://en.wikipedia.org/wiki/Beta_normal_form
