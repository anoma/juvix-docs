---
icon: material/comment-text
comments: true
---

# Comments

Comments follow the same syntax as in `Haskell` and `Agda`. Be aware, Juvix has no support for nested comments.

- Inline Comment

```juvix
-- This is a comment!
```

- Region comment

```juvix
{-
    This is a comment!
-}
```

- Judoc inline comments. These are used to document functions and types. See [Judoc](./../judoc.md) for more information.

```juvix
--- This is a Judoc comment!
```

- Judoc block comments. See [Judoc](./../judoc.md) for more information.

```juvix
{--
    This is a Judoc comment!
--}
```
