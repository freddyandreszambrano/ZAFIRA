# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Zafira is a multiplatform Flutter app (Android, iOS, Web) on **Clean Architecture + Riverpod + Dio + Freezed + go_router + either_dart**.

## Commands

All Flutter commands run through **FVM** (Flutter pinned to `3.41.9` in `.fvmrc`). The `Makefile` wraps the common ones:

- `make pub-get` — `fvm flutter pub get`
- `make build-env` — clean + pub get + regenerate code (`build_runner build --delete-conflicting-outputs`). Run this after editing any Freezed model, JSON model, or `lib/env/env.dart`.
- `make analyze` — `fvm flutter analyze` (static analysis; CI gate)
- `make test` / `make coverage` — run all tests / with coverage
- `make run-dev` — `fvm flutter run -t lib/main/main_dev.dart --flavor dev`
- `make build-apk` — `fvm flutter build apk -t lib/main/main_prod.dart --flavor prod`

Run a single test: `fvm flutter test test/feature/auth/application/login_use_case_test.dart`
Run tests matching a name: `fvm flutter test --plain-name "returns token"`

Regenerate codegen directly: `fvm flutter pub run build_runner build --delete-conflicting-outputs`

CI (`.github/workflows/ci.yml`) runs analyze + test on every PR/push to `main`/`develop`, then a dry-run APK build on push. Both `fvm flutter analyze` and `fvm flutter test` must pass.

## Architecture

### Layered flow (strict, one direction)

```
view (Widget → Controller) → application (UseCase) → data (Repository interface → impl → Service) → domain (Freezed models)
```

- **Widget** reads state via `ref.watch`, triggers actions via `ref.read`. No business logic, no service/usecase calls.
- **Controller** extends `StateNotifier<*State>`, calls **UseCases only** (never repositories/services), mutates state via `copyWith`. Screen-level controllers use `StateNotifierProvider.autoDispose` (except auth/session). Providers are top-level constants.
- **UseCase** holds the **only** business logic. Always returns `Either<Exception, T>` — never `throw`. Maps DTO (`data/`) → domain model (`domain/`).
- **Repository** implements an `I*Repository` interface from `data/interfaces/`; delegates to the Service, no HTTP logic.
- **Service** executes HTTP via the injected Dio client only. No state, no `catch` (errors propagate to the error handler). URL paths are constants in the service file.

Controllers always `.fold(left, right)` with `isLoading: false` in **both** branches.

### Feature layout (mandatory)

Each feature lives under `lib/feature/{name}/` with `application/`, `data/{interfaces,repositories,services}/`, `domain/`, `view/{controller,state,widget}/`. Features must not import each other's `data/` or `application/`. Shared cross-feature code goes in `lib/modules/` or `lib/core/`.

### Key shared infrastructure

- **HTTP**: Never use Dio directly in features. Get the client via `ref.watch(dioHttpClientProvider)` (`lib/modules/common/drivers/http/dio_http_client.dart`). It injects the JWT `Authorization` header, `app-source`/`app-version` headers, and the flavor base URL on every request.
- **Flavors/env**: Entry points are `lib/main/main_dev.dart` and `main_prod.dart`; shared startup in `lib/main/common_main.dart`; flavor logic in `lib/core/flavors/flavors_config.dart` (`Flavor.server`, `Flavor.isProd`, etc.). Base URLs come from `.env` via `envied` → generated `lib/env/env.g.dart`. `lib/main.dart` defaults to the DEV flavor.
- **Storage**: secure storage (tokens) via `secureLocalDataSourceProvider`; `shared_preferences` and `sqflite` (under `lib/core/database/`) for the rest.

### Theming (enforced — no hardcoded values)

- Colors: `context.appColors.<token>` — never `Color(0xFF...)`, `Colors.*`, or `MaterialColor`.
- Text: `context.typography.<style>` — never literal `TextStyle(...)`.
- Helpers live in `lib/core/helpers/` (`app_colors.dart`, `app_typography.dart`, `context_helper.dart`).
- A Screen must handle all 4 states (loading / empty / error / success) with an exhaustive `switch`.

## Testing

Mirror `lib/` paths under `test/`, one `test()` per behavior. Use **mocktail** (not mockito) with `registerFallbackValue` for custom types. Service tests must build Dio via the helpers in `test/helpers/http_test_dio.dart` (`stubDio`, `stubDioOk`, `stubDioError`) — never mock Dio by hand and never hit the network. Controller tests use a `ProviderContainer` with `overrides` + `addTearDown(c.dispose)`. No `print(...)` in tests.

## Conventions

- Never edit generated `*.freezed.dart`, `*.g.dart`, or envied output by hand — regenerate instead.
- Domain models use Freezed with `@Default` on every field; `@JsonKey(name: 'snake_case')` when the API field name differs.
- Trailing commas always; constructors first in a class; prefer relative imports within a feature. Widget over ~200 LOC → split into private sub-widgets.
- Navigation through `go_router` only — no direct `Navigator.push`. No `setState` in a `ConsumerWidget`. No hardcoded UI strings.
- Conventional Commits: `type(scope): summary` (`feat`, `fix`, `docs`, `test`, `refactor`).

## Deeper docs

The `ai/` directory holds the authoritative detailed rules — consult before changing architecture: `ai/rules/{architecture,api-contracts,code-style,testing,widget-design}.md`, plus `ai/PATTERNS.md` (canonical per-layer code), `ai/STACK.md` (dependency inventory), `ai/design-system.md` (mobile UI tokens), and `ai/HANDOFF.md` (current project state). Start from `ai/README.md` for the load order. `AGENTS.md` and `.github/copilot-instructions.md` summarize the same layer/error/state rules.
