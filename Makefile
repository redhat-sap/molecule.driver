build:
	ansible-galaxy collection build --force
install: build
	ansible-galaxy collection install --force molecule-driver-0.1.0.tar.gz
remove:
	rm -rf /Users/ksatarin/.ansible/collections/ansible_collections/molecule/drive