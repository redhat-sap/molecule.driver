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

build:
	ansible-galaxy collection build --force
install: build
	ansible-galaxy collection install --force molecule-driver-0.1.0.tar.gz
remove:
	rm -rf /Users/ksatarin/.ansible/collections/ansible_collections/molecule/drive
lint:
	ansible-lint .
	yamllint .

.PHONY: tests
tests:
	./hack/tests.sh