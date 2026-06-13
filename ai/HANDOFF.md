# Handoff — Zafira Mobile

> Documento de traspaso. Léelo entero antes de tocar código si recién entrás al proyecto (o si abrís una nueva sesión con un agente IA).
>
> Última actualización: 2026-06-13

---

## 1. Qué es Zafira (mobile)

App Flutter **multiplataforma** (Android / iOS / Web) — cliente del backend Django `ZAFIRA-CORE`. Mismo branding, mismas reglas de dominio. El backend ya tiene módulos dinámicos, grupos, permisos; esta app es el frontend móvil que los consume.

Stack base (ver `ai/STACK.md` para versiones exactas):
- Flutter (FVM por configurar) + Dart 3.x
- Riverpod (state) + go_router (nav) + Dio (HTTP) + Freezed (modelos) + either_dart (errores)
- Clean Architecture en 4 capas: `data → domain → application → view`

---

## 2. Qué está hecho

### Tooling y branding
- `lib/core/helpers/app_colors.dart` — paleta ZAFIRA completa (Cyber-Magenta `#FF3BBE` + Electric-Violet `#8E54FF` + gradients + shadows + alias slate/obsidian). Espejo de `ZAFIRA-CORE/docs/DESIGN_SYSTEM.md`.
- `lib/core/helpers/colors.dart` — `AppPalette` con `MaterialColor` (escalas 50-900) para tokens semánticos rápidos.
- `lib/core/helpers/app_dimensions.dart` — breakpoints + `isTablet/isMobile/isDesktop`.
- `lib/core/helpers/app_typography.dart` — TextStyle getters (`displayLarge`, `body*`, `label*`) + estilos brand (`bodyMuted`, `bodyStrong`, `labelUppercase`).
- `lib/core/helpers/context_helper.dart` — extensión `BuildContext` para `context.appColors`, `context.typography`, etc.

### Flavors
- `lib/core/flavors/flavors_config.dart` — `enum Environment { dev, prod }` + `class Flavor` con `setEnvironment(...)` y getters (`server`, `hereMapApiKey`, `googleMapApiKey`, `isDev`, `isProd`).
- `lib/main/main_dev.dart` — entry point dev.
- `lib/main/main_prod.dart` — entry point prod.
- `lib/main/common_main.dart` — init compartido (`WidgetsFlutterBinding`, status bar, root `ZafiraApp` con `AppColorScheme`, banner DEV en debug).
- `lib/main.dart` — default (arranca dev sin argumentos).
- URLs / keys vía `--dart-define` (no envied todavía).

### Gobernanza IA (`ai/`)
26 archivos `.md` portados desde `hey-support/ai/` y adaptados al dominio Zafira:
- `HANDOFF.md` (este archivo) — estado actual del proyecto.
- `RULES.md`, `STACK.md`, `ARCHITECTURE.md`, `PATTERNS.md`, `CONVENTIONS.md` — referencia técnica.
- `agents/` (debugger, formatter, reviewer) — instrucciones para IAs.
- `commands/` (explain, fix, review) — workflows ejecutables.
- `context/` (mobile, backend, infra) — estado actual del proyecto.
- `governance/` (GLOBAL_RULES, LAYER_ENFORCEMENT, API_STANDARDS, ASYNC_HANDLING, INFRA_REQUIREMENTS) — reglas organizacionales.
- `rules/` (architecture, api-contracts, code-style, testing, **widget-design**) — reglas tácticas.
- `README.md` — índice.

### Calidad de código y tooling
- `analysis_options.yaml` — espejo del de hey-support con `flutter_lints` + `prefer_relative_imports`, `require_trailing_commas`, `sort_constructors_first`. Excluye `*.g.dart` y `*.freezed.dart`.
- `Makefile` — 22 targets (`make deps`, `make gen`, `make run-dev/prod`, `make build-apk-prod`, `make test`, `make ci-local`, etc.). Para correr cualquier comando rápido sin recordar la sintaxis de Flutter.
- `.gitignore` — completo: ignora `*.freezed.dart`, `*.g.dart`, `pubspec.lock`, Firebase credentials, `GeneratedPluginRegistrant.java`, `.env.backup`.

### CI/CD (GitHub Actions)
- `.github/workflows/ci.yml` — pipeline equivalente al de hey-support en GitLab, con 2 jobs:
  - **`test`** (todo PR + push): setup Flutter 3.35.0 → `pub get` → `build_runner` → `analyze` → `format check` → `flutter test --coverage` → sube `lcov.info` como artifact.
  - **`build`** (solo push a `main`/`develop`): valida que la app compila APK debug (dev) o release (prod).

### Tests (setup)
- `test/widget_test.dart` — smoke test del `ZafiraApp`.
- `test/helpers/http_test_dio.dart` — utilidades `stubDio()`, `stubDioOk()`, `stubDioError()` para mockear HTTP sin tocar red.
- Patrón documentado en `ai/rules/testing.md`: `mocktail` + `ProviderContainer` con `overrides`.

