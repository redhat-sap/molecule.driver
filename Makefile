#
# Copyright 2022 Red Hat, Project Atmosphere
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program.
# If not, see <https://www.gnu.org/licenses/>.

VERSION=0.2.0

.DEFAULT_GOAL:=help


.PHONY: help
help: ## Display this help
	@echo Makefile for molecule.driver project
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

# Developer convenience targets

build:  ## Build ansible-galaxy collection
	ansible-galaxy collection build --force

install: build
	ansible-galaxy collection install --force molecule-driver-${VERSION}.tar.gz

clean: ## Remove all auto-generated files
	rm -rf ~/.ansible/collections/ansible_collections/molecule/driver

.PHONY: yamllint 
yamllint: ## Run linter for YAML files
	yamllint .

.PHONY: ansible-lint 
ansible-lint: ## Run ansible-lint
	ansible-lint roles/

.PHONY: lint
lint: ansible-lint yamllint ## Execute yamllint and ansible-lint target

.PHONY: tests
tests: ## Run molecule tests
	./hack/tests.sh

.PHONY: install-requirements-dev ## Install python requirements
install-requirements-dev:
	pip install -r requirements-dev.txt

