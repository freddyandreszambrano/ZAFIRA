# API STANDARDS

## Request Headers (auto-injected by DioHttpClient interceptor)

| Header          | Value                              | Source                                               |
|-----------------|------------------------------------|------------------------------------------------------|
| `Authorization` | JWT token                          | `FlutterSecureStorage` key: `AppStrings.keyTokenJwt` |
| `app-source`    | `zafira-web` or `zafira-app`       | `kIsWeb` platform check                              |
| `app-version`   | Current app version string         | `Flavor.projectVersion`                              |

Headers must never be added manually per request — the interceptor handles all of them.

## Base URL

Selected at compile time via `FlavorsConfig`:

- **Dev:** defined in `lib/core/flavors/flavors_config.dart` dev block
- **Prod:** defined in `lib/core/flavors/flavors_config.dart` prod block

Never hardcode base URLs. Use `Flavor.server`.

## Timeouts

| Type            | Value      |
|-----------------|------------|
| Connect timeout | 30 seconds |
| Receive timeout | 30 seconds |

## URL Path Convention

```
/admin/api_v1/{resource}/{action}
```

- Resources in `snake_case`
- Actions as verbs or descriptors: `module`, `change-state`, `assign-permission`
- Version embedded in path: `api_v1`

## HTTP Methods

| Operation               | Method  |
|-------------------------|---------|
| Fetch list or item      | `GET`   |
| Create resource         | `POST`  |
| Update profile/resource | `PATCH` |
| Full replace            | `PUT`   |

## Response Handling

- Parse response immediately in the service layer via typed DTOs: `XxxDTO.fromJson(response.data)`.
- Never pass raw `response.data` (dynamic) to a use case or controller.
- Status code 201 for creation success (check explicitly where needed).

## Error Responses

| Error type                  | Converted to                        |
|-----------------------------|-------------------------------------|
| `DioException` (HTTP error) | `ServerException(statusCode, body)` |
| Any other exception         | `RegularException(message)`         |

Conversion happens in `ErrorExceptionHandler.handlerApiExceptions`. Never expose raw Dio errors
above the use case layer.

## Multipart Upload

Used for: user avatars, document attachments, signature captures.

```dart
final formData = FormData.fromMap({...fields});
formData.files.add(MapEntry(
  "field_name",
  await MultipartFile.fromFile(filePath),
));
await dio.post(url, data: formData);  // or .patch
```

## Authentication Flow

1. `POST /api-auth-login` → returns JWT
2. JWT stored in `FlutterSecureStorage`
3. All subsequent requests include `Authorization: <JWT>` automatically
4. On token expiry → re-login flow triggered by the auth controller

## Platform-Specific Keys

Google Maps API key and similar third-party keys are switched per platform and flavor inside
`FlavorsConfig`. Never use a dev key in production or a web key on mobile.
