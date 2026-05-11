# Running the App — Developer Guide

## Prerequisites

### Backend
- [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9)
- [EF Core tools](https://learn.microsoft.com/en-us/ef/core/cli/dotnet): `dotnet tool install --global dotnet-ef`

### Frontend
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x)
- Android Studio / Xcode (for device simulators)
- A connected device or emulator

---

## 1. Backend Setup (`appt_api/`)

### Step 1 — Environment variables

Create a `.env` file inside `appt_api/` (copy the template below). This file is gitignored — never commit it.

```env
ConnectionStrings__DefaultConnection=Host=<supabase-host>;Port=5432;Database=postgres;Username=postgres;Password=<password>;SSL Mode=Require;Trust Server Certificate=true
JwtSettings__SecretKey=<any-long-random-string-min-32-chars>
```

> Get the connection string from your Supabase project → Settings → Database → Connection string (URI mode, change to Key=Value format).

### Step 2 — Apply database migrations

Run this once (and again whenever new migrations are added):

```bash
cd appt_api
dotnet ef database update --project src/ApptApi.Infrastructure --startup-project src/ApptApi.API
```

### Step 3 — Run the backend

```bash
cd appt_api
dotnet run --project src/ApptApi.API
```

The API starts at **`http://localhost:5276`**

Swagger UI is available at: `http://localhost:5276/swagger`

### Useful backend commands

| Command | Description |
|---|---|
| `dotnet build` | Compile and check for errors |
| `dotnet test` | Run all tests |
| `dotnet ef migrations add <Name> --project src/ApptApi.Infrastructure --startup-project src/ApptApi.API` | Create a new migration |
| `dotnet ef database update --project src/ApptApi.Infrastructure --startup-project src/ApptApi.API` | Apply pending migrations |
| `dotnet ef migrations remove --project src/ApptApi.Infrastructure --startup-project src/ApptApi.API` | Undo last migration (before applying) |

---

## 2. Frontend Setup (`appt_app/`)

### Step 1 — Install dependencies

```bash
cd appt_app
flutter pub get
```

### Step 2 — Run the app

```bash
flutter run
```

To target a specific device:

```bash
flutter devices          # list connected devices
flutter run -d <device-id>
```

### Step 3 — Backend URL

The app points to `http://localhost:5276` by default (`lib/core/constants/api_constants.dart`).

- **iOS Simulator:** `localhost` works out of the box.
- **Android Emulator:** Use `http://10.0.2.2:5276` instead of `localhost`.
- **Physical device:** Use your machine's local IP (e.g. `http://192.168.x.x:5276`) — make sure both are on the same Wi-Fi network.

### Useful Flutter commands

| Command | Description |
|---|---|
| `flutter pub get` | Install/update packages |
| `flutter analyze` | Run the linter |
| `flutter test` | Run unit tests |
| `flutter run --release` | Run in release mode |
| `flutter build apk` | Build Android APK |
| `flutter build ios` | Build iOS (requires Xcode) |
| `dart run build_runner build --delete-conflicting-outputs` | Regenerate Freezed / Riverpod code after model changes |

---

## 3. Running Both Together

Open two terminal windows:

**Terminal 1 — Backend:**
```bash
cd appt_api
dotnet run --project src/ApptApi.API
```

**Terminal 2 — Frontend:**
```bash
cd appt_app
flutter run
```

---

## 4. Common Issues

| Problem | Fix |
|---|---|
| `Connection refused` on Android emulator | Change `baseUrl` in `api_constants.dart` to `http://10.0.2.2:5276` |
| `Invalid JWT secret` error | Make sure `JwtSettings__SecretKey` in `.env` is at least 32 characters |
| Migration fails | Confirm `ConnectionStrings__DefaultConnection` in `.env` is correct and Supabase DB is reachable |
| Flutter build fails after pulling | Run `flutter pub get` and then `dart run build_runner build --delete-conflicting-outputs` |
| `google_sign_in` not working | Complete the Google Cloud Console setup — see `GOOGLE_SIGNIN_SETUP.md` |
