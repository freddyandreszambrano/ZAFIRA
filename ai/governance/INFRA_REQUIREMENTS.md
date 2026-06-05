# INFRA REQUIREMENTS

> Infraestructura prevista para zafira. Mientras los pipelines y Dockerfiles no existan en el repo,
> este archivo describe el objetivo. <TODO: ampliar a medida que el proyecto crece.>

## Flutter Version

Pinned via FVM (see `.fvmrc` once configured).
Always run `fvm flutter` — never bare `flutter`.

Rebuild base Docker image and update CI image tags when upgrading Flutter:

```bash
docker build -t zafira/flutter-base:<new_version> -f DockerfileBase .
docker push zafira/flutter-base:<new_version>
# Then update image: tag in ci/test.yml, ci/web.yml, Dockerfile.test
```

---

## Docker (planned)

### Base Image

`zafira/flutter-base:<version>` — pre-baked with:

- `google/cloud-sdk:<version>`
- FVM + Flutter (pinned)
- Web platform pre-cached

Used by all CI jobs to avoid downloading Flutter per pipeline.

### Web Image (`web/Dockerfile`)

Extends base image:

1. Copies source
2. `flutter pub get`
3. `build_runner build`
4. `flutter build web --release -t lib/main/<FLAVOR>`
5. Serves on port 9000 via `python3 -m http.server`

Build command:

```bash
docker build --build-arg FLAVOR=${FLAVOR} -f web/Dockerfile .
```

---

## CI/CD Pipeline (GitLab CI — planned)

| File                 | Stage    | Purpose                                                     |
|----------------------|----------|-------------------------------------------------------------|
| `ci/preparation.yml` | `.pre`   | Extract version, decode credentials from GCP Secret Manager |
| `ci/test.yml`        | `test`   | `flutter analyze` + `flutter test --coverage`               |
| `ci/web.yml`         | `build`  | Flutter web build → Docker image → push to Docker Hub       |
| `ci/deploy.yml`      | `deploy` | Deployment orchestration                                    |
| `ci/mr_review.yml`   | `review` | Automated merge request review                              |

### Flavor → Branch Mapping

| Branch    | Flavor | Entry Point               |
|-----------|--------|---------------------------|
| `develop` | dev    | `lib/main/main_dev.dart`  |
| `main`    | prod   | `lib/main/main_prod.dart` |

---

## Secrets Management

All credentials are injected at CI runtime from **GCP Secret Manager**.
Nothing sensitive is committed to git.

| Secret                          | Usage                       |
|---------------------------------|-----------------------------|
| Firebase service account JSON   | Crashlytics, Analytics, FCM |
| Docker Hub credentials          | Push built web images       |
| Android keystore + passwords    | APK/AAB signing             |
| iOS certificates + profiles     | IPA signing                 |
| Google Maps API keys (dev/prod) | Maps and Places             |
| Backend base URLs               | API routing                 |

---

## Local Environment Setup

1. Copy `.env.sample` → `.env` and fill in values.
2. Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate `env.g.dart`.
3. Use `fvm flutter run -t lib/main/main_dev.dart --flavor dev` to start.

`.env` is gitignored — never commit it.

---

## OTA Updates (Shorebird)

Config: `shorebird.yaml` (planned).

| Command                                   | Purpose                         |
|-------------------------------------------|---------------------------------|
| `make build-shorebird-aab flavor=dev`     | Build release AAB for Shorebird |
| `make patch-shorebird-android flavor=dev` | Push an OTA patch               |

Patches are downloaded at app startup via `shorebird_code_push` package.

---

## Mobile Distribution (planned)

- **Android:** Google Play via Fastlane (`android/fastlane/`)
- **iOS:** App Store via Fastlane (`ios/fastlane/`)

Build commands:

```bash
make build-apk flavor=prod
make build-app-bundle flavor=prod
make build-ios flavor=prod
```

---

## Web Hosting (planned)

- Container port: 9000 (Python HTTP server)
- Nginx reverse proxy in front
- Platform detected at runtime via `kIsWeb` — switches API keys and `app-source` header

---

## iOS Dependency Reset

Run when pod issues arise:

```bash
cd ios && pod deintegrate && pod cache clean --all && pod install && pod update
```
