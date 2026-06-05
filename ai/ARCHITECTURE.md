# ARCHITECTURE — Zafira

## Project Type

Flutter mobile + web application — administrative platform with a dynamic module / dashboard model
(roles, permissions, configurable sections). Each business unit ships as an independently
configurable module.

## Platform Targets

- Android (native, Fastlane distribution — planned)
- iOS (native, Fastlane distribution — planned)
- Web (Docker/Python HTTP server, Nginx-proxied — planned)

## Top-Level Structure

```
lib/
├── main/                    # Entry points per flavor
│   ├── common_main.dart     # Shared initialization (Firebase, DI bootstrap)
│   ├── main_dev.dart        # Dev flavor entry
│   └── main_prod.dart       # Prod flavor entry
├── env/
│   ├── env.dart             # Envied declarations
│   └── env.g.dart           # Generated — never edit manually
├── modules/
│   ├── app_widget.dart      # MaterialApp.router root
│   ├── app_module.dart      # GoRouter config + all routes
│   └── common/
│       ├── drivers/
│       │   ├── http/        # DioHttpClient with auth interceptor
│       │   └── storage/     # SharedPrefs + FlutterSecureStorage wrappers
│       ├── exceptions/      # ServerException, RegularException
│       ├── error/           # ErrorExceptionHandler mixin
│       ├── widget/          # Shared UI: buttons, appbars, modals
│       ├── utils/
│       └── mapper/
├── core/
│   ├── constants/           # Strings, dimensions, fonts, URLs, colors, themes
│   ├── enum/                # ResponseStatus, ConnectionStatus
│   ├── utils/               # Logger, error_parser, shared_pref
│   ├── database/            # SQLite: DatabaseManager, SqlHelper, SqlDAO
│   ├── helpers/             # context_helper, responsive, typography
│   ├── services/            # PushNotificationService
│   ├── flavors/             # FlavorsConfig (dev/prod URL + key switching)
│   └── serialization/
├── feature/                 # Main business features
│   └── auth/                # Initial feature — login, session
└── helpers/                 # Reusable shared flows (added as project grows)
```

> <TODO: ampliar `feature/` y `helpers/` a medida que el proyecto crece — el listado anterior
> refleja la estructura prevista para módulos administrativos (usuarios, roles, permisos,
> dashboards). Solo `auth` existe hoy.>

## Per-Feature Layer Structure

Every feature under `lib/feature/{name}/` and `lib/helpers/{name}/` follows:

```
{feature}/
├── domain/          # Freezed models + DTOs — pure data, no logic
├── data/
│   ├── interfaces/  # Abstract repository contracts (IAuth, IModule, etc.)
│   ├── repositories/# Concrete implementations, delegate to services
│   └── services/    # Dio HTTP calls — parse response to DTO, no transformation
├── application/     # Use cases — orchestrate repos, return Either<Exception, T>
└── view/
    ├── controller/  # StateNotifier subclasses — mutate state via copyWith
    ├── state/       # Plain Dart state classes with copyWith
    └── widget/      # Screens + component widgets
```

## Data Flow

```
Widget
  → reads StateNotifierProvider (Riverpod)
  → calls Controller method
    → Controller calls UseCase
      → UseCase calls IRepository (interface)
        → Repository delegates to Service
          → Service sends HTTP via DioHttpClient
            ← Response parsed to DTO
          ← DTO returned to Repository
        ← Repository returns DTO to UseCase
      ← UseCase maps DTO → Domain Model
      ← UseCase returns Either<Exception, DomainModel>
    ← Controller folds Either → updates State via copyWith
  ← Widget rebuilds from new State
```

## Cross-Feature Boundaries

- `lib/helpers/` — reusable flows consumed by multiple features
- `lib/modules/common/` — infrastructure singletons: DioHttpClient, storage drivers
- `lib/core/` — pure utilities and constants; zero feature knowledge

## Dependency Injection

All dependencies wired via Riverpod `Provider`:

```dart
// Service (leaf node, no autoDispose)
final authServiceProvider = Provider<AuthService>((ref) =>
  AuthService(remoteDataSource: ref.watch(dioHttpClientProvider)));

// Repository (depends on service, no autoDispose)
final authRepositoryProvider = Provider<IAuth>((ref) =>
  AuthRepository(
    remoteDataSource: ref.watch(authServiceProvider),
    localDataSource: ref.watch(secureLocalDataSourceProvider),
  ));

// Controller (autoDispose — freed when screen pops)
final authControllerProvider =
  StateNotifierProvider.autoDispose<AuthController, AuthState>((ref) =>
    AuthController(
      SessionUseCase(ref.watch(authRepositoryProvider)),
      TokenUseCase(ref.watch(authRepositoryProvider)),
    ));
```

## Features Overview

| Feature | Purpose                                                         |
|---------|-----------------------------------------------------------------|
| `auth`  | Login, token management, profile, push device registration      |

<TODO: agregar módulos administrativos (dashboard, users, roles, modules dinámicos) a medida que se
implementen.>

## Shared Helper Modules

<TODO: registrar aquí cada flujo compartido (selección de módulo, búsqueda, etc.) cuando exista en
`lib/helpers/`. El proyecto aún no tiene helpers transversales.>
