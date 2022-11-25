#!/usr/bin/env bash
set -eu

TESTS=tests

for f in "$TESTS"/molecule/*; do
    if [ -d "$f" ]; then
        cd "$TESTS"/molecule
        molecule test -s $(basename "$f")
        cd -
    fi
done