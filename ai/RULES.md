# RULES — Zafira

Project-specific rules derived from actual code. These override generic Flutter conventions.

---

## 1. Layer Rules

**Never skip layers.**

- Widgets interact with Controller only via `ref.watch` / `ref.read`.
- Controllers call UseCases only — never Services or Repositories.
- UseCases call Repository interfaces (`IXxx`) only — never concrete implementations.
- Services use `DioHttpClient` only — never access state or controllers.
- Business logic lives in use cases, not in repositories or controllers.

**No business logic in widgets.** Derivations and transformations belong in UseCases or Controllers.

---

## 2. Error Handling Rules

**Use cases always return `Either<Exception, T>`.**

- Never throw from a use case.
- Never catch exceptions at the service layer — let them propagate to `ErrorExceptionHandler`.
- Controllers always `fold` the Either. Never call `.right`/`.left` without folding.

---

## 3. State Rules

**Use `copyWith` for every state mutation in a Controller.**

- Never replace the entire state object directly.
- Always set `isLoading: false` in both success and error branches of `fold`.

**Use `autoDispose` on all screen-level controllers.**

- Shared persistent state (e.g., auth session) may omit `autoDispose`.

---

## 4. Model Rules

**All domain models use Freezed.**

- Every field must have a `@Default` value.
- Use `@JsonKey(name: 'snake_case')` when the API field name differs from the Dart name.
- DTOs live in `data/`; Domain Models live in `domain/`.
- UseCases map DTOs → Domain Models. DTOs never reach the view layer.

**Never edit generated files manually:**

- `*.freezed.dart`, `*.g.dart`, `env.g.dart`
- After model changes: `flutter pub run build_runner build --delete-conflicting-outputs`

---

## 5. Provider Rules

- Services and repositories: plain `Provider` (no autoDispose) — singleton lifecycle.
- Controllers: `StateNotifierProvider.autoDispose`.
- Providers are top-level constants — never declared inside classes.

---

## 6. HTTP Rules

**Never construct Dio instances directly in features.**
Always use `DioHttpClient` via `ref.watch(dioHttpClientProvider)`.

**URL paths are string constants inside service files.**
Never inline URL strings in controllers, use cases, or repositories.

**Log every request and response via `DebugLogger`.**

---

## 7. Logging Rules

Use the structured loggers consistently at each layer:

```
DebugLogger(runtimeType).request(url, payload)   — before HTTP call
DebugLogger(runtimeType).response(url, data)      — after HTTP call
DebugLogger(runtimeType).methodInit(methodName)   — start of use case method
ErrorLogger(runtimeType).error(e, stack)          — on caught exception
```

Never use `print()` or `debugPrint()` in production code.

---

## 8. Environment & Flavor Rules

**Never hardcode base URLs, API keys, or credentials.**

- URLs and flavor-specific keys → `lib/core/flavors/flavors_config.dart`
- Build secrets → `.env` file (read at compile time by `envied`)
- After `.env` changes → re-run `build_runner`

**Always use `fvm flutter` instead of bare `flutter`** to respect the pinned Flutter version.

---

## 9. Routing Rules

- All routes declared in `lib/modules/app_module.dart`.
- Route name constants are `static` fields on the screen class (e.g., `LoginScreen.routeName`).
- Never use `Navigator.push` directly — use GoRouter context extension (`context.go`,
  `context.push`).

---

## 10. Testing Rules

**Mirror source structure in `test/`.**

```
lib/feature/auth/data/services/auth_service.dart
→ test/feature/auth/data/services/auth_service_test.dart
```

**Mock Dio via `test/helpers/http_test_dio.dart`** — never mock `DioHttpClient` directly.

**Test each layer separately:**

- Service test: mock HTTP response → assert DTO parsing
- UseCase test: mock repository → assert `Either` result and state
- Controller test: mock use case → assert state transitions

---

## 11. Code Generation Rules

Run after modifying models, routes, or `.env`:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Committed generated files (`*.freezed.dart`, `*.g.dart`) must stay in sync with source — never
commit a source change without regenerating.

---

## 12. Commit Convention

```
<type>: <subject>
```

Types: `feat`, `add`, `update`, `refactor`, `delete`, `fix`, `docs`, `style`, `test`

Update `CHANGELOG.md` with version and release date before each release.

---

## 13. Inconsistencies to Watch

- Some state classes use `ResponseStatus` enum; others use plain `isLoading: bool`. No single
  standard — follow the existing pattern within the feature you're modifying.
- A controller may compose multiple use cases (e.g., `auth` could combine `SessionUseCase`,
  `TokenUseCase`, `ProfileUseCase`). Others stick to a single use case. Both patterns coexist.
