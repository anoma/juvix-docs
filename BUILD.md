# Building the Juvix Documentation

The documentation is built with [MkDocs](https://www.mkdocs.org) and the [MkDocs
Material](https://squidfunk.github.io/mkdocs-material) theme. In principle, the
documentation is built automatically by the CI whenever a pull request is merged
into the `main` branch. The generated documentation is then pushed to the
`gh-pages` branch within the repository, making it accessible at
https://docs.juvix.org. The official documentation is built using the `insiders`
version of the Material theme to leverage some additional features that are not
publicly available yet. However, these additional features are not a heavy
requirement for building the documentation. If you encounter any issues with the
documentation due to this, please open an issue. Please note that the official
online version of the documentation may appear slightly different from the one
you see locally due to these additional features. The features of the `insiders`
version of the theme are listed
[here](https://squidfunk.github.io/mkdocs-material/insiders/) and are marked as
"Sponsors only" and "insiders" in the corresponding [reference
pages](https://squidfunk.github.io/mkdocs-material/reference/).

## Prerequisites

To build the documentation locally, you need to install the following
dependencies:

- [Python](https://www.python.org) >= 3.11
- [Pip](https://pypi.org/project/pip)

To install the Python dependencies, execute the following command:

```bash
pip3 install --user -r requirements.txt
```

Alternatively, you can run `make python-requirements`.

You will need to install Juvix as well. Please refer to the [Juvix
documentation](https://docs.juvix.org).

**NB:** The CI expects all Juvix code to be formatted and typechecked.
Therefore, make sure to run `make pre-commit` before pushing your changes, which
will run `make format-juvix-files` and `make typecheck-juvix-files`
automatically.

### Building Locally without Mkdocs Material Insiders

If you want to build the documentation without the `insiders` version of the
theme, run the following command:

```bash
make docs
```

To view the documentation locally, run the following command:

```bash
make serve
```

### Building Locally with Mkdocs Material Insiders

For this step, you need to set up a virtual environment and install the
dependencies.

```bash
export GH_TOKEN=...
```

Ask a maintainer for the GitHub token, then install the material-insiders
dependency:

```shell
pip3 install --user -r insiders.requirements.txt
```

After that, build the documentation with the following command:

```bash
MKDOCSCONFIG=mkdocs.insiders.yml make docs
```

To view the documentation locally, run the following command:

```bash
MKDOCSCONFIG=mkdocs.insiders.yml make serve
```

## Deploying the Documentation from a Local Machine

The following steps will push the generated documentation to the `gh-pages`
branch within the repository, subsequently making it accessible at
https://docs.juvix.org under the `dev` version. Please be aware that this action
will overwrite the current online `dev` version of the documentation. Therefore,
ensure you are not overwriting anything important before proceeding. Exercise
caution when executing this command.

```bash
make pre-build
make pre-commit
MKDOCSCONFIG=mkdocs.insiders.yml make dev
```

**NB:** The CI installs the latest official release of the Juvix compiler. If
you want to test the documentation with a development version of the compiler,
you need to do it locally. If you push the documentation to the `dev` branch
using a development version of the compiler, the CI may fail to build the
subsequent pull requests.

If you wish to deploy an "official" version of the documentation for any reason,
execute the following commands, similar to the ones mentioned above. This will
overwrite the current `latest` version of the documentation. Please exercise
caution when executing this command.

```bash
make pre-build
make pre-commit
MKDOCSCONFIG=mkdocs.insiders.yml make release
```
