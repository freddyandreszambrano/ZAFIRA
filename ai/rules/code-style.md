# Code Style Rules

## Dart / Flutter

- Max line length: 120 characters (matches `analysis_options.yaml`)
- Use `final` everywhere possible — `var` only when reassigned
- Named parameters for constructors with more than 2 args
- No `dynamic` — use explicit types or generics
- No `print` — use the logging utility in `lib/core/`

## Naming

| Artifact             | Convention                      | Example                   |
|----------------------|---------------------------------|---------------------------|
| File                 | `snake_case.dart`               | `login_controller.dart`   |
| Class                | `PascalCase`                    | `LoginController`         |
| Provider             | `camelCase` + `Provider` suffix | `loginControllerProvider` |
| State class          | `PascalCase` + `State` suffix   | `LoginState`              |
| Use case             | `PascalCase` + `UseCase` suffix | `LoginUseCase`            |
| Repository interface | `I` prefix + `PascalCase`       | `IAuthRepository`         |
| Service              | `PascalCase` + `Service` suffix | `AuthService`             |

## Models (Freezed)

```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    @JsonKey(name: 'username') required String username,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

- Never use `Map<String, dynamic>` as a domain type — always wrap in a Freezed model
- All JSON key mappings use `@JsonKey(name: '...')`
- Run `fvm flutter pub run build_runner build --delete-conflicting-outputs` after any model change

## State Classes

```dart
@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isLoading,
    String? errorMessage,
    User? user,
  }) = _LoginState;
}
```

## Controllers

```dart
class LoginController extends StateNotifier<LoginState> {
  LoginController(this._loginUseCase) : super(const LoginState());

  static final provider = StateNotifierProvider.autoDispose<LoginController, LoginState>(
    (ref) => LoginController(ref.read(loginUseCaseProvider)),
  );

  final LoginUseCase _loginUseCase;

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _loginUseCase(username: username, password: password);
    result.fold(
      (error) => state = state.copyWith(isLoading: false, errorMessage: error.toString()),
      (user) => state = state.copyWith(isLoading: false, user: user),
    );
  }
}
```

## Either Pattern

- Services return `Either<Exception, T>` — never throw
- Controllers consume with `.fold(onError, onSuccess)`
- No bare `try/catch` in controllers — wrap in service and return `Left(exception)`

## Async

- All async operations return `Future<Either<Exception, T>>`
- No `Future<void>` for operations that can fail
- Use `await` — no `.then()` chaining
- Structured error propagation via `Either`, not exception bubbling
