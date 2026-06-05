# Mobile Context — zafira Flutter App

## Stack

| Concern            | Library                                        |
|--------------------|------------------------------------------------|
| State              | flutter_riverpod (`StateNotifierProvider`)     |
| Navigation         | go_router                                      |
| HTTP               | dio                                            |
| Serialization      | freezed + json_serializable                    |
| Error handling     | either_dart                                    |
| Local DB           | sqflite                                        |
| Secure storage     | flutter_secure_storage                         |
| OTA updates        | shorebird_code_push                            |
| Push notifications | firebase_messaging                             |
| Maps               | google_maps_flutter, google_places_suggestions |

## Feature Modules

Located at `lib/feature/`:

| Module | Purpose                   |
|--------|---------------------------|
| `auth` | Login, session management |

<TODO: ampliar a medida que el proyecto crece. Los módulos administrativos previstos (dashboard,
usuarios, roles, permisos, módulos dinámicos del sidebar) aún no están implementados.>

## Shared Helpers

`lib/helpers/` — <TODO: ampliar a medida que el proyecto crece. Aún no existen helpers compartidos;
los flujos transversales se registrarán aquí cuando se extraigan.>

## Key Files

| File                                   | Role                            |
|----------------------------------------|---------------------------------|
| `lib/modules/app_module.dart`          | All route definitions           |
| `lib/core/flavors/flavors_config.dart` | Per-flavor base URLs and config |
| `lib/env/env.g.dart`                   | Generated env vars — never edit |
| `lib/main/common_main.dart`            | Shared app initialization       |

## Flavors

| Flavor | Entry point               |
|--------|---------------------------|
| dev    | `lib/main/main_dev.dart`  |
| stg    | `lib/main/main_stg.dart`  |
| prod   | `lib/main/main_prod.dart` |

Run with: `fvm flutter run -t lib/main/main_dev.dart --flavor dev`

## Build

```bash
make build-apk flavor=dev
make build-app-bundle flavor=dev
make build-ios flavor=dev
make build-shorebird-aab flavor=dev
```

<TODO: el `Makefile` con estos targets aún no existe; se incorporará cuando se configure la pipeline.>

## Code Generation

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Run after any change to Freezed models, routes, or env config.
