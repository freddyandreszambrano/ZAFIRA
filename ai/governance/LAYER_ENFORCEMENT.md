# LAYER ENFORCEMENT RULES

## Allowed Dependency Direction (strict, one-way)

```
Widget → Controller → UseCase → IRepository ← Repository → Service → DioHttpClient
```

Each arrow means "may depend on / call". No reverse dependencies. No skipping layers.

---

## Forbidden Calls

| From       | To                  | Why Forbidden                                                 |
|------------|---------------------|---------------------------------------------------------------|
| Widget     | Service             | HTTP call from UI — skips error handling and state management |
| Widget     | Repository          | Bypasses controller and use case                              |
| Widget     | UseCase             | Bypasses controller — state never updated                     |
| Controller | Service             | Bypasses use case — no error wrapping, no DTO→Model mapping   |
| Controller | Repository          | Bypasses use case                                             |
| UseCase    | Controller          | Reverse dependency — circular reference                       |
| UseCase    | Concrete Repository | Must depend on `IXxx` interface, not implementation           |
| Service    | State / Controller  | Reverse dependency                                            |
| Service    | UseCase             | Reverse dependency                                            |

---

## Layer Responsibilities

### `domain/`

- Freezed data models only.
- Zero external dependencies (no Dio, no Riverpod, no Flutter imports).
- May have computed getters (derived properties) — no mutation, no I/O.

### `data/services/`

- HTTP calls only via `DioHttpClient`.
- Returns typed DTOs — parses `response.data` to DTO immediately.
- Logs request + response via `DebugLogger`.
- Never transforms business logic; never calls other services.

### `data/interfaces/`

- Abstract contracts (`abstract class IXxx`) — defines method signatures only.
- No implementation code.
- No imports from `view/` or `application/`.

### `data/repositories/`

- Implements `IXxx` interface.
- Delegates 100% to service — one-liner overrides are normal.
- No business logic, no data transformation.

### `application/` (use cases)

- Orchestrates one or more repository calls.
- Maps DTOs → Domain Models (the only layer that does this mapping).
- Returns `Either<Exception, T>` — never throws.
- Uses `ErrorExceptionHandler` mixin.
- No Flutter/UI imports.

### `view/controller/`

- Extends `StateNotifier<XxxState>`.
- Calls use case methods only.
- Mutates state exclusively via `copyWith`.
- No HTTP calls, no repository access, no DTO knowledge.
- Sets `isLoading: true` before async calls; clears in both `fold` branches.

### `view/state/`

- Plain Dart class — all fields `final`.
- `copyWith` method for immutable updates.
- No external imports; no logic.

### `view/widget/`

- Reads state via `ref.watch(xxxControllerProvider)`.
- Triggers actions via `ref.read(xxxControllerProvider.notifier).methodName()`.
- No business logic, no direct data fetching.

---

## Shared Infrastructure

| Location                              | Who may use it                           |
|---------------------------------------|------------------------------------------|
| `lib/modules/common/drivers/http/`    | Services only                            |
| `lib/modules/common/drivers/storage/` | Repositories, services, core services    |
| `lib/modules/common/exceptions/`      | Services, use cases, error handler mixin |
| `lib/modules/common/widget/`          | Any widget layer                         |
| `lib/core/utils/logger.dart`          | Any layer (for logging)                  |
| `lib/core/constants/`                 | Any layer (read-only constants)          |
| `lib/helpers/`                        | Feature widgets and controllers only     |
