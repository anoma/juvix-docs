# [Juvix Official Documentation](https://docs.juvix.org)

<a href="https://github.com/anoma/juvix"><img align="right" width="300" alt="Tara the Juvix mascot" src="https://github.com/anoma/juvix/raw/main/assets/images/tara-smiling.svg" /></a>

[![Juvix-Docs CI](https://github.com/anoma/juvix-docs/actions/workflows/ci.yml/badge.svg)](https://github.com/anoma/juvix-docs/actions/workflows/ci.yml)

[![pages-build-deployment](https://github.com/anoma/juvix-docs/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/anoma/juvix-docs/actions/workflows/pages/pages-build-deployment)

<a
href="https://github.com/anoma/juvix/actions/workflows/ci.yml"><img
src="https://github.com/anoma/juvix/actions/workflows/ci.yml/badge.svg"
alt="The Juvix compiler CI" /></a>

<a
href="https://github.com/anoma/juvix-nightly-builds/actions/workflows/release-nightly.yaml"><img
src="https://github.com/anoma/juvix-nightly-builds/actions/workflows/release-nightly.yaml/badge.svg"
alt="Nightly build, release and benchmark" /></a>

<a href="https://github.com/anoma/juvix/tags"><img src="https://img.shields.io/github/v/release/anoma/juvix?include_prereleases"/></a>

<a href="https://github.com/anoma/juvix/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-GPL--3.0--only-blue.svg"/></a>


## Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes. If this is not your goal,
you can edit the files Markdown directly on GitHub, open a PR with the changes,
and the CI/CD pipeline will automatically build and deploy the website, once
the PR is merged.

To write the content, we use Markdown with some extensions as described in the
[Material for MkDocs's reference](https://squidfunk.github.io/mkdocs-material/reference/).

In addition, we support the use of Juvix code examples in the files with the
`.juvix.md` extension. These files are rendered using [Juvix
(+v0.6.1)](https://docs.juvix.org/), and and if you want to make sure that the
code examples are correct, you must have Juvix installed on your machine. One
way to do this is to install the Juvix plugin for VsCode from [the
marketplace](https://marketplace.visualstudio.com/items?itemName=heliax.juvix-mode).

### Prerequisites

The following are the prerequisites to build the website locally:

- Python 3.6 or higher + `pip`: You can install it from [here](https://www.python.org/downloads/).
- To deploy the website locally, you would need to install `graphviz` to generate SVG files for *dot* files.
- As mentioned, we would need `juvix` to render the Juvix code examples.

### Installing

1. Clone the repository

    ```bash
    git clone http://github.com/anoma/juvix-docs
    ```

2. Create a virtual environment

    ```bash
    python3 -m venv env
    ```

    <details> <summary> Activate the virtual environment </summary>

    Make sure to activate the virtual environment before proceeding. If you are using
    `bash`, you can do this by running:

    ```bash
    source env/bin/activate
    ```

    On `fish`, you can do this by running:

    ```bash
    source env/bin/activate.fish
    ```

    On `zsh`, you can do this by running:

    ```bash
    source env/bin/activate.zsh
    ```

    </details>

3. Install the required packages (preferably in the virtual environment)

    ```bash
    pip3 install -r requirements.txt
    ```

4. Make sure that everything is working by building the website

    ```bash
    mkdocs build
    ```

    This command will generate the website in the `site` directory.

5. To serve the website locally, run the following command:

    ```bash
    mkdocs serve
    ```

    Take into account that this webserver will automatically reload the website
    when you make changes to the files, and it is not especially fast.

    <details> <summary> Builds with quiet mode </summary>

     By default, both `make build` or `make serve` are not configured to use the
    `--quiet` flag that suppresses the output of the build process, including
    warnings and errors. If you don't see all this output, you can run:

    ```bash
    MKDOCSFLAGS=--quiet make build
    ```

    ```bash
    make test-build
    ```

    </details>
