# Mobile Context - Zafira Flutter App

## Stack

| Concern | Library |
| --- | --- |
| State | flutter_riverpod (`StateNotifierProvider`) |
| Navigation | go_router |
| HTTP | dio |
| Serialization | freezed + json_serializable |
| Error handling | either_dart |
| Local DB | sqflite |
| Secure storage | flutter_secure_storage |
| OTA updates | Shorebird |
| Push notifications | firebase_messaging |

## Feature Modules

Features live in `lib/feature/` and follow `application`, `data`, `domain`, and
`view` layers. Shared presentation/infrastructure code belongs in `lib/core/` or
`lib/modules/`.

## Key Files

| File | Role |
| --- | --- |
| `lib/modules/common/routes/app_router.dart` | Route definitions |
| `lib/core/flavors/flavors_config.dart` | Per-flavor base URLs and config |
| `lib/env/env.g.dart` | Generated env vars; never edit by hand |
| `lib/main/common_main.dart` | Shared app initialization |
| `docs/android-release.md` | Android signing, Shorebird, and GitHub release operations |

## Flavors

| Flavor | Entry point |
| --- | --- |
| dev | `lib/main/main_dev.dart` |
| prod | `lib/main/main_prod.dart` |

Run locally with:

```bash
fvm flutter run -t lib/main/main_dev.dart --flavor dev
```

## Android build and OTA commands

```bash
make build-apk-debug flavor=dev
make build-apk flavor=prod
make build-aab flavor=prod
make shorebird-release-aab flavor=prod
make shorebird-patch flavor=prod release_version=1.0.0+1
```

See `docs/android-release.md` for signing, Shorebird initialization, and GitHub
Actions requirements.

## Code Generation

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Run after changes to Freezed models, JSON models, routes, or `lib/env/env.dart`.
