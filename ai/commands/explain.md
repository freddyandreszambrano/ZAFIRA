# Command: explain

## Purpose

Explain a piece of code in terms of the architecture defined in `/ai/rules/`.

## Execution Steps

1. Identify which layer the code belongs to
2. Describe what the layer is responsible for (per `ai/rules/architecture.md`)
3. Explain what this specific code does within that responsibility
4. Flag any deviations from the rules

## Output Format

```
LAYER: [service | repository | use case | controller | widget]
RESPONSIBILITY: [what this layer is supposed to do]
WHAT THIS CODE DOES: [plain description]
COMPLIANT: [yes | no]
VIOLATIONS (if any): [list with rule reference]
```

## Rules

- No speculative explanations — only what the code actually does
- Reference `ai/rules/` files for any architectural claim
- If the code violates a rule, cite the exact rule from `/ai/rules/`
- Keep explanations under 200 words unless complexity requires more
