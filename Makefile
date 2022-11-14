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

VERSION=0.1.0

.PHONY: help
help:
	@echo Available targets:
	@fgrep "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sort

# Developer convenience targets

build:  ## Build ansible-galaxy collection
	ansible-galaxy collection build --force

install: build
	ansible-galaxy collection install --force molecule-driver-${VERSION}.tar.gz

clean: ## Remove all auto-generated files
	rm -rf ~/.ansible/collections/ansible_collections/molecule/driver

.PHONY: yamllint
yamllint:
	yamllint .

.PHONY: ansible-lint
ansible-lint:
	ansible-lint roles/

.PHONY: lint
lint: ansible-lint yamllint

.PHONY: tests
tests:
	./hack/tests.sh
