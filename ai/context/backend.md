# Backend Context

## Stack

- **Framework**: Django + Django REST Framework
- **Async tasks**: Celery
- **Architecture**: Service-layer based

Zafira's backend is the ZAFIRA-CORE administrative platform, which exposes REST endpoints for
authentication, modules (dynamic dashboard sections), groups (roles), and per-group permissions.

## Layer Rules (Backend)

### Views

- Orchestrate only: parse request → call service → return response
- No direct model queries
- No business logic

### Services (`services/`)

- All business logic lives here
- One service per domain concept
- Called from views — not from serializers

### Serializers

- Validate input and format output only
- No database access
- No business logic

## API Design

- RESTful endpoints
- All responses consumed by the Flutter app must include proper error structure
- Versioned paths: `/api/v1/`, `/api/v2/`

## Headers Expected by Backend

The backend validates these headers on every request from the mobile app:

| Header        | Description                        |
|---------------|------------------------------------|
| `app-version` | Mobile app version (e.g. `1.0.0`)  |

Missing headers result in `400` or `401` responses.

## Integration Points

The Flutter app communicates with this backend via Dio.
All service classes in `lib/feature/*/data/services/` target this backend's endpoints.

<TODO: documentar los endpoints concretos (auth, módulos dinámicos, grupos, permisos) a medida que
se conecten desde la app.>
