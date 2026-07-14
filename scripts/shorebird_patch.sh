#!/bin/sh
# Wrapper para "shorebird patch android". Ver shorebird_release.sh: evita que
# GNU Make en Windows arme mal la linea de comando con varios flags.
set -e

flavor="$1"
release_version="$2"

target="lib/main/main_${flavor}.dart"

shorebird patch android \
  --target="${target}" \
  --flavor="${flavor}" \
  --release-version="${release_version}"
