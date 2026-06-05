# PATTERNS — Zafira

## 1. Service Layer

Services make raw HTTP calls via `DioHttpClient`. They accept typed params, log the call, and return
a parsed DTO.

```dart
class ModuleService {
  final DioHttpClient remoteDataSource;

  Future<ModuleDTO> getModule(int id) async {
    final url = "/admin/api_v1/module/$id";
    DebugLogger(runtimeType).request(url, null);
    final response = await remoteDataSource().get(url);
    DebugLogger(runtimeType).response(url, [response.statusCode, response.data]);
    return ModuleDTO.fromJson(response.data);
  }
}
```

## 2. Repository Pattern

Repositories implement abstract interfaces (`IXxx`). They delegate entirely to the service — no
logic added.

```dart
abstract class IModule {
  Future<List<ModuleDTO>> getModules();
  Future<ModuleDTO> getModule(int id);
}

class ModuleRepository implements IModule {
  final ModuleService _remoteDataSource;

  @override
  Future<ModuleDTO> getModule(int id) =>
      _remoteDataSource.getModule(id);
}
```

## 3. Use Case Pattern

Use cases use `ErrorExceptionHandler` mixin and wrap every call in `handlerApiExceptions`. They map
DTOs to domain models and return `Either`.

```dart
class ModuleUseCase with ErrorExceptionHandler {
  final IModule _moduleRepository;

  Future<Either<Exception, List<ModuleModel>>> getModules() async {
    const methodName = "GET_MODULES";
    DebugLogger(runtimeType).methodInit(methodName);
    return handlerApiExceptions(
      () async {
        final data = await _moduleRepository.getModules();
        return data.map((e) => ModuleModel.fromDTO(e)).toList();
      },
      methodName,
      runtimeType,
    );
  }
}
```

## 4. Controller + State Pattern

Controllers extend `StateNotifier<XxxState>`. State is a plain Dart class with `copyWith`. Loading
is set before the call and cleared in both branches.

```dart
final moduleControllerProvider =
  StateNotifierProvider.autoDispose<ModuleController, ModuleState>(
    (ref) => ModuleController(ModuleUseCase(ref.watch(moduleRepositoryProvider))));

class ModuleController extends StateNotifier<ModuleState> {
  final ModuleUseCase _moduleUseCase;

  Future<void> getModules() async {
    state = state.copyWith(isLoading: true);
    final result = await _moduleUseCase.getModules();
    result.fold(
      (err) => state = state.copyWith(isLoading: false),
      (data) => state = state.copyWith(isLoading: false, modules: data),
    );
  }
}

class ModuleState {
  final bool isLoading;
  final List<ModuleModel> modules;

  ModuleState({this.isLoading = false, this.modules = const []});

  ModuleState copyWith({bool? isLoading, List<ModuleModel>? modules}) =>
    ModuleState(
      isLoading: isLoading ?? this.isLoading,
      modules: modules ?? this.modules,
    );
}
```

## 5. Domain Models (Freezed)

All domain models use `@freezed` with JSON serialization. Every field has a `@Default` value.

```dart
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'full_name') @Default('') String fullName,
    @Default(0) int id,
    @Default('') String email,
    @Default('') String role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

## 6. HTTP Client Setup

Single `DioHttpClient` instance via Riverpod. An interceptor injects headers on every request:

```dart
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) async {
    options.headers['Authorization'] =
        await localDataSource.getItem(AppStrings.keyTokenJwt);
    options.headers['app-source'] =
        kIsWeb ? 'zafira-web' : 'zafira-app';
    options.headers['app-version'] = Flavor.projectVersion;
    return handler.next(options);
  },
));
```

Timeouts: 30s connect, 30s receive.

## 7. Error Handling

`ErrorExceptionHandler` mixin wraps all use case calls via `handlerApiExceptions`:

- `DioException` → `ServerException` (status code + response body)
- Any other → `RegularException`
- Returns `Either<Exception, T>` — never throws

Controllers always `fold` the Either to handle both branches.

## 8. Logging Pattern

Three logger classes used at each layer:

```dart
DebugLogger(runtimeType).request(url, payload)   // before HTTP call
DebugLogger(runtimeType).response(url, data)      // after HTTP call
DebugLogger(runtimeType).methodInit(methodName)   // start of use case method
ErrorLogger(runtimeType).error(e, stackTrace)     // on caught exception
```

## 9. Provider Declaration Convention

```dart
// Service — plain Provider, singleton lifecycle
final authServiceProvider = Provider<AuthService>(...);

// Repository — plain Provider, singleton lifecycle
final authRepositoryProvider = Provider<IAuth>(...);

// Controller — autoDispose, freed when screen pops
final authControllerProvider =
  StateNotifierProvider.autoDispose<AuthController, AuthState>(...);
```

Providers are top-level constants — never inside classes.

## 10. ResponseStatus Enum

For operations with discrete phases, combine with `ResponseStatus`:

```dart
enum ResponseStatus { initial, loading, success, error }

class AuthState {
  final ResponseStatus status;
  final UserModel? user;
  final String? errorMessage;
}
```

## 11. Multipart Upload Pattern

Used for user avatars, document attachments, signature captures:

```dart
final formData = FormData.fromMap({
  "first_name": firstName,
  "last_name": lastName,
});
if (image != null) {
  formData.files.add(MapEntry(
    "image",
    await MultipartFile.fromFile(image.path),
  ));
}
await remoteDataSource().patch(url, data: formData);
```

## 12. Local Database Pattern

SQLite via `SqlHelper` and `SqlDAO`. Queries defined in `SqlQueries` constants. `DatabaseManager`
manages the single DB instance. Used for offline data persistence.

## 13. Flavor-Aware Configuration

Runtime environment selected via `FlavorsConfig`:

```dart
class Flavor {
  static String get server => _instance.baseUrl;
  static String get googleMapsKey => kIsWeb ? _instance.googleMapsKeyWeb : _instance.googleMapsKeyMobile;
}
```

Flavor is set at app startup based on the entry point (`main_dev.dart` / `main_prod.dart`).
