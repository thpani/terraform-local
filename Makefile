VENV_DIR ?= .venv
VENV_RUN = . $(VENV_DIR)/bin/activate
PIP_CMD ?= pip

usage:        ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:      ## Install dependencies in local virtualenv folder
	(test `which virtualenv` || $(PIP_CMD) install --user virtualenv) && \
		(test -e $(VENV_DIR) || virtualenv $(VENV_OPTS) $(VENV_DIR)) && \
		($(VENV_RUN); $(PIP_CMD) install -e .)

publish:      ## Publish the library to the central PyPi repository
	# build and upload archive
	($(VENV_RUN) && pip install setuptools && ./setup.py sdist && twine upload dist/*)

lint:         ## Run code linter
	flake8 bin/tflocal --ignore=E501,W503

clean:        ## Clean up
	rm -rf $(VENV_DIR)

.PHONY: clean publish install usage lint
