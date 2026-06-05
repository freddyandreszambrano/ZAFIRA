# Repository Guidelines

## Project Structure & Module Organization

This is a Flutter mobile app named `zafira`. App code lives in `lib/`: `lib/main/` contains flavor entry points and shared startup, `lib/core/` holds constants, themes, database helpers, serialization, services, utilities, and flavor config, and `lib/modules/` contains shared module code as it grows. Platform code is in `android/` and `ios/`. Project guidance lives in `ai/`, especially `ai/rules/`.

New feature work should follow the documented feature-first layout under `lib/feature/{name}/` with `application/`, `data/`, `domain/`, and `view/` layers. Tests should mirror `lib/` under `test/`.

## Build, Test, and Development Commands

Use FVM commands per project convention:

- `fvm flutter pub get`: install Dart and Flutter dependencies.
- `fvm flutter analyze`: run static analysis using `analysis_options.yaml`.
- `fvm flutter test`: run all unit and widget tests.
- `fvm flutter test --coverage`: run tests and produce coverage data.
- `fvm flutter pub run build_runner build --delete-conflicting-outputs`: regenerate Freezed, JSON, and envied outputs after model or env changes.
- `fvm flutter run -t lib/main/main_dev.dart`: run the development flavor entry point.
- `fvm flutter build apk -t lib/main/main_prod.dart`: build an Android production APK.

## Coding Style & Naming Conventions

Follow `package:flutter_lints/flutter.yaml`. Use 2-space Dart indentation, files `snake_case.dart`, classes `PascalCase`, providers `camelCaseProvider`, services `PascalCaseService`, repository interfaces `INameRepository`, and use cases `NameUseCase`. Prefer `final`, explicit types over `dynamic`, named constructor parameters, and `lib/core/utils/logger.dart` instead of `print`.

Never edit generated `*.freezed.dart`, `*.g.dart`, or envied output manually.

## Testing Guidelines

The project uses `flutter_test`, `mocktail`, and `fake_async`. Place tests in `test/` mirroring the source path, for example `test/feature/auth/application/login_use_case_test.dart`. Write one `test()` per behavior. Service tests must mock Dio through the shared `test/helpers/http_test_dio.dart` utility when present, and no tests should hit real network services.

## Commit & Pull Request Guidelines

Recent history uses concise Conventional Commit style such as `docs: add Handoff document` and `feat(lib): add environment configuration`. Use `type(scope): summary` when practical, with lower-case types like `feat`, `fix`, `docs`, `test`, or `refactor`.

PRs should include a short purpose statement, linked issue or task, test results (`fvm flutter analyze`, `fvm flutter test`), and screenshots or screen recordings for UI changes. Mention generated-code updates explicitly.

## Agent-Specific Instructions

Before changing architecture, read the relevant `ai/rules/` files. Keep business logic out of widgets and controllers, route HTTP through `*Service` classes, return `Either<Exception, T>` for fallible async operations, and preserve the existing layer boundaries.
