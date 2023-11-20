---
icon: material/comment-text
comments: false
search:
  boost: 3
---
# Commenting in Juvix

Comments provides a way to document code for better understanding and
readability for users and future developers. In Juvix, the commenting syntax
follows that of `Haskell`.

## Syntax of Comments

There are several types of comments you can use in Juvix. These include inline
comments, region comments, Judoc inline comments, and Judoc block comments.

### Inline Comment

Inline comments start with two hyphens (`--`). They extend to the end of the line.

```juvix
-- This is an inline comment!
```

### Region Comment

Region comments are multi-line comments. They start with `{ -` and end with `- }`.

```text
{-
    This is a region comment spanning multiple lines!
-}
```

### Judoc Inline Comments

Judoc inline comments are used specifically to document functions and types.
They begin with three hyphens (`---`). For more information on using Judoc
comments, refer to the [Judoc documentation](./../judoc.md).

```text
--- This is a Judoc inline comment used for documenting functions or types!
```

### Judoc Block Comments

Similar to region comments, Judoc block comments span multiple lines. They start
with `{ --` and end with `-- }`. For more information on using Judoc comments,
refer to the [Judoc documentation](./../judoc.md).

```text
{--
    This is a Judoc block comment used for documenting larger code blocks!
--}
```
