# Handoff de distribución Android con Shorebird

Actualizado: 2026-07-13

## Objetivo acordado

Zafira se distribuirá como APK Android firmado, directamente desde Shorebird o
como artefacto de GitHub Actions. No se usará Google Play Store ni se debe
configurar ninguna credencial de Play Console.

La rama de este trabajo es `feature/zafira-release-pipeline`. Debe abrirse como
un PR separado contra `feature/zafira-refacotr-code`.

## Estado implementado

- Shorebird está instalado y la sesión ya está autenticada en esta máquina.
- Se ejecutó `shorebird init --force`; la aplicación y sus sabores ya existen
  en Shorebird.
- `shorebird.yaml` está versionado con estos identificadores:

  ```yaml
  app_id: 748bec91-337a-459b-bf41-23101bdbecde
  flavors:
    dev: 16b39100-ab04-41c8-a4a3-75f11eec73e3
    prod: 9ba55d26-2526-43d4-a37c-3962d47ee8e6
  ```

- `pubspec.yaml` incluye `shorebird.yaml` como asset y el manifiesto Android
  declara el permiso `android.permission.INTERNET`, requerido por Shorebird.
- El `Makefile` incorpora los comandos de build, release y patch de Shorebird.
  Para publicar usa Flutter `3.41.9`, igual a la versión configurada por FVM,
  de modo que no use por accidente el Flutter interno más nuevo de Shorebird.
- Se añadieron los flujos manuales de GitHub Actions:
  - `.github/workflows/android-release.yml`: genera APK firmado y, por defecto,
    lo publica mediante Shorebird.
  - `.github/workflows/shorebird-patch.yml`: publica un patch OTA.
  - `.github/workflows/ci.yml`: valida APK debug de los sabores `dev` y `prod`.
- La configuración de Gradle para firmar lee secretos desde
  `android/key.properties`; tanto este archivo como el JKS están ignorados por
  Git. No hay contraseñas ni claves privadas en el repositorio.

## Verificaciones hechas

```powershell
fvm flutter analyze  # sin incidencias
fvm flutter test     # 36 pruebas aprobadas
```

También se generaron correctamente APK debug para `dev` y `prod`, y la
validación de formato de los workflows de GitHub pasó.

## Crear la clave privada Android

Esto se hace una sola vez, en un terminal local. No pegar contraseñas ni el
archivo JKS en el chat, en Git o en un ticket.

```powershell
cd C:\HEY\MOBILE\MULTIPLAFORM\ZAFIRA

keytool -genkey -v `
  -keystore android\app\upload-keystore.jks `
  -storetype JKS `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -alias zafira
```

`keytool` pedirá el nombre, organización, país y las contraseñas. Se debe
guardar la contraseña en un gestor de contraseñas y realizar una copia segura
del archivo `android/app/upload-keystore.jks`. Perder ese JKS impide firmar
actualizaciones compatibles de la aplicación.

Después crear `android/key.properties` con valores reales:

```properties
keyAlias=zafira
keyPassword=CONTRASENA_DE_LA_CLAVE
storeFile=upload-keystore.jks
storePassword=CONTRASENA_DEL_ALMACEN
```

Verificar la firma sin publicar nada:

```powershell
make build-apk flavor=prod
```

El APK queda bajo `build/app/outputs/flutter-apk/`.

## Primera publicación de APK con Shorebird

1. En una consola con permisos de administrador ejecutar una vez:

   ```powershell
   git config --system core.longpaths true
   ```

   `shorebird doctor` solo reportó este ajuste pendiente. No se cambió de forma
   automática porque afecta la configuración global de Git del equipo.

2. Confirmar que `android/key.properties` y el JKS existen localmente.

3. Publicar producción:

   ```powershell
   make shorebird-release-apk flavor=prod
   ```

   Si se desea publicar el sabor de pruebas, usar `flavor=dev`. El comando
   compila, firma y sube la release de APK a Shorebird.

4. Probar el APK resultante en un dispositivo real antes de entregarlo. La
   consola de Shorebird permite localizar la release publicada y distribuirla.

## Patches OTA posteriores

Un patch solo sirve para cambios Dart compatibles con una release base que ya
fue publicada. No usarlo para cambios nativos Android/iOS, cambios de assets o
una actualización de Flutter: en esos casos se debe generar una nueva release
APK.

```powershell
make shorebird-patch flavor=prod release_version=VERSION_BASE
```

Usar como `VERSION_BASE` la versión exacta que Shorebird muestra para la
release instalada. Antes de lanzar un patch hay que probarlo en un dispositivo
que tenga esa release base.

## Automatización en GitHub Actions

Antes de ejecutar los workflows en GitHub, configurar los siguientes secretos
en el repositorio (`Settings > Secrets and variables > Actions`):

```text
ANDROID_KEYSTORE_BASE64   contenido Base64 del archivo upload-keystore.jks
ANDROID_KEYSTORE_PASSWORD contraseña del almacén JKS
ANDROID_KEY_ALIAS         zafira
ANDROID_KEY_PASSWORD      contraseña de la clave
SHOREBIRD_TOKEN           token de Shorebird de una cuenta autorizada
```

Para preparar el primer secreto localmente, sin imprimirlo en pantalla:

```powershell
[Convert]::ToBase64String(
  [IO.File]::ReadAllBytes('android\app\upload-keystore.jks')
) | Set-Clipboard
```

Luego pegar el portapapeles directamente en el valor de
`ANDROID_KEYSTORE_BASE64`. Nunca commitear `key.properties`, el JKS, el token
ni un archivo `.env` que contenga esos datos.

El workflow `Android release` se ejecuta manualmente desde la pestaña
**Actions**, permite elegir `dev` o `prod`, `apk` o `aab`, y por defecto usa
Shorebird. Para este proyecto elegir `apk` y dejar activado Shorebird. El
workflow `Shorebird patch` también es manual y requiere escribir la versión
base.

## Comandos útiles

```powershell
make help
make build-apk-debug flavor=dev
make build-apk flavor=prod
make shorebird-release-apk flavor=prod
make shorebird-patch flavor=prod release_version=VERSION_BASE
shorebird doctor
```

## Historial relevante

Los cambios de distribución están en estos commits de
`feature/zafira-release-pipeline`:

- `6724b9b` - pipeline Android, firma, Make y workflows.
- `e0fe060` - distribución prioritaria por APK/Shorebird, sin Play Store.
- `f3fa90f` - inicialización de Shorebird y sabores.

El PR aún debe crearse desde una sesión autenticada de GitHub. No se requiere
crear una aplicación nueva en la consola Shorebird: `shorebird init --force`
ya la creó y generó los IDs de arriba.
