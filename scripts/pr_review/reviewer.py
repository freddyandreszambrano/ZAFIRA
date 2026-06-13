#!/usr/bin/env python3
"""AI PR reviewer for GitHub — Zafira (Flutter). Stdlib-only.

Lee el diff de un PR, lo manda a un LLM (Gemini/OpenAI/OpenAI-compatible)
con un prompt que hace cumplir las reglas de `ai/rules/` y `ai/RULES.md`,
y postea comentarios inline + un summary con marker para evitar duplicados.

Espejo del patrón de `hey-support/scripts/mr_review/reviewer.py` (GitLab),
adaptado a:
  - GitHub PR API
  - stack Flutter (Riverpod, Freezed, Either, design tokens ZAFIRA)
"""

from __future__ import annotations

import json
import os
import re
import sys
import urllib.error
import urllib.request
from typing import Any

GITHUB_API = "https://api.github.com"
MARKER_PREFIX = "<!-- ai-review-marker: head_sha="
SEVERITIES = {"critical": "🔴", "improvement": "🟡", "suggestion": "🟢"}


# ── HTTP helpers ───────────────────────────────────────────────────────


def http(method: str, url: str, headers: dict, body: Any = None) -> dict:
    data = None
    if body is not None:
        data = json.dumps(body).encode("utf-8")
        headers = {**headers, "Content-Type": "application/json"}
    req = urllib.request.Request(url, data=data, method=method, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            raw = resp.read().decode("utf-8")
            return json.loads(raw) if raw else {}
    except urllib.error.HTTPError as e:
        sys.stderr.write(f"HTTP {e.code} on {method} {url}: {e.read().decode()}\n")
        raise


# ── GitHub API ─────────────────────────────────────────────────────────


def gh_headers(token: str) -> dict:
    return {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        "User-Agent": "zafira-pr-reviewer",
    }


def get_pr(repo: str, number: int, token: str) -> dict:
    return http("GET", f"{GITHUB_API}/repos/{repo}/pulls/{number}", gh_headers(token))


def get_pr_diff(repo: str, number: int, token: str) -> str:
    headers = {**gh_headers(token), "Accept": "application/vnd.github.v3.diff"}
    req = urllib.request.Request(
        f"{GITHUB_API}/repos/{repo}/pulls/{number}",
        headers=headers,
        method="GET",
    )
    with urllib.request.urlopen(req, timeout=60) as resp:
        return resp.read().decode("utf-8", errors="replace")


def list_pr_comments(repo: str, number: int, token: str) -> list:
    return http(
        "GET",
        f"{GITHUB_API}/repos/{repo}/issues/{number}/comments",
        gh_headers(token),
    ) or []


def post_issue_comment(repo: str, number: int, body: str, token: str) -> None:
    http(
        "POST",
        f"{GITHUB_API}/repos/{repo}/issues/{number}/comments",
        gh_headers(token),
        {"body": body},
    )


def post_review(
    repo: str,
    number: int,
    commit_id: str,
    body: str,
    comments: list,
    token: str,
) -> None:
    payload = {
        "commit_id": commit_id,
        "body": body,
        "event": "COMMENT",
        "comments": comments,
    }
    http(
        "POST",
        f"{GITHUB_API}/repos/{repo}/pulls/{number}/reviews",
        gh_headers(token),
        payload,
    )


# ── LLM providers ──────────────────────────────────────────────────────


def call_gemini(prompt: str, key: str, model: str) -> str:
    url = (
        "https://generativelanguage.googleapis.com/v1beta/models/"
        f"{model}:generateContent?key={key}"
    )
    payload = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {
            "temperature": 0.2,
            "responseMimeType": "application/json",
        },
    }
    resp = http("POST", url, {}, payload)
    return resp["candidates"][0]["content"]["parts"][0]["text"]


