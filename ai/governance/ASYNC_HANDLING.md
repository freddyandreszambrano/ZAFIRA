# ASYNC HANDLING RULES

## Standard Controller Pattern

Every async controller method follows this exact sequence:

```dart
Future<void> doSomething(params) async {
  // 1. Signal loading
  state = state.copyWith(isLoading: true);

  // 2. Await use case
  final result = await _useCase.doSomething(params);

  // 3. Fold both branches — always
  result.fold(
    (exception) => state = state.copyWith(
      isLoading: false,
      errorMessage: exception.toString(),
    ),
    (data) => state = state.copyWith(
      isLoading: false,
      data: data,
    ),
  );
}
```

---

## Rules

**No unhandled futures.**
Every `Future` must be `await`ed or have `.then`/`.catchError`. Fire-and-forget is forbidden unless
the result is explicitly irrelevant and errors are logged.

**Use `async/await` syntax.**
Do not use raw `.then()` chains for sequential logic. `.then()` is acceptable for non-sequential,
non-blocking callbacks only.

**`ErrorExceptionHandler.handlerApiExceptions` is the single catch point for service calls.**
Do not add `try/catch` blocks inside repositories or services — let exceptions propagate to the use
case's `handlerApiExceptions` wrapper.

**`Either` must always be folded.**
Never call `.right` without checking `isRight()` first. Never ignore the left side.

```dart
// Correct
result.fold(
  (err) => handleError(err),
  (data) => handleSuccess(data),
);

// Forbidden
final data = result.right; // throws if left
```

---

## Parallel Requests

Use `Future.wait` for independent concurrent calls:

```dart
final results = await Future.wait([
  _useCase.getModules(),
  _useCase.getGroups(),
]);
```

Use sequential `await` for dependent calls:

```dart
final user = await _useCase.login(credentials);
final modules = await user.fold(
  (err) => Either.left(err),
  (u) => _useCase.getModulesForUser(u.id),
);
```

---

## Streams & Subscriptions

- For real-time state, use Riverpod `StreamProvider` or subscribe in `StateNotifier`.
- Always cancel stream subscriptions in `dispose()`.
- Never leak subscriptions — missing `dispose` cancellation is a bug.

---

## Heavy Computation

- PDF generation, image processing, and large data transformations: run in a Dart isolate if they
  block the UI thread.
- Do not block the main isolate for >16ms with synchronous work.

---

## Timeout Behavior

- Dio connect and receive timeouts are 30 seconds (configured globally in `DioHttpClient`).
- Do not override timeouts per request unless there is a documented reason.
- `DioException` with type `connectionTimeout` or `receiveTimeout` is handled by
  `ErrorExceptionHandler` → `ServerException`.
