# ai/ — Zafira Governance

Carpeta de gobernanza para asistentes de IA (Claude, agentes) que trabajan en este repo. Define
arquitectura, reglas, patrones y contexto que cualquier sesión debe cargar antes de escribir código.

## Top-level

| Archivo            | Para qué                                                                |
|--------------------|-------------------------------------------------------------------------|
| `HANDOFF.md`       | Estado actual del proyecto, qué hay hecho, qué falta. **Léelo primero**. |
| `RULES.md`         | Reglas duras del proyecto (capas, errores, estado, modelos, HTTP, etc.) |
| `STACK.md`         | Inventario de dependencias y versiones (Flutter, Riverpod, Dio, etc.)   |
| `ARCHITECTURE.md`  | Estructura de carpetas, capas por feature, flujo de datos, DI           |
| `PATTERNS.md`      | Patrones canónicos (service, repo, use case, controller, state, etc.)   |
| `CONVENTIONS.md`   | Identidad del proyecto + load order + reglas absolutas + prohibiciones  |

## Subcarpetas

### `rules/`
Reglas atómicas por dominio — se cargan en el load order definido en `CONVENTIONS.md`.

- `architecture.md` — estructura de feature, responsabilidades por capa, routing, entornos
- `code-style.md` — naming, modelos Freezed, controllers, Either, async
- `api-contracts.md` — headers obligatorios, setup de Dio, contrato de service, base URLs
- `testing.md` — estructura de tests, mocking de Dio, tests por capa (con `stubDio*` y `ProviderContainer`)
- `widget-design.md` — reglas de UI: tokens del design system, screens, states, formularios

### `context/`
Contexto vivo sobre el estado real del código y la infra.

- `mobile.md` — stack móvil, módulos existentes, helpers, flavors, builds
- `backend.md` — backend Django + DRF que sirve la API; headers esperados
- `infra.md` — pipeline CI/CD, Docker, FVM, OTA (en gran parte planeado)

### `governance/`
Reglas transversales que aplican a todas las capas y plataformas.

- `GLOBAL_RULES.md` — null safety, logging, secretos, naming, releases
- `LAYER_ENFORCEMENT.md` — dirección permitida de dependencias, llamadas prohibidas
- `API_STANDARDS.md` — headers, base URL, timeouts, multipart, autenticación
- `ASYNC_HANDLING.md` — patrón estándar de controller async, paralelismo, streams
- `INFRA_REQUIREMENTS.md` — Flutter version, Docker, CI, secrets, distribución

### `agents/`
Identidades y protocolos para sub-agentes especializados.

- `reviewer.md` — review estricto contra `rules/`
- `debugger.md` — diagnóstico de bugs por capa
- `formatter.md` — reemplazo de magic numbers por constantes del design system

### `commands/`
Comandos invocables que orquestan un protocolo concreto.

- `review.md` — checklist completo de review
- `fix.md` — fix mínimo siguiendo `rules/`
- `explain.md` — explicar código en términos de la arquitectura

## Load order recomendado

Definido en `CONVENTIONS.md`. Antes de escribir código: `HANDOFF.md` → `CONVENTIONS.md` → `rules/*` → `context/*`.

Si vas a tocar UI (screens, widgets): cargá obligatoriamente `rules/widget-design.md`.
Si vas a tocar tests: cargá obligatoriamente `rules/testing.md`.
