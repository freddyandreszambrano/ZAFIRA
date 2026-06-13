# scripts/pr_review/

AI-powered Pull Request reviewer para **Zafira (Flutter)**. Comenta inline en
los archivos cambiados de un PR usando un LLM (Gemini / OpenAI / cualquier API
compatible con OpenAI).

El bot hace cumplir las reglas declaradas en `ai/rules/` y `ai/RULES.md`:
clean architecture, Either<Exception, T>, copyWith, design tokens ZAFIRA,
trailing commas, prefer_relative_imports, etc.

---

## Cómo se activa

Se dispara en cada `pull_request` (open / synchronize / reopened) vía el
workflow `.github/workflows/ai-review.yml`. Sale automático cuando alguien
abre o pushea a un PR — no hay que ejecutar nada manual.

Para evitar reviews duplicados sobre el mismo commit, el script deja un marker
con el `head_sha` y skipea si ya existe.

---

## Variables de entorno

| Var | Obligatorio | Descripción |
|-----|-------------|-------------|
| `GITHUB_TOKEN` | sí | Token con permiso `pull-requests: write`. GH Actions lo provee. |
| `GITHUB_REPOSITORY` | sí | `owner/repo` (GH Actions lo expone). |
| `PR_NUMBER` | sí | Número del PR. |
| `AI_PROVIDER` | sí | `gemini` \| `openai` \| `custom`. |
| `AI_API_KEY` | sí | Key del provider. Setear como **secret** en GH. |
| `AI_MODEL` | no | Default por provider (`gemini-1.5-flash`, `gpt-4o-mini`). |
| `AI_BASE_URL` | solo `custom` | Endpoint OpenAI-compatible (OpenRouter, Ollama, etc.). |
| `MAX_DIFF_CHARS` | no | Trunca diff si excede. Default `40000`. |

---

## Setup en este repo

### 1. Generar API key del provider (Gemini, gratis)

1. Andá a https://aistudio.google.com/apikey
2. Login con tu cuenta Google.
3. **Create API key** → "Create API key in new project".
4. Copiá la key (empieza con `AIza...`).

**Free tier:** 15 RPM, 1500 requests/día. Más que suficiente para PRs reales.

### 2. Configurar el secret en GitHub

1. Repo en GH → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**.
2. **Name:** `AI_API_KEY`
3. **Secret:** pegá la key.
4. (Opcional) si querés cambiar el modelo, editá `AI_MODEL` en `.github/workflows/ai-review.yml`.

### 3. Probarlo

Abrí un PR (aunque sea con un cambio chico). En 30-60s vas a ver:

- Un comentario con summary "🤖 AI Review (Zafira)".
- Si hay observaciones, comentarios inline con severidad: 🔴 critical, 🟡 improvement, 🟢 suggestion.

---

## Uso local (para testear el script sin abrir un PR)

```bash
export GITHUB_TOKEN=ghp_xxx
export GITHUB_REPOSITORY=FreddyAndres/zafira
export PR_NUMBER=42
export AI_PROVIDER=gemini
export AI_API_KEY=AIza...
python scripts/pr_review/reviewer.py
```

Necesitás Python 3.11+ (stdlib only, no `pip install`).

---

## Severidades

Cada comentario inline lleva prefijo:

- 🔴 **critical** — rompe contrato/build/seguridad, o cruza capas (ej: widget llama service directo).
- 🟡 **improvement** — viola regla dura (ej: hex hardcoded, falta `copyWith`, falta `isLoading: false` en una rama del fold).
- 🟢 **suggestion** — nice-to-have, mejora de estilo, naming.

El bot ignora archivos autogenerados (`*.freezed.dart`, `*.g.dart`, `pubspec.lock`).

---

## Cuánto cuesta

**$0** en el tier gratis de Gemini (15 RPM / 1500/día). Para equipos chicos
con 5-10 PRs por semana sobra mucho. Si llegás a 100+ PRs/día y necesitás un
modelo más capaz (Gemini 1.5 Pro, GPT-4o), pasás a tier pago — ~$0.001 por PR.

---

## Cómo ajustar lo que revisa

El prompt del bot vive en `reviewer.py` → constante `PROMPT_TEMPLATE`. Si
agregás una regla nueva en `ai/rules/`, sumala también ahí entre las secciones
LAYER RULES / UI / WIDGETS / TESTS / PROHIBIDO. El bot no lee `ai/rules/*.md`
automáticamente — la lista vive embebida en el prompt para que la respuesta del
LLM sea predecible y cacheable.

---

## Inspiración

Patrón portado de `hey-support/scripts/mr_review/reviewer.py` (GitLab MR
reviewer, 423 líneas), simplificado y adaptado a:
- GitHub PR API.
- Stack Flutter (Riverpod, Freezed, design tokens ZAFIRA).
