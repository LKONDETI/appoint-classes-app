# ApptClass

A full-stack appointment / class scheduling mobile app built with **Flutter** (frontend) and **.NET 9** (REST API), backed by **PostgreSQL** (Supabase).

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile App | Flutter 3.x + Riverpod + GoRouter |
| REST API | .NET 9 · ASP.NET Core · Clean Architecture |
| Database | PostgreSQL (Supabase) · EF Core 9 |
| Auth | JWT Bearer tokens · BCrypt password hashing |
| Containerisation | Docker · docker-compose |

---

## Project Structure

```
appt_class/
├── appt_app/               # Flutter mobile application
│   └── lib/
│       ├── core/           # Shared utilities (Dio client, router, providers, constants)
│       └── features/
│           ├── auth/       # Login · Register · Splash
│           ├── home/       # Home dashboard
│           └── profile/    # View & edit user profile
│
├── appt_api/               # .NET 9 REST API
│   └── src/
│       ├── ApptApi.API/            # Controllers · Middleware · Validators · Program.cs
│       ├── ApptApi.Application/    # Services · DTOs · Interfaces
│       ├── ApptApi.Domain/         # Entities · Domain interfaces
│       └── ApptApi.Infrastructure/ # EF Core DbContext · Repositories · JWT service
│
└── docker-compose.yml      # Runs the API on port 5276
```

---

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.19
- [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (for running the API via Docker)
- A PostgreSQL database (the project is configured for [Supabase](https://supabase.com))

---

## Getting Started

### 1. Configure the API

Create `appt_api/.env` (or copy the template) with your credentials:

```env
ConnectionStrings__DefaultConnection=Host=<host>;Port=5432;Database=postgres;Username=postgres;Password=<password>;SSL Mode=Require;Trust Server Certificate=true
JwtSettings__SecretKey=<at-least-32-character-secret>
```

> **Never commit `.env` to source control.** It is already listed in `.gitignore`.

### 2. Run the API

**Option A – Docker (recommended)**

```bash
docker-compose up --build
# API available at http://localhost:5276
```

**Option B – .NET CLI**

```bash
cd appt_api
dotnet run --project src/ApptApi.API
# API available at http://localhost:5276
```

Swagger UI is served at `http://localhost:5276/swagger`.

### 3. Run the Flutter App

```bash
cd appt_app
flutter pub get
flutter run
```

The app connects to `http://localhost:5276` by default (see `lib/core/constants/api_constants.dart`).  
When running on a **physical Android device**, change `baseUrl` to your machine's local IP (e.g. `http://192.168.x.x:5276`).

---

## API Endpoints

| Method | Path | Auth | Description |
|---|---|---|---|
| `POST` | `/api/auth/register` | ❌ | Create a new account |
| `POST` | `/api/auth/login` | ❌ | Obtain a JWT token |
| `GET` | `/api/profile` | ✅ Bearer | Get the authenticated user's profile |
| `PUT` | `/api/profile` | ✅ Bearer | Update display name, bio, phone, avatar |

### Example – Register

```http
POST /api/auth/register
Content-Type: application/json

{
  "displayName": "Jane Doe",
  "email": "jane@example.com",
  "password": "SecurePass123"
}
```

Response `201 Created`:

```json
{
  "token": "<jwt>",
  "expiresAt": "2026-05-10T18:00:00Z",
  "user": {
    "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "email": "jane@example.com",
    "displayName": "Jane Doe"
  }
}
```

---

## Architecture Overview

### Flutter app (Clean Architecture)

```
Presentation  →  StateNotifier (Riverpod)  →  Repository interface
                                                       ↓
Data layer    →  RemoteDataSource (Dio)     →  Repository impl
```

- **GoRouter** with `refreshListenable` re-evaluates redirects whenever auth state changes.
- **AuthInterceptor** automatically attaches the stored JWT to every request and calls `logout()` on a `401` response.
- **flutter_secure_storage** persists the JWT between app restarts.

### .NET API (Clean Architecture)

```
Controllers  →  Services (Application)  →  Repositories (Infrastructure)  →  EF Core  →  PostgreSQL
```

- **FluentValidation** validates all request bodies; invalid requests return `400 Bad Request` automatically.
- **ExceptionMiddleware** maps domain exceptions to HTTP status codes:
  - `ConflictException` → `409`
  - `UnauthorizedException` → `401`
  - `NotFoundException` → `404`
  - Unhandled → `500`

---

## Running Tests

```bash
# API tests
cd appt_api
dotnet test

# Flutter tests
cd appt_app
flutter test
```

---

## Known Limitations / Future Work

- Session restore after app restart currently requires re-login (the token is preserved in secure storage but the user object is not yet persisted; a full restore would decode the JWT and populate the auth state).
- No appointment / class booking feature yet — auth and profile are the foundation.
- Push notifications and calendar sync are planned.
