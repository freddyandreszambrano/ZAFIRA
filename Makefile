.PHONY: help version clean pub-get build-env analyze test coverage ci-local run-dev \
	build-apk-debug build-apk build-aab shorebird-release-aab \
	shorebird-release-apk shorebird-patch check-shorebird

flavor ?= prod
target := lib/main/main_$(flavor).dart
symbols_dir := build/symbols/$(flavor)
release_version ?= latest

ifeq ($(OS),Windows_NT)
check-shorebird:
	@if not exist shorebird.yaml (echo Falta shorebird.yaml. Ejecuta: shorebird init --force & exit /b 1)
else
check-shorebird:
	@test -f shorebird.yaml || (echo "Falta shorebird.yaml. Ejecuta: shorebird init --force" >&2; exit 1)
endif

help:
	@echo "make analyze | test | ci-local"
	@echo "make run-dev"
	@echo "make build-apk-debug flavor=dev"
	@echo "make build-apk flavor=prod        # APK release firmado"
	@echo "make build-aab flavor=prod        # AAB para Google Play"
	@echo "make shorebird-release-aab flavor=prod"
	@echo "make shorebird-release-apk flavor=dev"
	@echo "make shorebird-patch flavor=prod release_version=1.0.0+1"

version:
	fvm flutter --version

clean:
	fvm flutter clean

pub-get:
	fvm flutter pub get

build-env: version clean pub-get
	fvm flutter pub run build_runner build --delete-conflicting-outputs

analyze:
	fvm flutter analyze

test:
	fvm flutter test

coverage:
	fvm flutter test --coverage

ci-local: pub-get analyze test
	fvm flutter build apk --debug -t lib/main/main_dev.dart --flavor dev
	fvm flutter build apk --debug -t lib/main/main_prod.dart --flavor prod

run-dev:
	fvm flutter run -t lib/main/main_dev.dart --flavor dev

build-apk-debug:
	fvm flutter build apk --debug --target $(target) --flavor $(flavor)

build-apk:
	fvm flutter build apk --release --target $(target) --flavor $(flavor) --obfuscate --split-debug-info=$(symbols_dir)

build-aab:
	fvm flutter build appbundle --release --target $(target) --flavor $(flavor) --obfuscate --split-debug-info=$(symbols_dir)

shorebird-release-aab: check-shorebird
	shorebird release android --artifact=aab --target $(target) --flavor $(flavor) --obfuscate --split-debug-info=$(symbols_dir)

shorebird-release-apk: check-shorebird
	shorebird release android --artifact=apk --target $(target) --flavor $(flavor) --obfuscate --split-debug-info=$(symbols_dir)

shorebird-patch: check-shorebird
	shorebird patch android --target $(target) --flavor $(flavor) --release-version $(release_version)
