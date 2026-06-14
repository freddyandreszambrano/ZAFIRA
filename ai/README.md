# ai/ — Zafira Governance

Carpeta de gobernanza para asistentes de IA (Claude, agentes) que trabajan en este repo. Define
arquitectura, reglas, patrones, diseño y contexto que cualquier sesión debe cargar antes de escribir
código.

## Load order recomendado

Antes de escribir código:

1. `HANDOFF.md` — estado actual del proyecto. **Léelo primero.**
2. `rules/architecture.md` → `rules/code-style.md` → `rules/api-contracts.md` → `rules/testing.md`
3. `context/mobile.md` → `context/backend.md` → `context/infra.md`

- ¿Vas a tocar **UI** (screens, widgets)? Cargá `design-system.md` + `rules/widget-design.md`.
- ¿Vas a tocar **tests**? Cargá `rules/testing.md`.
- ¿Necesitás un **ejemplo de código canónico** por capa? `PATTERNS.md`.

## Top-level

| Archivo            | Para qué                                                                 |
|--------------------|--------------------------------------------------------------------------|
| `HANDOFF.md`       | Estado actual: qué hay hecho, qué falta, trampas conocidas. **Primero.**  |
| `STACK.md`         | Inventario de dependencias y versiones (Flutter, Riverpod, Dio, etc.)    |
| `PATTERNS.md`      | Patrones canónicos por capa (service, repo, use case, controller, state) |
| `design-system.md` | Sistema de diseño **mobile**: colores, tipografía, componentes, estados  |

## Subcarpetas

### `rules/` — reglas tácticas por dominio

- `architecture.md` — estructura de feature, responsabilidades por capa, routing, entornos, DI
- `code-style.md` — naming, modelos Freezed, controllers, `Either`, async, logging
- `api-contracts.md` — headers obligatorios, setup de Dio, contrato de service, base URLs, multipart
- `testing.md` — estructura de tests, mocking de Dio (`stubDio*`), tests por capa (`ProviderContainer`)
- `widget-design.md` — reglas de UI: tokens del design system, screens, 4 estados, formularios, checklist

### `context/` — estado real del código y la infra

- `mobile.md` — stack móvil, módulos existentes, helpers, flavors, builds
- `backend.md` — backend Django + DRF que sirve la API; headers esperados
- `infra.md` — pipeline CI/CD, Docker, FVM, OTA

### `agents/` — sub-agentes especializados

- `reviewer.md` — review estricto contra `rules/`
- `debugger.md` — diagnóstico de bugs por capa
- `formatter.md` — reemplazo de magic numbers por tokens del design system

### `commands/` — protocolos invocables

- `review.md` — checklist completo de review
- `fix.md` — fix mínimo siguiendo `rules/`
- `explain.md` — explicar código en términos de la arquitectura