def call_openai_compat(prompt: str, key: str, model: str, base_url: str) -> str:
    payload = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.2,
        "response_format": {"type": "json_object"},
    }
    resp = http(
        "POST",
        f"{base_url}/chat/completions",
        {"Authorization": f"Bearer {key}"},
        payload,
    )
    return resp["choices"][0]["message"]["content"]


def call_llm(prompt: str) -> str:
    provider = os.environ["AI_PROVIDER"].lower()
    key = os.environ["AI_API_KEY"]
    if provider == "gemini":
        return call_gemini(
            prompt, key, os.environ.get("AI_MODEL", "gemini-1.5-flash")
        )
    if provider == "openai":
        return call_openai_compat(
            prompt,
            key,
            os.environ.get("AI_MODEL", "gpt-4o-mini"),
            "https://api.openai.com/v1",
        )
    if provider == "custom":
        return call_openai_compat(
            prompt,
            key,
            os.environ["AI_MODEL"],
            os.environ["AI_BASE_URL"].rstrip("/"),
        )
    raise SystemExit(f"AI_PROVIDER inválido: {provider}")


# ── Review logic ───────────────────────────────────────────────────────


PROMPT_TEMPLATE = """Eres revisor de código senior en un proyecto Flutter (Zafira).
Stack: Clean Architecture + Riverpod + Dio + Freezed + go_router + either_dart.

Reglas duras del proyecto (de `ai/RULES.md` y `ai/rules/`):

LAYER RULES
- Widget ↔ Controller vía `ref.watch` / `ref.read`. Widget NO llama services ni use cases directo.
- Controller → UseCase (NUNCA Service ni Repository directo).
- UseCase → Interface del Repository (`I*`), NUNCA implementación concreta.
- Service → `DioHttpClient`, NUNCA estado / controllers.
- Lógica de negocio vive en UseCase. NO en repos, services, ni controllers.

ERROR HANDLING
- UseCase SIEMPRE retorna `Either<Exception, T>`. Nunca throw desde useCase.
- Service NUNCA hace catch — propaga al ErrorExceptionHandler.
- Controller SIEMPRE `.fold(left, right)` con `isLoading: false` en AMBAS ramas.

STATE
- `copyWith` para CADA mutación de estado en Controller. Nunca reemplazar estado entero.
- Controllers screen-level con `StateNotifierProvider.autoDispose` (excepto auth/session).
- Providers como constantes top-level (nunca dentro de clases).

MODELOS
- Domain models usan Freezed. CADA field con `@Default`.
- `@JsonKey(name: 'snake_case')` si el field del API ≠ field Dart.
- DTOs en `data/`, Domain Models en `domain/`. UseCases mapean DTO → Model.
- NUNCA editar `*.freezed.dart` ni `*.g.dart` (autogenerados).

HTTP
- NUNCA Dio directo en features. Siempre `ref.watch(dioHttpClientProvider)`.
- URL paths como constantes en el archivo del service.
- Loguear CADA request/response con `DebugLogger`.

UI / WIDGETS (ai/rules/widget-design.md)
- NUNCA `Color(0xFF...)` hardcoded. Siempre `context.appColors.<token>`.
- NUNCA `TextStyle(fontSize: ..., color: ...)` literal. Siempre `context.typography.<style>`.
- NUNCA `MaterialColor`/`Colors.purple` etc. — usar tokens ZAFIRA.
- Screen DEBE manejar 4 estados (loading / empty / error / success) con `switch` exhaustivo.
- Trailing commas SIEMPRE (lint `require_trailing_commas: true`).
- Constructores primero en cada clase (lint `sort_constructors_first: true`).
- Imports relativos dentro de `lib/<feature>/...` (lint `prefer_relative_imports`).
- Widget > 200 LOC = partir en sub-widgets privados.

TESTS (ai/rules/testing.md)
- Service test: usar `stubDio*` de `test/helpers/http_test_dio.dart`. NUNCA mockear Dio a mano.
- Controller test: `ProviderContainer` con `overrides` + `addTearDown(c.dispose)`.
- Mocks con `mocktail` (no `mockito`). `registerFallbackValue` para tipos custom.
- NUNCA `print(...)` en tests.

PROHIBIDO
- `setState` en `ConsumerWidget`.
- `Navigator.push` directo (usar `go_router`).
- Strings hardcoded en UI sin extraer a `l10n` o constantes.
- Editar archivos `*.freezed.dart` o `*.g.dart`.

Revisa este diff de un PR y devuelve SOLO un JSON válido con esta forma:
{{
  "summary": "1-3 frases sobre el cambio global",
  "findings": [
    {{
      "path": "ruta/relativa.dart",
      "line": 42,
      "severity": "critical|improvement|suggestion",
      "message": "qué está mal y cómo arreglarlo (cita la regla del proyecto)"
    }}
  ]
}}

Reglas del review:
- Máximo 8 findings, ordenados por severidad.
- Solo comenta LÍNEAS QUE APARECEN COMO AÑADIDAS (+) en el diff.
- Si no hay nada que comentar, devuelve findings: [].
- `severity` = `critical` solo si rompe contrato/build/seguridad o salta capa.
- `severity` = `improvement` para violaciones de reglas duras (ej: hex hardcoded, falta `copyWith`).
- `severity` = `suggestion` para nice-to-have o estilo.
- IGNORÁ cambios en `*.freezed.dart`, `*.g.dart`, `pubspec.lock` (autogenerados).

Diff:
```
{diff}
```
"""


