---
icon: material/file-document-edit-outline
comments: true
search:
  exclude: true
---

# Documenting Juvix programs with Judoc

If you want to share your Juvix code with others, or even for your own sake, it
is important that you properly document your code. Juvix has a builtin simple
documentation language called `Judoc` that you can use to write documentation
for your modules, types and functions. Also, you'll be able to export the
documentation in a beautiful html format.

Let's look at an example:
```text
--8<------ "docs/howto/judoc/Main.juvix"
```

As you can see, when we want to write `Judoc` comments, we write three dashes `---`.

We can write Juvix expressions inside `Judoc` comments too. We do so by
delimiting it with `;`. Then, the Juvix code inside will be properly scoped and
highlighted. Remember that only things that are in scope can be referenced.

For more information about the syntax of the `Judoc` markup language, you can
refer to its [`reference`](../reference/judoc.md).

## Generating html
As mentioned before, we can generate html documentation by running the following command:
```
juvix html Main.juvix --open
```
This command will typecheck the `Main.juvix` module and all of its dependencies. Then it will generate
pretty documentation with links that looks like [`this`](https://anoma.github.io/juvix-stdlib/Stdlib.Data.List.Base.html). Note that you can jump to the source of each of the definitions.

For more information about the available options, type `juvix html --help`.
