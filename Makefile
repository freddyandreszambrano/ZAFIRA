.PHONY: version clean pub-get build-env analyze test coverage run-dev build-apk

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

run-dev:
	fvm flutter run -t lib/main/main_dev.dart

build-apk:
	fvm flutter build apk -t lib/main/main_prod.dart
