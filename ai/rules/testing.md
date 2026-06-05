# Testing Rules

## Test Structure

Tests mirror `lib/` under `test/`:

```
test/
├── core/
├── feature/{name}/
│   ├── application/          # Use case tests
│   ├── data/services/        # Service tests
│   └── view/controller/      # Controller tests
├── helpers/{name}/
│   ├── application/
│   └── view/controller/
├── helpers/data/services/
├── helpers/http_test_dio.dart  ← shared Dio mock utility
└── widget_test.dart
```

## Mandatory: Dio Mocking

All service tests MUST use `test/helpers/http_test_dio.dart`.
Never mock Dio manually per test — use the shared utility.

```dart
void main() {
  late AuthService service;
  late MockDio mockDio;

  setUp(() {
    mockDio = setupMockDio();  // from http_test_dio.dart
    service = AuthService(mockDio);
  });

  test('login returns Right(UserDto) on 200', () async {
    when(mockDio.post(any, data: anyNamed('data')))
        .thenAnswer((_) async => Response(
              data: {'id': '1', 'name': 'Test'},
              statusCode: 200,
              requestOptions: RequestOptions(path: ''),
            ));

    final result = await service.login(username: 'admin', password: 'pass');
    expect(result.isRight(), true);
  });
}
```

## Layer-by-Layer Testing

### Service tests

- Mock Dio responses
- Assert `Right(model)` on success
- Assert `Left(exception)` on `DioException`

### Use case tests

- Mock repository via interface (`I*Repository`)
- Assert orchestration logic
- Test both success and failure paths

### Controller tests

- Mock use case
- Assert state transitions: initial → loading → success/error
- Use `StateNotifier` test helpers

## Rules

- Run `fvm flutter pub run build_runner build` before tests if models changed
- Run all tests: `fvm flutter test`
- Run with coverage: `fvm flutter test --coverage`
- Run specific feature: `fvm flutter test test/feature/auth/`
- One `test()` per behavior — not per method
- No integration-style tests that hit real network
- No `print` in tests
