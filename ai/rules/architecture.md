# Architecture Rules

## Feature Structure (Mandatory)

Every feature lives under `lib/feature/{name}/` with this exact layout:

```
lib/feature/{name}/
├── application/          # Use cases
├── data/
│   ├── interfaces/       # Abstract repository contracts (I*Repository)
│   ├── repositories/     # Concrete implementations
│   └── services/         # Dio-based API calls only
├── domain/               # Freezed models
└── view/
    ├── controller/       # StateNotifier subclasses
    ├── state/            # Freezed state classes
    └── widget/           # Dumb UI components
```

Shared code lives in `lib/helpers/` (same sub-structure).
App-wide config, theming, and constants live in `lib/core/`.

## Layer Responsibilities

### Service (`data/services/`)

- Executes HTTP calls via injected Dio instance
- Returns `Either<Exception, T>`
- No state, no business logic
- One class per API resource group

### Repository (`data/repositories/`)

- Implements `I*Repository` interface from `data/interfaces/`
- Delegates to the service
- No HTTP logic
- Swappable for testing

### Use Case (`application/`)

- Orchestrates one or more repository calls
- Contains the only business logic allowed
- Returns `Either<Exception, T>` or a domain model
- One use case per user action

### Controller (`view/controller/`)

- Extends `StateNotifier<*State>`
- Calls use cases only — never services or repositories directly
- Mutates state via `copyWith`
- `autoDispose` on all screen-level controllers
- Providers declared as `static final` at top of file

### Widget (`view/widget/`)

- Renders state — no logic
- Reads providers via `ref.watch`
- Triggers controller methods via `ref.read`

## Cross-Feature Dependencies

- Features must not import from each other's `data/` or `application/` layers
- Shared domain types go in `lib/helpers/` or `lib/core/`
- No circular dependencies between features

## Routing

- All routes defined in `lib/modules/app_module.dart`
- Route name constants are `static final` fields on each screen class
- No inline route strings anywhere else

## Environments

- Entry points: `lib/main/main_dev.dart`, `main_stg.dart`, `main_prod.dart`
- Shared init in `lib/main/common_main.dart`
- Flavor config in `lib/core/flavors/flavors_config.dart`
- Env vars via `envied` from `.env` — generated to `lib/env/env.g.dart`, never edited manually
