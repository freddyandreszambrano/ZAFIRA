# Command: fix

## Purpose

Fix a reported violation or bug following all constraints in `/ai/rules/`.

## Execution Steps

1. Identify the layer of the broken code (service / repository / use case / controller / widget)
2. Read the relevant rule file before writing any fix
3. Apply the minimal change that resolves the issue
4. Do not refactor surrounding code unless it causes the bug
5. Do not add new abstractions — use existing patterns

## Fix Protocol by Layer

### Service

- Wrap in `try/catch` returning `Left(Exception(...))`
- Ensure Dio is injected, not instantiated

### Use Case

- Delegate to repository interface only
- Return `Either<Exception, T>`
- No Dio, no HTTP logic

### Controller

- Use `.fold()` on Either result
- Set `isLoading` before async call, clear after
- Never call service or repository directly

### Widget

- Move any logic to controller
- Widget only calls `ref.read(provider.notifier).method()`

## Output Format

```
FILE: [path]
CHANGE: [one-line description]
BEFORE:
[original code]
AFTER:
[fixed code]
RULE APPLIED: [ai/rules/filename.md — section]
```