---

## 3. Qué NO está hecho (pendientes prioritarios)

| # | Tarea | Por qué importa | Donde se hace |
|---|-------|-----------------|---------------|
| 1 | **`AGENTS.md` raíz** que importe `@ai/RULES.md`, `@ai/STACK.md`, etc. | Sin esto, Cursor/Claude no encuentran las reglas | `zafira/AGENTS.md` |
| 2 | **Firebase init** en `common_main.dart` | Crashlytics, Analytics, Messaging | `lib/main/common_main.dart` (hay TODO marcado) |
| 3 | **App IDs nativos distintos** por flavor (`com.zafira.dev` / `com.zafira`) | Para instalar dev + prod en un mismo celular | `android/app/build.gradle.kts` + `ios/Runner.xcodeproj` |
| 4 | **Íconos por flavor** vía `flutter_launcher_icons` | Distinguir apps en el launcher | `pubspec.yaml` + assets |
| 5 | **Router con go_router** | Hoy solo hay una pantalla placeholder en `common_main.dart` | `lib/core/routes/` (a crear) |
| 6 | **Feature `auth`** real (login → `Flavor.server` → `ZAFIRA-CORE` JWT) | Único feature listado en `ai/context/mobile.md` | `lib/auth/` (clean arch: data/domain/application/view) |
| 7 | **HTTP client wrapper (`DioHttpClient`)** con interceptors (auth header, retry, logging) | Centraliza requests y errores | `lib/core/http/` (a crear) |
| 8 | **`ErrorExceptionHandler`** que traduce `DioException` → `Either<Exception, T>` | Patrón obligatorio en `ai/RULES.md` | `lib/core/error/` (a crear) |
| 9 | **Migrar a `envied`** (opcional) | Para no pasar 10+ `--dart-define` en cada `flutter run` | `lib/env/env.dart` + `pubspec.yaml` |
| 10 | **Codecov** para visualizar cobertura por PR | Hoy `lcov.info` queda como artifact; con Codecov salen los % en cada PR | secret en GH + step en `ci.yml` |
| 11 | **Limpiar el archivo legacy `lib/core/constants/colors/app_colors.dart`** | Sigue con colores `#662D91` púrpura de hey-support — debería usar paleta ZAFIRA | actualizar valores o redirigir a `helpers/app_colors.dart` |
| 12 | **FVM (Flutter Version Manager)** | Pinear Flutter 3.35.0 localmente (ya pinneado en CI). Útil si trabajás en >1 proyecto Flutter con versiones distintas | `.fvmrc` |
| 13 | **Activar GitHub Copilot code review** | Es la IA que revisa los PRs (reemplaza al reviewer de Gemini). Requiere Copilot Pro (gratis con GitHub Education) + habilitar el ruleset que pide review automática de Copilot | GH Settings → Rules → Rulesets |

### ✅ Hecho desde el último handoff
- ~~CI/CD~~ → `.github/workflows/ci.yml` con 2 jobs (test + build).
- ~~Setup de tests~~ → `test/widget_test.dart` + `test/helpers/http_test_dio.dart`. Patrón canónico en `ai/rules/testing.md`.
- ~~Reglas de UI/widgets~~ → `ai/rules/widget-design.md` con 10 secciones (tokens, screens, estados, formularios, checklist pre-PR).
- ~~`analysis_options.yaml`~~ → espejo del de hey-support sin `dart_code_metrics`.
- ~~`Makefile`~~ → 22 targets.
- ~~`.gitignore`~~ → ignora `*.freezed.dart`, `*.g.dart`, `pubspec.lock`, Firebase credentials, etc.
- ~~AI PR Reviewer (Gemini)~~ → **eliminado**. Se reemplazó por **GitHub Copilot code review** (IA nativa de GH). Las reglas Zafira que aplicaba el prompt ahora viven en `.github/copilot-instructions.md` para que Copilot las haga cumplir. Falta solo activar Copilot en el repo (ítem 13).

---

## 4. Decisiones tomadas (y por qué)

- **NO se usa `envied` todavía** — para no requerir `build_runner` en el setup inicial. Cuando haya >5 keys distintas por env, migrar.
- **`lib/core/helpers/colors.dart` Y `lib/core/helpers/app_colors.dart` coexisten** — espejo del patrón de hey-support. `AppColors` (instancia, granular, gradients/shadows) vs `AppPalette` (estática vía Material, semántica rápida). Ambas usan los mismos hex tokens del DESIGN_SYSTEM.
- **Symlink Claude/Codex no aplica acá** — el repo zafira ya está rebrandeado desde cero, no hay legacy de `Codex` que dedupear.
- **Banner DEV en runtime** vs ícono distinto — implementado el banner (rápido), íconos quedan pendientes (requieren tooling nativo).
- **Default `flutter run` arranca DEV** — para que el dev iterativo no necesite recordar el `-t`.

