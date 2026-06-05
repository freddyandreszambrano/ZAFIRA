# GLOBAL RULES — Governance

Cross-cutting rules that apply to all layers and all platforms in this workspace.

---

## Dart / Flutter

- **Null safety is required.** Avoid the `!` operator except where null is provably impossible.
  Prefer `??`, `?.`, or explicit null checks.
- **No `print()` or `debugPrint()` in production code.** Use the structured logger (`DebugLogger`,
  `ErrorLogger`).
- **No `setState` in production code.** Riverpod is the state management standard.
- **No dead code.** No commented-out blocks, no unused imports, no unreachable branches.
- **Generated files are never edited manually.** `*.freezed.dart`, `*.g.dart`, `env.g.dart` are
  outputs — re-run `build_runner` instead.

## Error Handling

- Every async operation that can fail must produce an observable outcome.
- Use `Either<Exception, T>` at the use-case boundary — never throw across layer boundaries.
- HTTP errors are converted to typed exceptions (`ServerException`, `RegularException`) before
  reaching the controller.
- Log every caught exception with `ErrorLogger` including the stack trace.

## Security

- No hardcoded secrets, credentials, API keys, or base URLs in source code.
- Credentials are compile-time injected via `envied` from a `.env` file that is not committed.
- JWT tokens are stored in `FlutterSecureStorage`, not `SharedPreferences`.
- Authentication headers are injected at the HTTP interceptor level — never per request.

## API

- All HTTP calls go through `DioHttpClient` — never construct `Dio` instances ad hoc.
- Auth headers, platform source, and app version are always present (injected by interceptor).
- URL path strings are constants defined in the service file.

## Code Style

- Dart naming: `camelCase` for variables/methods, `PascalCase` for classes, `snake_case` for file
  names.
- `@Default` on every Freezed field — no nullable fields without a reason.
- `@JsonKey(name: 'snake_case')` on every Freezed field whose API name differs from its Dart name.
- `autoDispose` on screen-scoped controllers; omit for global session state.

## Testing

- Tests mirror the source directory structure under `test/`.
- Each layer tested independently: service → use case → controller.
- Dio is mocked via the shared `test/helpers/http_test_dio.dart` utility.
- No tests that mock the database — use the real `sqflite` in-memory setup if needed.

## Versioning & Releases

- Commit format: `<type>: <subject>` (types: feat, add, update, refactor, delete, fix, docs, style,
  test).
- `CHANGELOG.md` updated before every release with version and date.
- Flutter version pinned via FVM — always use `fvm flutter`, never bare `flutter`.
