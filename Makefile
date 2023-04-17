PWD=$(CURDIR)
UNAME := $(shell uname)

EXAMPLEMILESTONE=examples/milestone
EXAMPLEHTMLOUTPUT=docs/examples/html
EXAMPLES= Collatz/Collatz.juvix \
	Fibonacci/Fibonacci.juvix \
	Hanoi/Hanoi.juvix \
	HelloWorld/HelloWorld.juvix \
	PascalsTriangle/PascalsTriangle.juvix \
	TicTacToe/CLI/TicTacToe.juvix \
	Tutorial/Tutorial.juvix

DEMO_EXAMPLE=examples/demo/Demo.juvix

MAKEAUXFLAGS?=-s
MAKE=make ${MAKEAUXFLAGS}
METAFILES:=README.md \
		   CHANGELOG.md \
		   CONTRIBUTING.md \
		   LICENSE.md

JUVIXBIN?=juvix
JUVIXVERSION?=$(shell ${JUVIXBIN} --numeric-version)

clean: clean-juvix-build
	@rm -rf site

.PHONY: clean-hard
clean-hard: clean clean-juvix-build
	@git clean -fdx

.PHONY: clean-juvix-build
clean-juvix-build:
	@find . -type d -name '.juvix-build' | xargs rm -rf

# ------------------------------------------------------------------------------
# -- The Juvix Examples
# ------------------------------------------------------------------------------

.PHONY: html-examples
html-examples: $(EXAMPLES)

$(EXAMPLES):
	$(eval OUTPUTDIR=$(EXAMPLEHTMLOUTPUT)/$(dir $@))
	@mkdir -p ${OUTPUTDIR}
	@${JUVIXBIN} html $(EXAMPLEMILESTONE)/$@ --output-dir=$(CURDIR)/${OUTPUTDIR}

.PHONY: demo-example
demo-example:
	$(eval OUTPUTDIR=$(EXAMPLEHTMLOUTPUT)/Demo)
	@mkdir -p ${OUTPUTDIR}
	@${JUVIXBIN} html $(DEMO_EXAMPLE) --output-dir=$(CURDIR)/${OUTPUTDIR}

# -- Juvix MkDocs

PORT?=8000
ALIAS?=latest
MKDOCSCONFIG?=mkdocs.insiders.yml

icons:
	@cd docs/overrides/.icons \
		&& \
		curl -s https://api.github.com/repos/twbs/icons/releases/latest \
			| grep -a "browser_download_url.*bootstrap-icons.*" \
			| cut -d : -f 2,3 \
			| tr -d \" \
			| wget --output-document bootstrap.zip -qi - \
			&& unzip -o bootstrap.zip \
			&& rm -rf bootstrap.zip \
			&& mv bootstrap-icons-* bootstrap

.PHONY: docs-extra-files
docs-extra-files: html-examples
	@cp $(METAFILES) docs/
	@cp -r assets/ docs/

docs: docs-extra-files
	mkdocs build --config-file ${MKDOCSCONFIG}

serve:
	mkdocs serve --dev-addr localhost:${PORT} --config-file ${MKDOCSCONFIG}

mike: docs
	mike deploy ${JUVIXVERSION} --config-file ${MKDOCSCONFIG}

mike-serve: docs
	mike serve --dev-addr localhost:${PORT} --config-file ${MKDOCSCONFIG}

# ------------------------------------------------------------------------------
# -- Codebase Health
# ------------------------------------------------------------------------------

JUVIXFILESTOFORMAT=$(shell find ./examples ./tests/positive -type d -name ".juvix-build" -prune -o -type f -name "*.juvix" -print)
JUVIXFORMATFLAGS?=--in-place
JUVIXTYPECHECKFLAGS?=--only-errors

.PHONY: format-juvix-files
format-juvix-files:
	@for file in $(JUVIXFILESTOFORMAT); do \
		juvix format $(JUVIXFORMATFLAGS) "$$file"; \
	done

.PHONY: check-format-juvix-files
check-format-juvix-files:
	@export JUVIXFORMATFLAGS=--check
	@make format-juvix-files

JUVIXEXAMPLEFILES=$(shell find ./examples  -name "*.juvix" -print)

.PHONY: typecheck-juvix-examples
typecheck-juvix-examples:
	@for file in $(JUVIXEXAMPLEFILES); do \
		echo "Checking $$file"; \
		${JUVIXBIN} typecheck "$$file" $(JUVIXTYPECHECKFLAGS); \
	done

PRECOMMIT := $(shell command -v pre-commit 2> /dev/null)

.PHONY : install-pre-commit
install-pre-commit :
	@$(if $(PRECOMMIT),, pip install pre-commit)

.PHONY : pre-commit
pre-commit :
	@pre-commit run --all-files
