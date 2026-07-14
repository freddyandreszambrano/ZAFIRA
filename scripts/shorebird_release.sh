#!/bin/sh
# Wrapper para "shorebird release android". Existe porque GNU Make en Windows
# arma mal la linea de comando cuando el recipe de shorebird tiene muchos
# flags (falla con "Missing argument for --flavor"); invocar un script real
# desde el Makefile evita ese problema de quoting.
set -e

artifact="$1"
flavor="$2"
flutter_version="$3"

target="lib/main/main_${flavor}.dart"
symbols_dir="build/symbols/${flavor}"

shorebird release android \
  --flutter-version="${flutter_version}" \
  --artifact="${artifact}" \
  --target="${target}" \
  --flavor="${flavor}" \
  --obfuscate \
  --split-debug-info="${symbols_dir}"
