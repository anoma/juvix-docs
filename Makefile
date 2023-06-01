# Last official Juvix release
VERSION?=$(shell cat VERSION)
# The documention also contains descriptions of features that are not yet
# released. This flag enables the documentation of these features.
# By default, dev is shown as the version number.
DEV?=false
DEVALIAS?="dev"

PWD=$(CURDIR)
UNAME := $(shell uname)

JUVIXBIN?=juvix
JUVIXBINVERSION?=$(shell ${JUVIXBIN} --numeric-version)
COMPILERSOURCES?=juvix-src

MAKEAUXFLAGS?=-s
MAKE=make ${MAKEAUXFLAGS}
METAFILES:= README.md \
		   CHANGELOG.md \
		   CONTRIBUTING.md \
		   LICENSE.md

PORT?=8000
MKDOCSCONFIG?=mkdocs.insiders.yml
MIKEFLAGS?=--push  \
	--remote origin  \
	--branch gh-pages  \
	--config-file ${MKDOCSCONFIG}

EXAMPLEHTMLOUTPUT=docs/examples/html
EXAMPLEMILESTONE=${COMPILERSOURCES}/examples/milestone
EXAMPLES= Collatz/Collatz.juvix \
	Fibonacci/Fibonacci.juvix \
	Hanoi/Hanoi.juvix \
	HelloWorld/HelloWorld.juvix \
	PascalsTriangle/PascalsTriangle.juvix \
	TicTacToe/CLI/TicTacToe.juvix \
	Tutorial/Tutorial.juvix

all: dev

# ----------------------------------------------------------------------------

clean: clean-juvix-build
	@rm -rf site
	@rm -rf .cache
	@if [ -d ${COMPILERSOURCES} ]; then \
		cd ${COMPILERSOURCES} && ${MAKE} clean; \
	fi

.PHONY: clean-hard
clean-hard: clean clean-juvix-build
	@git clean -fdx
	@rm -rf juvix-src

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
	@pip3 install -r requirements.txt

# ----------------------------------------------------------------------------
# -- Juvix Compiler installation
# ----------------------------------------------------------------------------

.PHONY: juvix-sources
juvix-sources:
	@if [ ! -d ${COMPILERSOURCES} ]; then \
		git clone -b main https://github.com/anoma/juvix.git ${COMPILERSOURCES}; \
	fi
	@cd ${COMPILERSOURCES} && \
		git fetch --all && \
		if [ "${DEV}" = true ]; then \
			git checkout main > /dev/null 2>&1; \
		else \
			git checkout v${VERSION} > /dev/null 2>&1; \
		fi;

install-juvix: juvix-sources
	@cd ${COMPILERSOURCES} && ${MAKE} install

CHECKJUVIX:= $(shell command -v ${JUVIXBIN} 2> /dev/null)

.PHONY: juvix-bin
juvix-bin:
	@$(if $(CHECKJUVIX) , \
		, echo "[!] Juvix is not installed. Please install it and try again. Try make install-juvix")

# The numeric version of the Juvix compiler must match the
# version of the documentation specified in the VERSION file.
checkout-juvix: juvix-sources juvix-bin
	@if [ "${DEV}" != true ]; then \
		if [ "${JUVIXBINVERSION}" != "${VERSION}" ]; then \
			echo "[!] Juvix version ${JUVIXBINVERSION} does not match the documentation version $(VERSION)."; \
			exit 1; \
		fi; \
	fi

# ----------------------------------------------------------------------------
# -- Examples and other sources from the Juvix Compiler repo
# ----------------------------------------------------------------------------

HEADER := "---\\nnobuttons: true\\n---\\n"

.PHONY: juvix-metafiles
juvix-metafiles: juvix-sources
	@for file in $(METAFILES); do \
		echo -e "$(HEADER)" | \
			cat - ${COMPILERSOURCES}/$$file > temp  \
			&& mv temp docs/$$file; \
	done
	@mv docs/README.md docs/overview.md


