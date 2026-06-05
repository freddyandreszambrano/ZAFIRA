# Command: review

## Purpose

Perform a strict code review against all rules defined in `/ai/rules/`.

## Execution Steps

1. Read `ai/rules/architecture.md` — verify layer separation
2. Read `ai/rules/api-contracts.md` — verify headers and Dio usage
3. Read `ai/rules/code-style.md` — verify naming and Either pattern
4. Read `ai/rules/testing.md` — verify test structure if tests are included

## Checklist

### Architecture

- [ ] Feature lives under `lib/feature/{name}/` with correct sub-structure
- [ ] Controllers call use cases only (not services or repositories)
- [ ] Services return `Either<Exception, T>`
- [ ] No business logic in widgets
- [ ] Routes added only in `lib/modules/app_module.dart`

### API

- [ ] All requests go through a `*Service` class
- [ ] Dio is injected — not instantiated inline
- [ ] `app-version` header present (via interceptor)
- [ ] Responses deserialized to typed models immediately

### Code Style

- [ ] Freezed models used — no raw `Map<String, dynamic>` as domain types
- [ ] `autoDispose` on screen-level controllers
- [ ] No scattered `try/catch` — `Either` used consistently
- [ ] No `print` statements

### Tests

- [ ] Dio mocked via `http_test_dio.dart`
- [ ] Each layer tested independently
- [ ] Both success and failure paths covered

## Output Format

For each violation:

```
VIOLATION: [rule name]
FILE: [path:line]
ISSUE: [what is wrong]
FIX: [exact correction]
```
