# CONVENTIONS.md — zafira

> Absolute rules, forbidden patterns, project identity, load order for `ai/rules/`, `ai/context/`.
> Complemented by `ai/RULES.md`, `ai/ARCHITECTURE.md`, `ai/PATTERNS.md`.

## Load Order

Before writing any code:

1. `ai/CLAUDE.md` (this file)
2. `ai/rules/architecture.md`
3. `ai/rules/code-style.md`
4. `ai/rules/api-contracts.md`
5. `ai/rules/testing.md`
6. `ai/context/mobile.md`
7. `ai/context/backend.md`
8. `ai/context/infra.md`

## Project Identity

- **App**: zafira (Flutter multiplatform — administrative dashboard with dynamic modules)
- **Flutter**: managed via FVM — always `fvm flutter`, never bare `flutter`
- **Flavors**: `dev`, `stg`, `prod`
- **State**: Riverpod (`StateNotifierProvider`)
- **HTTP**: Dio (centralized)
- **Navigation**: go_router
- **Error handling**: `either_dart` — `Either<Exception, T>`
- **Models**: `freezed` + `json_serializable`

## Absolute Rules

- Feature-first structure under `lib/feature/`
- No business logic in widgets or controllers
- All HTTP calls via a `*Service` class
- Controllers call use cases only — never services or repositories directly
- `autoDispose` on all screen-level controllers
- Tests mock Dio via `test/helpers/http_test_dio.dart`
- Never edit `*.freezed.dart` or `*.g.dart` manually

## Forbidden

- Logic in `Widget.build` or `initState`
- `dio.get/post` outside a `*Service` class
- Scattered `try/catch` in controllers
- Routes added outside `lib/modules/app_module.dart`
- New architecture patterns not described in this `/ai/` folder
