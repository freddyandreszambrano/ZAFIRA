# Infrastructure Context

> Pipeline base prevista para zafira. Mientras no exista CI/CD configurado, este archivo describe el
> objetivo. <TODO: ampliar a medida que el proyecto crece — los archivos `ci/*.yml`, `Dockerfile*`
> y `Makefile` aún no existen en el repo.>

## CI/CD — GitLab (planned)

| File                 | Purpose                                            |
|----------------------|----------------------------------------------------|
| `ci/test.yml`        | `flutter analyze` + `flutter test --coverage`      |
| `ci/web.yml`         | Flutter web build → Docker image → Docker Hub push |
| `ci/preparation.yml` | Pipeline initialization                            |
| `ci/deploy.yml`      | Deployment job                                     |

## Docker (planned)

### Base Image

`DockerfileBase` will build `zafira/flutter-base:<version>`:

- Base: `google/cloud-sdk:<version>`
- Includes: FVM + Flutter (pinned) + web precache
- Used by all CI jobs to avoid downloading Flutter on every run

Rebuild after a Flutter version bump:

```bash
docker build -t zafira/flutter-base:<version> -f DockerfileBase .
docker push zafira/flutter-base:<version>
```

Then update `image:` tag in `ci/test.yml`, `ci/web.yml`, and `Dockerfile.test`.

### Web Image

`web/Dockerfile` — will extend base, run `pub get` + `build_runner` + `flutter build web`.
Serves on port 9000 via `python3 http.server`.

Build:

```bash
docker build --build-arg FLAVOR=${FLAVOR} -f web/Dockerfile .
```

## Flutter Version Management

- Managed via FVM
- Pin via `.fvmrc` once the target version is fixed
- Always use `fvm flutter` — never bare `flutter`

## OTA Updates (planned)

- Shorebird for over-the-air patches
- `make build-shorebird-aab flavor=<flavor>`
- `make patch-shorebird-android flavor=<flavor>`
