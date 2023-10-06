---
icon: material/equal
comments: false
search:
  boost: 5
---

# How to setup a Juvix project

A _juvix project_ is a collection of juvix modules plus some extra metadata
gathered in a `juvix.yaml` file. The most convenient way to create a juvix
project is to run the command `juvix init`.

## Juvix YAML file

A project is rooted in a directory. The root is set by creating a `juvix.yaml`,
which contains the following fields, no order is required:

- `name`
- `version`
- `dependencies`
- `main`

The fields are explained below.

- **name**: This is the name assigned to the project. The name must not be empty
  and cannot exceed 100 characters. Lower case letters, digits and hyphen `-`
  are acceptable characters. The first letter must not be a hyphen.
  Summarizing, it must match the following regexp: `[a-z0-9][a-z0-9-]{0,99}`.
- **version** (_optional_): The version of the project. It must follow the
  [SemVer](https://semver.org/) specification. If the version is missed then it
  will be assumed to be _0.0.0_.
- **main** (_optional_): The main module of the project used as entry point.
- **dependencies** (_optional_): The dependencies of the project is given as a
  list. See below for more information.

!!! info "Note"

      As intuition would tell, a Juvix module belongs to a Juvix project if it is
      placed in the subtree hanging from the root directory. This rule has two
      exceptions:

      1. Modules in a hidden (or hanging from a hidden) directory are not part of the
         project. E.g., if the root of a project is `dir`, then the module
         `dir/.d/Lib.juvix` does not belong to the project rooted in `dir`.
      1. A `juvix.yaml` file shadows other `juvix.yaml` files in parent
         directories. E.g. if the root of a project is `dir` and the files
         `dir/juvix.yaml` and `dir/nested/juvix.yaml` exist, then the module
         `dir/nested/Lib.juvix` would belong to the project in `dir/nested`.

!!! info "Note"

      Any Juvix module outside of a project is considered a _standalone module_ and lives in its own (global) project. In other words, there is no need to create a `juvix.yaml` file for a standalone module.

## Package dependencies

In order to specify the list of dependencies for a package, the field
`dependencies` has been added to the `juvix.yaml`. The `dependencies` field is a
list of directories (relative or absolute) or git dependencies. If the
dependency is a directory then its location must contain a `juvix.yaml` file. As
expected, if we add a package to the list of dependencies, we will be able to
access its modules through import statements. External dependencies are
supported through git dependencies.

By default, the compiler include the standard library as a dependency, and
therefore a user can use it including the following line in the `juvix.yaml`

```yaml
# -- juvix.yaml
dependencies:
  - .juvix-build/stdlib/
file: []
name: juvix-docs
version: 0.0.0
```

### External dependencies

To use external dependencies, it is required to have `git` installed. You can
add a git block to the dependencies list:

```yaml
name: HelloWorld
main: HelloWorld.juvix
dependencies:
  - .juvix-build/stdlib
  - git:
      url: https://my.git.repo
      name: myGitRepo
      ref: main
version: 0.1.0
```

Git block required fields:

- `url`: The URL of the git repository

- `ref`: The git reference that should be checked out

!!! info Inline end "Note"

      The values of the `name` fields must be unique among the git blocks in the dependencies list.

- `name`: The name for the dependency. This is used to name the
  directory of the
  clone, it is required. Perhaps we could come up with a way to automatically
  name the clone directory. Current ideas are to somehow encode the URL / ref
  combination or use a UUID. However, there's some value in having the clone
  directory named in a friendly way.

#### Behaviour

When dependencies for a package are registered, at the beginning of the compiler
pipeline, all remote dependencies are processed:

1. If it does not already exist, the remote dependency is cloned to
   `.juvix-build/deps/$name`
2. `git fetch` is run in the clone
3. `git checkout` at the specified `ref` is run in the clone

!!! info "Note"

      * Remote dependencies of transitive dependencies are also processed.
      * The `git fetch` step is required for the case where the remote is updated.

#### Fixing errors

- Missing fields in the Git dependency block are YAML parse errors
- Duplicate `name` values in the dependencies list is an error thrown when the package file is processed
- The `ref` does not exist in the clone or the clone directory is otherwise
  corrupt. An error with a suggestion to `juvix clean` is given. The package
  file path is used as the location in the error message.
- Other `git` command errors (command not found, etc.), a more verbose error is
  given with the arguments that were passed to the git command.
