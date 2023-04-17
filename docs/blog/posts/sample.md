---
date: 2022-04-14
draft: true
author: Tara
categories:
  - implementation-notes
---

# Highlighting Juvix code

```juvix
  module HelloWorld;
      open import Stdlib.Prelude;
      main : IO;
      main := printStringLn "hello world!";
```

## Typesetting math

$$ \forall x \in \mathbb{N} \quad x > 0 $$

## Including code from another file

``` juvix
--8<------ "examples/milestone/HelloWorld/HelloWorld.juvix"
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vitae


### Reference range of lines

``` juvix
--8<------ "examples/milestone/PascalsTriangle/PascalsTriangle.juvix:4:6"
```

### Reference function directly

``` juvix
--8<------ "examples/milestone/PascalsTriangle/PascalsTriangle.juvix:zipWith"
```