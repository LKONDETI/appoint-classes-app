# ApptClass — Claude Code Project Instructions

## Project Overview
Appointment booking app for fitness/activity classes.
- **Frontend:** Flutter (Dart) — `appt_app/`
- **Backend:** .NET 9 (C#) — `appt_api/`
- **Database:** Supabase (PostgreSQL via Npgsql + EF Core)

---

## Agent Variables

These values are injected into all agent prompts automatically.

```
TECH_STACK        = Flutter (Dart) + .NET 9 (C#) + Supabase PostgreSQL
PROJECT_TYPE      = mobile appointment booking app
LANG              = Dart (frontend) / C# (backend)
BUILD_COMMAND     = flutter analyze (frontend) / dotnet build (backend)
ARCHITECTURE_LAYERS = Domain → Application → Infrastructure → API (backend) | features/auth/data/domain/presentation (frontend)
```

### Coding Standards
- **Flutter/Dart:** Clean Architecture per feature (data/domain/presentation), Riverpod for state, GoRouter for navigation, Freezed + JSON for models, no print in production
- **C#/.NET:** Clean Architecture (Domain/Application/Infrastructure/API), repository pattern, FluentValidation on all request DTOs, async/await throughout, guard clauses over nested ifs
- **Both:** No abbreviations in names, no magic strings, no dead code, small focused methods

---

## Automatic Agent Orchestration

**Use the `orchestrator` agent for any full task.** It automatically chains:

| Task type | Pipeline |
|---|---|
| New feature / screen / endpoint | task-planner → architect → coding-expert → code-reviewer → security-reviewer → testing-expert → task-summarizer |
| Bug fix | task-planner → coding-expert → code-reviewer → task-summarizer |
| Refactor | task-planner → architect → coding-expert → code-reviewer → task-summarizer |
| Code review only | code-reviewer → security-reviewer → task-summarizer |
| Add tests | testing-expert → task-summarizer |

You can invoke the orchestrator explicitly:
- `"orchestrate: add booking cancellation feature"`
- `"full pipeline: fix the login redirect bug"`
- Or just describe the task — the orchestrator will pick the right pipeline

---

## Project Structure

```
appt_class/
├── appt_app/                        # Flutter frontend
│   └── lib/
│       ├── core/
│       │   ├── constants/           # API endpoints
│       │   ├── network/             # Dio client + auth interceptor
│       │   ├── providers/           # Core Riverpod providers
│       │   ├── router/              # GoRouter + auth redirect
│       │   ├── storage/             # Secure token storage
│       │   └── theme/               # Material3 theme
│       └── features/
│           └── <feature>/
│               ├── data/            # datasources, models, repositories
│               ├── domain/          # entities, repository interfaces
│               └── presentation/    # providers, screens, widgets
└── appt_api/                        # .NET backend
    └── src/
        ├── ApptApi.API/             # Controllers, validators, middleware
        ├── ApptApi.Application/     # Services, DTOs, interfaces
        ├── ApptApi.Domain/          # Entities, repository interfaces
        └── ApptApi.Infrastructure/  # EF Core, repositories, external services
```

---

## Key Patterns to Follow

### Flutter
- New features go in `lib/features/<feature>/data|domain|presentation`
- State = `StateNotifier` + sealed `XState` class (see `auth_provider.dart`)
- Repository interface in domain, implementation in data
- `AuthResponseModel` uses Freezed + `fromJson` — run `build_runner` after model changes
- HTTP calls only in datasources, never directly in providers

### .NET Backend
- New endpoints: Controller → Service interface → Service implementation → Repository interface → Repository
- All requests validated with FluentValidation (`AbstractValidator<T>`)
- Exceptions: use `AppException` subclasses (`ConflictException`, `UnauthorizedException`, `NotFoundException`) — `ExceptionMiddleware` maps them to HTTP status codes automatically
- EF migrations: `dotnet ef migrations add <Name> --project src/ApptApi.Infrastructure --startup-project src/ApptApi.API`
- Apply migrations: `dotnet ef database update --project src/ApptApi.Infrastructure --startup-project src/ApptApi.API`

---

## Auth Flow (Reference)
1. Flutter → `POST /api/auth/login` or `/register` or `/social` → backend returns `{ token, expiresAt, user }`
2. Token stored in platform keychain via `SecureStorageService`
3. `AuthInterceptor` adds `Authorization: Bearer <token>` to every request
4. On 401 → token cleared → user redirected to login
5. Google Sign-In: Flutter gets ID token from `google_sign_in` → sends to `POST /api/auth/social` → backend verifies with Google → returns custom JWT

---

## Pending Setup (Google Sign-In)
See `GOOGLE_SIGNIN_SETUP.md` for full instructions. Outstanding items:
- Add `google-services.json` to `android/app/`
- Add google-services plugin to Android Gradle files
- Add `GoogleService-Info.plist` + URL scheme to iOS
- Fill in `Google.ClientId` in `appsettings.json`
- Run DB migration: `dotnet ef database update ...`
