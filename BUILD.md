
# Build

To deploy the documentation locally, you need to set up a virtual environment
and install the dependencies. This is not required if you opened a pull request
on GitHub, as the documentation will be built automatically once the pull
request is merged.

```bash
export GH_TOKEN=...
```

Ask a maintainer for the GitHub token.

```python
pip install git+https://${GH_TOKEN}@github.com/squidfunk/mkdocs-material-insiders.git
```

Then, you can build the documentation:

```bash
make pre-build
make dev
```

In case you want to deploy an "official" version of the documentation, you need
to build the documentation with the following command:

```bash
make pre-build
make release
```
