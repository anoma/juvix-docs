VERSION?=$(shell cat VERSION)
# use this boolean to checkout the head of the juvix repo
HEAD?=false

PWD=$(CURDIR)
UNAME := $(shell uname)

JUVIXBIN?=juvix
JUVIXBINVERSION?=$(shell ${JUVIXBIN} --numeric-version)
COMPILERSOURCES?=juvix-src

MAKEAUXFLAGS?=-s
MAKE=make ${MAKEAUXFLAGS}
METAFILES:= \
		   CHANGELOG.md \
		   CONTRIBUTING.md \
		   LICENSE.md

clean: clean-juvix-build
	@rm -rf site
	@rm -rf .cache
	@rm -rf juvix-src

.PHONY: clean-hard
clean-hard: clean clean-juvix-build
	@git clean -fdx

.PHONY: clean-juvix-build
clean-juvix-build:
	@find . -type d -name '.juvix-build' | xargs rm -rf

# ----------------------------------------------------------------------------
# -- MkDocs installation
# ----------------------------------------------------------------------------

PYTHON := $(shell command -v python3 2> /dev/null)
PIP := $(shell command -v pip3 2> /dev/null)

.PHONY: python-env
python-env:
	@$(if $(PYTHON),, \
		echo "[!] Python3 is not installed. Please install it and try again.")
	@$(if $(PIP),,\
		echo "[!] Pip3 is not installed. Please install it and try again.")
	${PYTHON} -m venv python-env

.PHONY : mkdocs
mkdocs: python-env
	@source python-env/bin/activate && \
		pip install -r requirements.txt

# ----------------------------------------------------------------------------
# -- Juvix Compiler installation
# ----------------------------------------------------------------------------

.PHONY: juvix
juvix:
	@if [ ! -d ${COMPILERSOURCES} ]; then \
		git clone -b main https://github.com/anoma/juvix.git ${COMPILERSOURCES}; \
	fi
	@cd ${COMPILERSOURCES} && \
		git fetch --all && \
		if [ "${HEAD}" = true ]; then \
			echo "[!] Use Juvix HEAD commit in main"; \
			git checkout main; \
		else \
			echo "[!] Use Juvix ${VERSION}"; \
			git checkout v${VERSION}; \
		fi && \
		${MAKE} install; \

# The numeric version of the Juvix compiler must match the
# version of the documentation specified in the VERSION file.
checkout-juvix: juvix
	@if [ "${JUVIXBINVERSION}" != "${VERSION}" ]; then \
		echo "[!] Juvix version ${JUVIXBINVERSION} does not match the documentation version $(VERSION)."; \
		exit 1; \
	fi

# ----------------------------------------------------------------------------
# -- Examples and other sources from the Juvix Compiler repo
# ----------------------------------------------------------------------------

EXAMPLEHTMLOUTPUT=docs/examples/html
EXAMPLEMILESTONE=${COMPILERSOURCES}/examples/milestone
EXAMPLES= Collatz/Collatz.juvix \
	Fibonacci/Fibonacci.juvix \
	Hanoi/Hanoi.juvix \
	HelloWorld/HelloWorld.juvix \
	PascalsTriangle/PascalsTriangle.juvix \
	TicTacToe/CLI/TicTacToe.juvix \
	Tutorial/Tutorial.juvix

.PHONY: juvix-metafiles
juvix-metafiles:
	@for file in $(METAFILES); do \
		echo ${COMPILERSOURCES}/$$file; \
		cp ${COMPILERSOURCES}/$$file docs/; \
	done
	cp ${COMPILERSOURCES}/README.md docs/overview.md

.PHONY: html-examples
html-examples: juvix
	@for file in $(EXAMPLES); do \
			OUTPUTDIR=$(EXAMPLEHTMLOUTPUT)/$$(dirname $$file); \
			mkdir -p $${OUTPUTDIR}; \
			$(JUVIXBIN) html $(EXAMPLEMILESTONE)/$$file \
					--output-dir=$(CURDIR)/$${OUTPUTDIR}; \
	done

# ----------------------------------------------------------------------------
# -- Building the documentation
# ----------------------------------------------------------------------------

PORT?=8000
ALIAS?=latest
MKDOCSCONFIG?=mkdocs.insiders.yml

icons:
	rm -rf docs/overrides/.icons/bootstrap
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
	@cd docs/overrides/.icons && unzip -o codeicons.zip

.PHONY: docs
docs:
	mkdocs build --config-file ${MKDOCSCONFIG}

.PHONY: serve
serve: docs
	mkdocs serve --dev-addr localhost:${PORT} --config-file ${MKDOCSCONFIG}

mike:
	mike deploy ${VERSION} --config-file ${MKDOCSCONFIG}

mike-serve: docs
	mike serve --dev-addr localhost:${PORT} --config-file ${MKDOCSCONFIG}

deploy: checkout-juvix  \
			juvix-metafiles  \
			html-examples  \
			icons
	mike set-default ${VERSION} --config-file ${MKDOCSCONFIG}
	mike alias ${VERSION} latest --config-file ${MKDOCSCONFIG}
	${MAKE} mike

# ----------------------------------------------------------------------------
# -- Codebase Health and Quality
# ----------------------------------------------------------------------------

PRECOMMIT := $(shell command -v pre-commit 2> /dev/null)

.PHONY : install-pre-commit
install-pre-commit :
	@$(if $(PRECOMMIT),, pip install pre-commit)

.PHONY : pre-commit
pre-commit :
	@pre-commit run --all-files

JUVIXFILESTOFORMAT=$(shell find ./docs -type d -name ".juvix-build" -prune -o -type f -name "*.juvix" -print)
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

JUVIXEXAMPLEFILES=$(shell find ./docs  -name "*.juvix" -print)

.PHONY: typecheck-juvix-examples
typecheck-juvix-examples:
	@for file in $(JUVIXEXAMPLEFILES); do \
		echo "Checking $$file"; \
		${JUVIXBIN} typecheck "$$file" $(JUVIXTYPECHECKFLAGS); \
	done
