---
date: 2023-06-08
readtime: 5
authors:
  - lukasz
categories:
  - language
tags:
  - iterators
  - syntax
links:
  - Juvix iterator reference: https://docs.juvix.org/latest/reference/language/iterators
  - Juvix iterator tutorial: https://docs.juvix.org/latest/tutorials/learn/#iteration-over-data-structures
---

# Iterator syntax

A common pattern in functional programming is the traversal of data structures, particularly lists, in a specified order accumulating some values. If you've used languages like Haskell or OCaml, you must have come across the "fold left" (`foldl`) and "fold right" (`foldr`) higher-order functions which implement this pattern. These functions are also [available in Juvix][juvix-folds]. In this blog post, I describe an iterator syntax I designed for Juvix which allows to express folds (and maps, filters and more) in a readable manner.

The next paragraph dicusses some issues with using fold functions directly. Don't worry if you've never heard of folds - just skip this paragraph and the rest of the blog post will teach you how to use them in a nice iterator syntax.

The problem with folds is that they are hard to read and understand, which results in code that is difficult to maintain. From a fold application, e.g., `foldr \{ acc x := body } a xs`, it is not always immediately apparent how the list traversal proceeds. This is especially the case when the function argument is big and spans several lines - then the initial value `a` of the accumulator and the list `xs` are syntactically "disconnected" from the accumulator variable `acc` and the current list element `x`. Personally, I also find it hard to remember which argument is which - this differs between different functional languages. I'm not the first person who noticed this problem. For example, the unreadability of folds was one of the motivations behind introducing a monadic `for .. in` notation in [Lean 4][lean-for].

## The essence of folds

The anatomy of a fold (left or right) is simple.

1. We have an accumulator variable `acc` which we initialise to some value `a`.

2. We go through a data structure (list) in some specified order (left-to-right or right-to-left).

3. At each step, we receive the current value of the accumulator `acc` and the current element `x`. From those we need to compute the new value of `acc`.

4. After going through all elements, the final value of `acc` is the result of the fold expression.

## The for-notation

The [Juvix standard library][juvix-stdlib] defines two iterators on lists which correspond to list folds:

- `for` as a syntactic sugar for fold left (`foldl`),
- `rfor` as a syntactic sugar for fold right (`foldr`).

Iterator application has the syntax:

```juvix
for (acc := a) (x in xs) body
```

The above `for` iteration starts with the accumulator `acc` equal to `a` and goes through the list `xs` from left to right (from beginning to end), at each step updating the accumulator to the result of evaluating `body`. The variables `acc`, `x` are locally bound in `body` where they denote the previous accumulator value (`acc`) and the current element (`x`). The final value of the accumulator becomes the value of the entire `for` expression.

For example, the following code computes the sum of all numbers in the list `xs`:

```juvix
for (acc := 0) (x in xs) x + acc
```

Product of all numbers in a list:

```juvix
for (acc := 1) (x in xs) x * acc
```

Reversing a list:

```juvix
for (acc := nil) (x in xs) x :: acc
```

Counting odd numbers in a list:

```juvix
for (acc := 0) (x in xs) if (mod x 2 == 0) acc (acc + 1)
```

Sum of squares of positive numbers in a list:

```juvix
for (acc := 0) (x in xs) if (x > 0) (acc + x * x) acc
```

The `for` iterator is complemented by the `rfor` iterator which goes through the list from right to left (from end to beginning).

For example, the following code concatenates all lists from a list of lists:

```juvix
rfor (acc := nil) (x in xs) x ++ acc
```

If we used the `for` iterator above, the order of concatenations would be reversed.

Applying a function `f` to each element in a list may be implemeted with:

```juvix
rfor (acc := nil) (x in xs) f x :: acc
```

Filtering a list with a predicate `p`:

```juvix
rfor (acc := nil) (x in xs) if (p x) (x :: acc) acc
```

The above keeps only the elements that satisfy `p`. The order of the elements would be reversed if we used `for` instead of `rfor`.

## Maps, filters and more

If you're familiar with the `map` and `filter` higher-order functions, you probably noticed that the last two examples above provide their implementations using `rfor`. In fact, one can use the iterator notation directly with `map` and `filter`, and several other list functions from the standard library. In this case, there are no explicit accumulators in the notation.

The expression

```juvix
map (x in xs) body
```

is equivalent to (assuming `acc` doesn't occur in `body`)

```juvix
rfor (acc := nil) (x in xs) body :: acc
```

or if you're familiar with the standard `map` function:

```juvix
map \{ x := body } xs
```

Similarly, one can use the notation

```juvix
filter (x in xs) p x
```

to filter `xs` with the predicate `p`.

Other functions that can be used with the iterator syntax are `all` and `any` which check whether all, resp. any, elements `x` in a list satisfy `body` (which would of course refer to `x`):

```juvix
all (x in xs) body

any (x in xs) body
```

## Multiple accumulators

In fact, the `acc` and `x` in the iterator syntax don't need to be variables - they can be arbitrary patterns. This is especially useful in conjunction with pairs, allowing to effectively operate on multiple accumulators.

For example, to compute the largest and the second-largest element of a list of non-negative numbers one can use:

```juvix
for (n, n' := 0, 0) (x in lst) if (x >= n) (x, n) (if (x > n') (n, x) (n, n'))
```

where `n` is the largest and `n'` the second-largest element found so far.

One can also operate on multiple lists simultaneously. For example, the following computes the dot product of the lists `xs`, `ys` (assuming they have equal lengths):

```juvix
for (acc := 0) (x, y in zip xs ys) x * y + acc
```

The `zip` function creates a list of pairs of elements in the two lists, e.g.,

```juvix
zip (1 :: 2 :: nil) (3 :: 4 :: nil) = (1, 3) :: (2, 4) :: nil
```

## Declaring iterators

Iterator syntax can be enabled for any identifier `func` with the declaration:

```juvix
syntax iterator func;
```

Then any iterator application of the form

```juvix
func (acc1 := a1; ..; accn := an) (x1 in xs1; ..; xk in xsk) body
```

is automatically replaced by

```juvix
func \{ acc1 .. accn x1 .. xk := body } acc1 .. accn xs1 .. xsk
```

The replacement is entirely syntactic and happens before type-checking.

It is possible to restrict the number of _initialisers_ (`acci := ai`) and _ranges_ (`xi in xsi`) accepted:

```juvix
syntax iterator func {init: n, range: k};
```

## Further reading

More information on iterators can be found in the [Juvix language reference][juvix-reference-iterators] and the [Juvix tutorial][juvix-tutorial-iterators].

[lean-for]: https://leanprover.github.io/functional_programming_in_lean/monad-transformers/do.html#loops
[juvix-folds]: https://anoma.github.io/juvix-stdlib/Stdlib.Data.List.Base.html
[juvix-stdlib]: https://anoma.github.io/juvix-stdlib
[juvix-reference-iterators]: https://docs.juvix.org/latest/reference/language/iterators
[juvix-tutorial-iterators]: https://docs.juvix.org/latest/tutorials/learn/#iteration-over-data-structures
