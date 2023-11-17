---
icon: material/equal
comments: false
search:
  boost: 5
---

# How to setup a Juvix project

A _Juvix project_ is a collection of Juvix modules plus some extra metadata
gathered in a `Package.juvix` file. The most convenient way to create a Juvix
project is to run the command:

```shell
--8<------ "docs/howto/project/CLI.yaml:init"
```

## Package.juvix file

A project is rooted in a directory. The root is set by creating a `Package.juvix`. The simplest `Package.juvix` file, which uses the default configuration, is:

```juvix
--8<------ "docs/howto/project/Package.juvix:Package"
```

You can override the default options by passing arguments to `defaultPackage`:

```juvix
--8<------ "docs/howto/project/ex1/Package.juvix:Example"
```

You can check the documentation of the `Package` type or the `defaultPackage` function by using the go-to-definition feature in your IDE.

The arguments are explained below.

- **name**: This is the name assigned to the project. The name must not be empty
  and cannot exceed 100 characters. Lower case letters, digits and hyphen `-`
  are acceptable characters. The first letter must not be a hyphen.
  Summarizing, it must match the following regexp: `[a-z0-9][a-z0-9-]{0,99}`.
- **version** (_optional_): The version of the project. It must follow the
  [SemVer](https://semver.org/) specification. If unspecified, the default version is "0.0.0".
- **main** (_optional_): The main module of the project used as entry point.
- **dependencies** (_optional_): The dependencies of the project is given as a
  list. See below for more information. If unspecified, the default is `defaultStdlib`.

!!! info "Note"

      As intuition would tell, a Juvix module belongs to a Juvix project if it is
      placed in the subtree hanging from the root directory. This rule has two
      exceptions:

      1. Modules in a hidden (or hanging from a hidden) directory are not part of the
         project. E.g., if the root of a project is `dir`, then the module
         `dir/.d/Lib.juvix` does not belong to the project rooted in `dir`.
      1. A `Package.juvix` file shadows other `Package.juvix` files in parent
         directories. E.g. if the root of a project is `dir` and the files
         `dir/Package.juvix` and `dir/nested/Package.juvix` exist, then the module
         `dir/nested/Lib.juvix` would belong to the project in `dir/nested`.

!!! info "Note"

      Any Juvix module outside of a project is considered a _standalone module_ and lives in its own (global) project. In other words, there is no need to create a `Package.juvix` file for a standalone module.

## Package dependencies

In `Package.juvix`, the `Package` type includes a dependencies field, which lists the other Juvix packages required by the project, with each dependency represented as an element of the `Dependency` type.

Your project's code can use modules from dependent packages via standard Juvix `import` statements.

There are three types of dependencies, all illustrated in the following snippet:

```juvix
--8<------ "docs/howto/project/ex2/Package.juvix:Dependencies"
```

### Git Dependencies

A `git` dependency is a Juvix package located at the root of an external git
repository. You can specify such a dependency in two ways:

1. By using the `git` constructor of the `Dependency` type, you can declare the dependency by providing its name (used to name the directory where the repository is cloned), the git repository URL, and the specific reference (like a version tag or branch). For example:

   ```
   git "juvix-containers" "https://github.com/anoma/juvix-containers" "v0.7.1"
   ```

2. By using the `github` function, which is a convenient method for packages hosted on GitHub. This function requires the GitHub organization name, the repository name, and the reference you're targeting. For example:

   ```
   github "anoma" "juvix-containers" "v0.7.1"
   ```

!!! info Inline end "Note"

      The values of the `name` fields must be unique among the git blocks in the dependencies list.

### Path Dependencies

A `path` dependency is a Juvix package located on your local filesystem. You can refer to such dependencies using absolute or relative paths. For example:

```
path ".deps/a/juvix/package"
```

### The built-in Juvix standard library - `defaultStdlib`

The Juvix standard library is included with the Juvix compiler, and you can depend on it by using the `defaultStdlib` constructor.

## Behaviour of Git dependencies

When dependencies for a package are registered, at the beginning of the compiler
pipeline, all remote dependencies are processed:

1. If it does not already exist, the remote dependency is cloned to
   `.juvix-build/deps/$name`
2. `git fetch` is run in the clone
3. `git checkout` at the specified `ref` is run in the clone

!!! info "Note"

      * Remote dependencies of transitive dependencies are also processed.
      * The `git fetch` step is required for the case where the remote is updated.

!!! info "Lock file"

      * A lock file, juvix.lock.yaml is generated in the same directory as `Package.juvix`. This file is used to
        determine if any dependency needs to be updated. If the `ref` in the
        lock file does not match the `ref` in the package file, it is considered out of date.

<!-- Add more about the new `juvix dependencies` -->

#### Fixing errors

- Juvix parse or typechecker errors will be reported by the Juvix compiler.
- Duplicate `name` values in the dependencies list is an error thrown when the package file is processed
- The `ref` does not exist in the clone or the clone directory is otherwise
  corrupt. An error with a suggestion to `juvix clean` is given. The package
  file path is used as the location in the error message.
- Other `git` command errors (command not found, etc.), a more verbose error is
  given with the arguments that were passed to the git command.
