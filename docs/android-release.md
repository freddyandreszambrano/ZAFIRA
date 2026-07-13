# Android releases and Shorebird

## What Zafira now supports

- `make build-apk flavor=dev|prod`: signed release APK.
- `make build-aab flavor=dev|prod`: optional signed Android App Bundle.
- `make shorebird-release-aab flavor=dev|prod`: optional Shorebird base release and AAB.
- `make shorebird-release-apk flavor=dev|prod`: Shorebird base release plus APK/AAB for side-loading.
- `make shorebird-patch flavor=dev|prod release_version=<version>`: OTA patch for an existing base release.

The ordinary APK/AAB is produced by Flutter. Shorebird wraps the release build,
stores the base Dart artifacts, and makes later Dart-only patches available OTA.
Zafira is distributed by signed APK, so no Google Play configuration is needed.
Android signing remains mandatory because Android will not install an unsigned APK.
The release command explicitly uses Flutter `3.41.9`, the version pinned by
Zafira; do not run `shorebird release` with its default latest Flutter version.

## One-time setup

### 1. Create the Android signing key

Create a key owned only by Zafira and store it in a password manager or secure
vault. This key is independent from Google Play. In PowerShell with JDK 17:

```powershell
keytool -genkeypair -v -keystore android\app\upload-keystore.jks -alias zafira -keyalg RSA -keysize 2048 -validity 10000
```

Then create the gitignored `android/key.properties` file:

```properties
keyAlias=<alias>
keyPassword=<key-password>
storeFile=upload-keystore.jks
storePassword=<store-password>
```

`build-apk`, `build-aab`, and Shorebird intentionally require this key. Use
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
make shorebird-release-apk flavor=prod
make shorebird-patch flavor=prod release_version=1.0.0+1
```

Before a new base release, increment `version` in `pubspec.yaml`. A Shorebird
patch must use the exact base release version and is only appropriate for Dart
code changes. Native Android/iOS changes, assets, or a Flutter engine upgrade
require a new signed APK base release.

## GitHub Actions

`CI` runs analysis, formatting, tests, code generation, and debug APK builds
for both flavors on every pull request and push to `main`/`develop`. It never
receives release secrets.

`Android release` is manual and defaults to `apk`. Choose the source ref,
flavor, artifact, and whether to publish the Shorebird base release. It builds
with credentials from the selected protected environment, uploads the APK and
Dart symbols as a 14-day artifact, and removes temporary credentials.

`Shorebird patch` is manual and requires the exact base release version. Run it
only after validating the fix against that release; production environment
approval can be used as the final gate.
