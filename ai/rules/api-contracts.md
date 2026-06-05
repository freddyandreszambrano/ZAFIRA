# API Contracts

## Mandatory Headers

Every HTTP request MUST include these headers — no exceptions:

| Header        | Value                              | Source                                 |
|---------------|------------------------------------|----------------------------------------|
| `app-version` | Current app semver (e.g. `1.0.0`)  | `lib/core/flavors/flavors_config.dart` |

Missing either header = the request is non-compliant and must be rejected in code review.

## Dio Setup

Centralized Dio instance configured in `lib/core/services/` (or `lib/helpers/`).
Interceptors are the only place allowed to inject headers globally.

```dart
// Correct: header injection via interceptor
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['app-version'] = AppVersion.current;
    handler.next(options);
  }
}
```

Never add headers ad-hoc inside individual service methods.

## Service Contract

```dart
class AuthService {
  AuthService(this._dio);
  final Dio _dio;

  Future<Either<Exception, UserDto>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      return Right(UserDto.fromJson(response.data));
    } on DioException catch (e) {
      return Left(Exception(e.message));
    }
  }
}
```

## Response Handling

- `2xx` → `Right(model)`
- `4xx` / `5xx` / network error → `Left(Exception(...))`
- Never parse raw `response.data` outside a `*Dto` or `*Model` — always deserialize immediately

## Base URLs

Defined per flavor in `lib/core/flavors/flavors_config.dart`:

```dart
static String get baseUrl {
  switch (flavor) {
    case Flavor.dev: return Env.baseUrlDev;
    case Flavor.stg: return Env.baseUrlStg;
    case Flavor.prod: return Env.baseUrlProd;
  }
}
```

Never hardcode URLs in service files.

## Versioning

API path versioning (`/v1/`, `/v2/`) is managed in the base URL or per-service path.
Do not version via headers.