---

## 5. Conflictos / trampas conocidas

- **`lib/main.dart` estaba roto** con sintaxis inválida (`colorScheme: .fromSeed(...)`, `mainAxisAlignment: .center`). Fue reescrito completo. Si Cursor te lo regenera con el template default de Flutter, revertí.
- **`lib/core/constants/colors/app_colors.dart` legacy** todavía exporta `primaryColor = Color(0xFF662D91)` (púrpura hey-support). `app_theme.dart` lo consume vía `context.appColors.grayDark` (ya mapeado a slate ZAFIRA en `helpers/app_colors.dart`) — funciona pero hay que decidir si borrar el archivo legacy o dejarlo como shim.
- **`app_urls.dart` depende de `Flavor.hereMapApiKey`** — sin `--dart-define=HERE_MAP_KEY_DEV=...` el getter devuelve `''` y los HERE Maps no van a renderizar. No crashea, pero las imágenes vienen vacías.
- **El `flavors_config.dart` original estaba comentado entero** — fue descomentado/rehecho. Si alguien hace un revert mirando "el archivo original", va a romper `app_urls.dart`.

---

## 6. Cómo arrancar (cold start, sesión nueva)

```bash
cd C:\FAZQ\DEV\MOBILE\MULTIPLATFORM\zafira

# 1. Deps
flutter pub get

# 2. Analizar (debería pasar sin errores; si falla, mirá el legacy app_theme.dart)
flutter analyze

# 3. Correr en dev
flutter run -t lib/main/main_dev.dart

# Si tenés URLs reales, pasalas así:
flutter run -t lib/main/main_dev.dart \
  --dart-define=API_DEV=https://api-dev.zafira.com \
  --dart-define=HERE_MAP_KEY_DEV=AIza...
```

Vas a ver el logo ZAFIRA con gradient + el flavor activo + la URL configurada.

---

## 7. Archivos clave para abrir primero

Para entender el proyecto en 10 minutos, leé en este orden:

1. [ai/HANDOFF.md](./HANDOFF.md) — este archivo.
2. [ai/STACK.md](./STACK.md) — qué libs hay y por qué.
3. [ai/ARCHITECTURE.md](./ARCHITECTURE.md) — capas y dependencias.
4. [ai/RULES.md](./RULES.md) — reglas duras (Either, autoDispose, copyWith).
5. [ai/PATTERNS.md](./PATTERNS.md) — ejemplos canónicos por capa.
6. [lib/core/helpers/app_colors.dart](../lib/core/helpers/app_colors.dart) — paleta y design tokens.
7. [lib/core/flavors/flavors_config.dart](../lib/core/flavors/flavors_config.dart) — switch de entornos.
8. [lib/main/common_main.dart](../lib/main/common_main.dart) — donde se arma el root widget.

---

## 8. Cómo agregar un feature (resumen — ver `ai/PATTERNS.md` para detalle)

```
lib/<feature>/
├── data/
│   ├── services/<feature>_service.dart          ← Dio calls
│   ├── repositories/<feature>_repository.dart   ← implementa interface
│   ├── interfaces/<feature>_interface.dart      ← contrato abstract
│   └── dto/<feature>_dto.dart                   ← Freezed + JSON
├── domain/
│   └── model/<feature>_model.dart               ← Freezed (sin JSON)
├── application/
│   └── <feature>_usecase.dart                   ← retorna Either<Exception, T>
└── view/
    ├── controller/<feature>_controller.dart     ← StateNotifier autoDispose
    ├── state/<feature>_state.dart               ← Freezed
    ├── screens/<feature>_screen.dart            ← ConsumerWidget
    └── widgets/...
```

Reglas innegociables:
- UseCase **siempre** retorna `Either<Exception, T>`.
- Controller **siempre** `.fold(left, right)` con `isLoading: false` en AMBAS ramas.
- `copyWith` para mutaciones, nunca reemplazo de estado.
- Providers como constantes top-level (`final xxxProvider = ...`).

---

## 9. Quién toca qué (cuando el equipo crezca)

- **Branding y design tokens** → `lib/core/helpers/app_colors.dart` (mantener sincronizado con `ZAFIRA-CORE/docs/DESIGN_SYSTEM.md`).
- **HTTP / interceptors / errores globales** → `lib/core/` (a crear `http/` y `error/`).
- **Reglas y gobernanza** → `ai/`.
- **Features de producto** → `lib/<feature>/` con clean arch.

---

## 10. Contactos / referencias externas

- Backend Django: `ZAFIRA-CORE` (repo separado, WSL).
- Design system: `ZAFIRA-CORE/docs/DESIGN_SYSTEM.md`.
- Proyecto de referencia para patrones (NO copiar dominio): `hey-support` en `C:\FAZQ\DEV\MOBILE\ANDROID\hey-support`.