def already_reviewed(comments: list, head_sha: str) -> bool:
    marker = f"{MARKER_PREFIX}{head_sha}"
    return any(marker in (c.get("body") or "") for c in comments)


def truncate(s: str, n: int) -> str:
    if len(s) <= n:
        return s
    return s[:n] + f"\n\n[diff truncado: {len(s) - n} chars omitidos]"


def parse_llm_json(raw: str) -> dict:
    raw = raw.strip()
    raw = re.sub(r"^```(?:json)?\s*|\s*```$", "", raw, flags=re.MULTILINE)
    return json.loads(raw)


def main() -> int:
    repo = os.environ["GITHUB_REPOSITORY"]
    pr_number = int(os.environ["PR_NUMBER"])
    gh_token = os.environ["GITHUB_TOKEN"]
    max_chars = int(os.environ.get("MAX_DIFF_CHARS", "40000"))

    pr = get_pr(repo, pr_number, gh_token)
    head_sha = pr["head"]["sha"]

    if already_reviewed(list_pr_comments(repo, pr_number, gh_token), head_sha):
        print(f"PR #{pr_number} ya revisado para {head_sha[:8]} — skip.")
        return 0

    diff = truncate(get_pr_diff(repo, pr_number, gh_token), max_chars)
    raw = call_llm(PROMPT_TEMPLATE.format(diff=diff))
    review = parse_llm_json(raw)

    findings = review.get("findings", []) or []
    summary = review.get("summary", "Sin observaciones.")

    inline = []
    for f in findings[:8]:
        sev = f.get("severity", "suggestion")
        icon = SEVERITIES.get(sev, "🟢")
        body = f"{icon} **{sev}** — {f.get('message', '')}"
        if f.get("path") and f.get("line"):
            inline.append(
                {
                    "path": f["path"],
                    "line": int(f["line"]),
                    "side": "RIGHT",
                    "body": body,
                }
            )

    marker = f"{MARKER_PREFIX}{head_sha} -->"
    summary_body = f"🤖 **AI Review (Zafira)**\n\n{summary}\n\n{marker}"

    if inline:
        post_review(repo, pr_number, head_sha, summary_body, inline, gh_token)
    else:
        post_issue_comment(repo, pr_number, summary_body, gh_token)

    print(f"PR #{pr_number} revisado: {len(inline)} findings inline.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