.PHONY: html-examples
html-examples: juvix-sources juvix-bin
	@cp -r ${COMPILERSOURCES}/examples docs/
	@for file in $(EXAMPLES); do \
			OUTPUTDIR=$(EXAMPLEHTMLOUTPUT)/$$(dirname $$file); \
			mkdir -p $${OUTPUTDIR}; \
			$(JUVIXBIN) html $(EXAMPLEMILESTONE)/$$file \
					--output-dir=$(CURDIR)/$${OUTPUTDIR}; \
	done

# ----------------------------------------------------------------------------
# -- Building the documentation
# ----------------------------------------------------------------------------

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
	@cd docs/overrides/.icons && unzip -q -o codeicons.zip > /dev/null 2>&1

.PHONY: pre-build
pre-build:
	${MAKE} checkout-juvix && \
		${MAKE} juvix-metafiles && \
		${MAKE} html-examples && \
		${MAKE} icons &&  \
		${MAKE} pre-commit

.PHONY: docs
docs: pre-build
	@mkdocs build --config-file ${MKDOCSCONFIG}

.PHONY: serve
serve: docs
	@mkdocs serve --dev-addr localhost:${PORT} --config-file ${MKDOCSCONFIG}

# In case you want to serve the docs using Python's built-in server.
.PHONY: serve-python
serve-python: docs
	@echo "Serving docs at http://localhost:${PORT}"
	@cd site && python3 -m http.server ${PORT}

mike:
	mike deploy ${VERSION} ${MIKEFLAGS}

mike-serve: docs
	mike serve --dev-addr localhost:${PORT} --config-file ${MKDOCSCONFIG}

.PHONY: dev
dev: pre-build
	export DEV=true
	mike delete ${DEVALIAS} ${MIKEFLAGS} > /dev/null 2>&1 || true
	VERSION=${DEVALIAS} ${MAKE} mike

# Call this with `DEV=true make release` if you want to use
# the latest overview/change log from the main branch.
.PHONY: release
release: pre-build
	mike delete ${VERSION} ${MIKEFLAGS} > /dev/null 2>&1 || true
	${MAKE} mike
	mike alias ${VERSION} latest -u --no-redirect ${MIKEFLAGS}
	mike set-default ${VERSION} ${MIKEFLAGS}
	git tag -d v${VERSION} > /dev/null 2>&1 || true
	git tag -a v${VERSION} -m "Release v${VERSION}"

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
format-juvix-files: juvix-bin
	@for file in $(JUVIXFILESTOFORMAT); do \
		${JUVIXBIN} format $(JUVIXFORMATFLAGS) "$$file" > /dev/null 2>&1; \
		exit_code=$$?; \
		if [ $$exit_code -eq 0 ]; then \
			echo "[OK] $$file"; \
      	elif [[ $$exit_code -ne 0 && "$$file" == *"tests/"* ]]; then \
			echo "[CONTINUE] $$file is in tests directory."; \
      	else \
 			echo "[FAIL] $$file formatting failed" && exit 1; \
      	fi; \
      	done;

.PHONY: check-format-juvix-files
check-format-juvix-files: juvix-bin
	@JUVIXFORMATFLAGS=--check ${MAKE} format-juvix-files

JUVIXEXAMPLEFILES=$(shell find ./docs \
	-type d \( -name ".juvix-build" \) -prune -o \
	-name "*.juvix" -print)

.PHONY: typecheck-juvix-examples
typecheck-juvix-examples: juvix-bin
	@for file in $(JUVIXEXAMPLEFILES); do \
		${JUVIXBIN} typecheck "$$file" $(JUVIXTYPECHECKFLAGS); \
		exit_code=$$?; \
		if [ $$exit_code -eq 0 ]; then \
			echo "[OK] $$file typechecks"; \
		else \
 			echo "[FAIL] Typecking failed for $$file" && exit 1; \
      	fi; \
	done
