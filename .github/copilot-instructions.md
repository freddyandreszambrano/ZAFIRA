# Instrucciones para GitHub Copilot — Zafira (Flutter)

Proyecto Flutter multiplataforma. Stack: **Clean Architecture + Riverpod + Dio +
Freezed + go_router + either_dart**. Capas: `data → domain → application → view`.

Reglas completas en `ai/rules/` y `ai/design-system.md`. Al revisar un PR o sugerir
código, hacé cumplir lo siguiente y citá la regla correspondiente.

## Capas (layer rules)
- Widget ↔ Controller vía `ref.watch` / `ref.read`. El Widget NO llama services ni use cases directo.
- Controller → UseCase (NUNCA Service ni Repository directo).
- UseCase → interface del Repository (`I*`), NUNCA la implementación concreta.
- Service → `DioHttpClient`, NUNCA estado ni controllers.
- La lógica de negocio vive en el UseCase. NO en repos, services ni controllers.

## Manejo de errores
- UseCase SIEMPRE retorna `Either<Exception, T>`. Nunca `throw` desde un UseCase.
- Service NUNCA hace `catch` — propaga al `ErrorExceptionHandler`.
- Controller SIEMPRE `.fold(left, right)` con `isLoading: false` en AMBAS ramas.

## Estado
- `copyWith` para CADA mutación de estado en el Controller. Nunca reemplazar el estado entero.
- Controllers a nivel pantalla con `StateNotifierProvider.autoDispose` (excepto auth/session).
- Providers como constantes top-level (nunca dentro de clases).

## Modelos
- Domain models con Freezed. CADA field con `@Default`.
- `@JsonKey(name: 'snake_case')` cuando el field del API ≠ field Dart.
- DTOs en `data/`, Domain Models en `domain/`. Los UseCases mapean DTO → Model.
- NUNCA editar `*.freezed.dart` ni `*.g.dart` (autogenerados).

## HTTP
- NUNCA usar Dio directo en features. Siempre `ref.watch(dioHttpClientProvider)`.
- URL paths como constantes en el archivo del service.
- Loguear CADA request/response con `DebugLogger`.

## UI / Widgets (ver `ai/rules/widget-design.md`)
- NUNCA `Color(0xFF...)` hardcoded. Siempre `context.appColors.<token>`.
- NUNCA `TextStyle(fontSize:..., color:...)` literal. Siempre `context.typography.<style>`.
- NUNCA `MaterialColor` / `Colors.purple` etc. — usar tokens ZAFIRA.
- Una Screen DEBE manejar 4 estados (loading / empty / error / success) con `switch` exhaustivo.
- Trailing commas SIEMPRE (`require_trailing_commas: true`).
- Constructores primero en cada clase (`sort_constructors_first: true`).
- Imports relativos dentro de `lib/<feature>/...` (`prefer_relative_imports`).
- Widget > 200 LOC = partir en sub-widgets privados.

## Tests (ver `ai/rules/testing.md`)
- Service test: usar `stubDio*` de `test/helpers/http_test_dio.dart`. NUNCA mockear Dio a mano.
- Controller test: `ProviderContainer` con `overrides` + `addTearDown(c.dispose)`.
- Mocks con `mocktail` (no `mockito`). `registerFallbackValue` para tipos custom.
- NUNCA `print(...)` en tests.

## Prohibido
- `setState` en `ConsumerWidget`.
- `Navigator.push` directo (usar `go_router`).
- Strings hardcoded en UI sin extraer a `l10n` o constantes.
- Valores numéricos quemados (padding/size/radio/alpha) — usar tokens de `app_numbers.dart`; si falta, agregar una constante con nombre.
- `SnackBar` / `ScaffoldMessenger.showSnackBar` / `MySnackBar` para feedback — usar `AppNotification`.
- Editar archivos `*.freezed.dart` o `*.g.dart`.

## Severidad de los comentarios de review
- 🔴 **critical** — rompe contrato/build/seguridad o cruza capas.
- 🟡 **improvement** — viola una regla dura (hex hardcoded, falta `copyWith`, falta `isLoading: false` en una rama del fold).
- 🟢 **suggestion** — nice-to-have, estilo, naming.

Ignorá archivos autogenerados: `*.freezed.dart`, `*.g.dart`, `pubspec.lock`.
