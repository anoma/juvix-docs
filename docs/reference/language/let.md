---
icon: material/equal
comments: false
---

# Local definitions

Local definitions are introduced with the `let` construct.

```juvix
--8<-- "docs/reference/language/lets.juvix:let-sum"
```

The declarations within a `let` statement share the same syntax as those inside a module. However, their visibility is limited to the expression that follows the `in` keyword.
