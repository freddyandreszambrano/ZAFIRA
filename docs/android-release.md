# Android releases and Shorebird

## What Zafira now supports

- `make build-apk flavor=dev|prod`: signed release APK.
- `make build-aab flavor=dev|prod`: signed Android App Bundle for Google Play.
- `make shorebird-release-aab flavor=dev|prod`: Shorebird base release and AAB.
- `make shorebird-release-apk flavor=dev|prod`: Shorebird base release plus APK/AAB for side-loading.
- `make shorebird-patch flavor=dev|prod release_version=<version>`: OTA patch for an existing base release.

The ordinary APK/AAB is produced by Flutter. Shorebird wraps the release build,
stores the base Dart artifacts, and makes later Dart-only patches available OTA.
It does not replace Android signing or Google Play distribution.

## One-time setup

### 1. Configure the Android upload key

Create an upload key according to the Android/Flutter release-signing guidance.
Store the key locally at `android/app/upload-keystore.jks`, then create the
gitignored `android/key.properties` file:

```properties
keyAlias=<alias>
keyPassword=<key-password>
storeFile=upload-keystore.jks
storePassword=<store-password>
```

`build-apk` and `build-aab` intentionally require this key. Use
`make build-apk-debug flavor=dev` for a debug development build.

### 2. Initialize Shorebird for Zafira

Do not copy the `app_id` values from another app. Shorebird assigns an ID per
application and, because Zafira has `dev` and `prod` flavors, an ID per flavor.

```bash
shorebird login
shorebird init --force
```

Commit the generated `shorebird.yaml`. It is configuration, not a secret. The
CLI requires an authenticated Shorebird account, so this file cannot be safely
invented in this repository.

On Windows, Shorebird also recommends enabling Git long paths before the first
release. Run the following from an elevated terminal if your organization
permits the machine-wide setting:

```powershell
git config --system core.longpaths true
```

### 3. Configure GitHub Environments

Create the protected GitHub Environments named `development` and `production`.
In each, add these secrets:

| Secret | Purpose |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | Base64 of `android/app/upload-keystore.jks` |
| `ANDROID_KEY_ALIAS` | Keystore alias |
| `ANDROID_KEY_PASSWORD` | Alias password |
| `ANDROID_STORE_PASSWORD` | Keystore password |
| `ZAFIRA_DEVELOP_ENV` | Development API base URL |
| `ZAFIRA_PRODUCTION_ENV` | Production API base URL |
| `SHOREBIRD_TOKEN` | Shorebird Console API key; required only for Shorebird workflows |

In PowerShell, produce the keystore secret without altering its binary bytes:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes('android\app\upload-keystore.jks')) | Set-Clipboard
```

Create `SHOREBIRD_TOKEN` in Shorebird Console → Account → API Keys. Never put
these values in git, `shorebird.yaml`, or a workflow file.

## Local commands

```bash
make build-apk-debug flavor=dev
make build-apk flavor=prod
make build-aab flavor=prod
make shorebird-release-aab flavor=prod
make shorebird-release-apk flavor=dev
make shorebird-patch flavor=prod release_version=1.0.0+1
```

Before a new base release, increment `version` in `pubspec.yaml`. A Shorebird
patch must use the exact base release version and is only appropriate for Dart
code changes. Native Android/iOS changes, assets, or a Flutter engine upgrade
require a new signed store release.

## GitHub Actions

`CI` runs analysis, formatting, tests, code generation, and debug APK builds
for both flavors on every pull request and push to `main`/`develop`. It never
receives release secrets.

`Android release` is manual. Choose the source ref, flavor, artifact, and
whether to publish the Shorebird base release. It builds with credentials from
the selected protected environment, uploads the APK/AAB and Dart symbols as a
14-day artifact, and removes temporary credentials.

`Shorebird patch` is manual and requires the exact base release version. Run it
only after validating the fix against that release; production environment
approval can be used as the final gate.
