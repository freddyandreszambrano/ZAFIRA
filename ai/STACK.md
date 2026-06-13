# STACK — Zafira

## Project

- **Name**: Zafira
- **Version**: `1.0.0+1`

## Language

Dart 3.x (null-safe)

## Framework

Flutter (multiplatform) — version managed via FVM (pin in `.fvmrc` when added).

## Platform Targets

- Android (minSdk 21+)
- iOS (12+)
- Web (containerized, served via Python HTTP server + Nginx proxy)

---

## State Management

| Library            | Version | Role                                |
|--------------------|---------|-------------------------------------|
| `flutter_riverpod` | ^3.3.1  | `StateNotifierProvider`, `Provider` |

## Navigation

| Library     | Version | Role                                           |
|-------------|---------|------------------------------------------------|
| `go_router` | ^17.2.3 | Declarative routing, named routes, path params |

## HTTP & Networking

| Library                            | Version | Role                          |
|------------------------------------|---------|-------------------------------|
| `dio`                              | ^5.9.2  | HTTP client with interceptors |
| `connectivity_plus`                | ^7.1.1  | Network state monitoring      |
| `internet_connection_checker_plus` | ^3.0.0  | Connectivity validation       |

## Serialization & Code Generation

| Library              | Version | Role                             |
|----------------------|---------|----------------------------------|
| `freezed_annotation` | ^3.1.0  | Immutable model annotations      |
| `json_annotation`    | ^4.12.0 | JSON serialization annotations   |
| `freezed`            | ^3.2.5  | Code generator for frozen models |
| `json_serializable`  | ^6.14.0 | JSON serialization generator     |
| `build_runner`       | ^2.15.0 | Code generation runner           |

## Error Handling

| Library       | Version | Role                           |
|---------------|---------|--------------------------------|
| `either_dart` | ^1.0.0  | Functional `Either<L, R>` type |

## Storage

| Library                  | Version | Role                              |
|--------------------------|---------|-----------------------------------|
| `shared_preferences`     | ^2.5.4  | Key-value local storage           |
| `flutter_secure_storage` | ^10.3.1 | Encrypted secure storage (tokens) |
| `sqflite`                | ^2.4.2  | SQLite local database             |
| `path_provider`          | ^2.1.5  | Filesystem paths                  |

## Configuration & Environment

| Library             | Version | Role                                   |
|---------------------|---------|----------------------------------------|
| `envied`            | ^1.3.5  | Compile-time env vars from `.env` file |
| `envied_generator`  | ^1.3.5  | Code generator for `envied`            |
| `package_info_plus` | ^9.0.1  | App version at runtime                 |
| `device_info_plus`  | ^9.1.2  | Device model/OS info                   |

## Maps & Location

| Library                                          | Version | Role                            |
|--------------------------------------------------|---------|---------------------------------|
| `google_maps_flutter`                            | ^2.17.0 | Native maps (Android/iOS)       |
| `google_maps_flutter_web`                        | ^0.6.2  | Web maps                        |
| `google_places_suggestions_autocomplete_field`   | ^0.0.5  | Places autocomplete             |
| `geolocator`                                     | ^12.0.0 | GPS location                    |
| `geocoding`                                      | ^4.0.0  | Address lookup from coordinates |

## Firebase

| Library                       | Version | Role                       |
|-------------------------------|---------|----------------------------|
| `firebase_core`               | ^4.9.0  | Firebase initialization    |
| `firebase_crashlytics`        | ^5.2.2  | Crash reporting            |
| `firebase_analytics`          | ^12.4.1 | Analytics events           |
| `firebase_messaging`          | ^16.2.2 | Push notifications (FCM)   |
| `flutter_local_notifications` | ^21.0.0 | Local notification display |

## OTA Updates

| Library               | Version | Role                                |
|-----------------------|---------|-------------------------------------|
| `shorebird_code_push` | ^2.0.6  | Over-the-air Flutter patch delivery |

## Media & Documents

| Library               | Version | Role                             |
|-----------------------|---------|----------------------------------|
| `image_picker`        | ^1.2.2  | Camera/gallery image selection   |
| `camera`              | ^0.12.0 | Direct camera access             |
| `flutter_doc_scanner` | ^0.0.20 | Document scanning                |
| `signature`           | ^6.3.0  | Digital signature capture canvas |
| `photo_view`          | ^0.14.0 | Zoomable image viewer            |

## UI Components

| Library                 | Version | Role                     |
|-------------------------|---------|--------------------------|
| `google_fonts`          | ^8.1.0  | Font loading             |
| `lottie`                | ^3.3.3  | Lottie animations        |
| `modal_bottom_sheet`    | ^3.0.0  | Bottom sheet modals      |
| `dropdown_button2`      | ^3.1.0  | Enhanced dropdown widget |
| `pinput`                | ^6.0.2  | PIN/OTP input field      |
| `calendar_date_picker2` | ^3.0.0  | Date picker              |
| `flutter_svg`           | ^2.3.0  | SVG rendering            |
| `gap`                   | ^3.0.1  | Layout gaps              |
| `loading_overlay`       | ^0.5.0  | Loading overlay widget   |
| `device_preview_plus`   | ^2.6.0  | Device preview tooling   |

## Utilities

| Library              | Version | Role                               |
|----------------------|---------|------------------------------------|
| `intl`               | ^0.20.2 | Date/number formatting             |
| `logger`             | ^2.7.0  | Structured logging (PrettyPrinter) |
| `collection`         | ^1.19.1 | Collection utilities               |
| `permission_handler` | ^12.0.1 | Runtime permission requests        |
| `uuid`               | ^3.0.7  | UUID generation                    |
| `url_launcher`       | ^6.3.2  | External URL launching             |

## Testing

| Library        | Role                            |
|----------------|---------------------------------|
| `flutter_test` | Flutter test framework          |
| `mocktail`     | Mock generation without codegen |
| `fake_async`   | Deterministic async testing     |

## CI/CD Toolchain (planned)

| Tool               | Role                                      |
|--------------------|-------------------------------------------|
| GitLab CI          | Pipeline orchestration                    |
| Docker Hub         | Image registry                            |
| GCP Secret Manager | Secrets injection at build time           |
| Fastlane           | Mobile store distribution (Android + iOS) |
| Shorebird          | OTA patch delivery                        |
| FVM                | Flutter version pinning                   |
