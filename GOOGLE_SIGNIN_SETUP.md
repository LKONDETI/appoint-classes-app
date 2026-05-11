# Google Sign-In Implementation — Handoff Document

## Overview

We added Google Sign-In to the app using a **custom backend approach**:
- Flutter gets a Google ID token via the `google_sign_in` SDK
- Flutter sends that token to our own `.NET` backend (`POST /api/auth/social`)
- The backend verifies it with Google's servers and returns our own custom JWT
- Everything else (token storage, auth interceptor, navigation) stays exactly the same

This approach was chosen over "Supabase Auth direct" because our `.NET` backend already has its own JWT system. Replacing it would have broken the existing auth flow, profile endpoints, and interceptors.

> **Note:** Google Cloud Console setup is required for ALL Google Sign-In approaches — including Supabase Auth. Google OAuth is completely free for any number of users.

---

## What Was Done (Already Implemented)

### Backend (.NET — `appt_api/`)

| File | Change |
|---|---|
| `ApptApi.Infrastructure.csproj` | Added `Google.Apis.Auth` NuGet package |
| `appsettings.json` | Added `Google.ClientId` config section (value to be filled in) |
| `src/ApptApi.Application/Common/GoogleSettings.cs` | New settings class for Google config |
| `src/ApptApi.Domain/Entities/User.cs` | `PasswordHash` made nullable; added `Provider` + `ProviderId` fields; new `CreateSocialUser()` factory method |
| `src/ApptApi.Infrastructure/Persistence/AppDbContext.cs` | Updated EF mappings: nullable password, new `provider` and `provider_id` columns, partial unique index |
| `src/ApptApi.Application/Services/AuthService.cs` | Null guard on `PasswordHash` for login; new `SocialAuthAsync()` method |
| `src/ApptApi.Application/Services/Interfaces/IAuthService.cs` | Added `SocialAuthAsync` to interface |
| `src/ApptApi.Application/Services/Interfaces/IGoogleTokenVerifier.cs` | New interface + `GoogleTokenPayload` record |
| `src/ApptApi.Infrastructure/Services/GoogleTokenVerifier.cs` | Verifies Google ID tokens using `GoogleJsonWebSignature.ValidateAsync` |
| `src/ApptApi.Domain/Interfaces/IUserRepository.cs` | Added `GetByProviderIdAsync` |
| `src/ApptApi.Infrastructure/Repositories/UserRepository.cs` | Implemented `GetByProviderIdAsync` |
| `src/ApptApi.Application/DTOs/Auth/SocialAuthRequest.cs` | New DTO: `{ IdToken, Provider }` |
| `src/ApptApi.API/Controllers/AuthController.cs` | New `POST /api/auth/social` endpoint |
| `src/ApptApi.API/Validators/SocialAuthRequestValidator.cs` | FluentValidation for the new endpoint |
| `src/ApptApi.API/Program.cs` | Registered `GoogleSettings` and `IGoogleTokenVerifier` |
| `src/ApptApi.Infrastructure/Migrations/AddSocialAuth` | EF migration (generated, not yet applied to DB) |

**Database changes in the migration (not applied yet):**
- `users.password_hash` — changed from `NOT NULL` to nullable
- `users.provider` — new column `VARCHAR(20) NOT NULL DEFAULT 'email'`
- `users.provider_id` — new column `VARCHAR(256) NULL`
- Unique partial index on `provider_id WHERE provider_id IS NOT NULL`

**Email collision policy:** If someone tries to sign in with Google using an email that already exists as an email/password account, the backend returns HTTP 409 with a clear message: *"An account with this email already exists. Please sign in with your email and password."* No silent account merging.

---

### Flutter (`appt_app/`)

| File | Change |
|---|---|
| `pubspec.yaml` | Added `google_sign_in: ^6.2.2` |
| `lib/core/constants/api_constants.dart` | Added `socialAuth = '/api/auth/social'` |
| `lib/core/providers/core_providers.dart` | Added `googleSignInProvider` |
| `lib/features/auth/domain/repositories/i_auth_repository.dart` | Added `signInWithGoogle()` to interface |
| `lib/features/auth/data/datasources/auth_remote_datasource.dart` | Added `socialAuth()` HTTP method |
| `lib/features/auth/data/repositories/auth_repository_impl.dart` | Implemented `signInWithGoogle()` |
| `lib/features/auth/presentation/providers/auth_provider.dart` | Added `signInWithGoogle()` to notifier; handles cancellation gracefully |
| `lib/features/auth/presentation/widgets/google_sign_in_button.dart` | New reusable "Continue with Google" button widget |
| `lib/features/auth/presentation/screens/login_screen.dart` | Added divider + Google button below Sign In button |
| `lib/features/auth/presentation/screens/register_screen.dart` | Added divider + Google button below Create Account button |

---

## What Still Needs to Be Done

Everything below is a **one-time setup** that requires Google Cloud Console credentials. The code is already written — you just need to plug in the values.

---

## Google Cloud Console Setup Instructions

### Step 1 — Create a Google Cloud Project

1. Go to https://console.cloud.google.com/
2. Click the project dropdown at the top → **New Project**
3. Give it a name (e.g. `ApptClass`) → **Create**
4. Make sure the new project is selected

### Step 2 — Configure the OAuth Consent Screen

1. In the left sidebar: **APIs & Services → OAuth consent screen**
2. Choose **External** → **Create**
3. Fill in:
   - App name: `ApptClass`
   - User support email: your email
   - Developer contact email: your email
4. Click **Save and Continue** through the rest (scopes, test users) — defaults are fine
5. On the last page click **Back to Dashboard**

### Step 3 — Create Android OAuth Credential

1. Go to **APIs & Services → Credentials → Create Credentials → OAuth 2.0 Client ID**
2. Application type: **Android**
3. Package name: `com.apptclass.appt_app`
4. SHA-1 fingerprint — get it by running this in your terminal:
   ```
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
   Copy the `SHA1:` value and paste it in
5. Click **Create**
6. Download the `google-services.json` file

### Step 4 — Create iOS OAuth Credential

1. **Create Credentials → OAuth 2.0 Client ID** again
2. Application type: **iOS**
3. Bundle ID: find this in Xcode → open `appt_app/ios/Runner.xcworkspace` → click Runner target → General tab → Bundle Identifier
4. Click **Create**
5. Download the `GoogleService-Info.plist` file

### Step 5 — Create Web OAuth Credential (needed for backend token verification)

1. **Create Credentials → OAuth 2.0 Client ID** again
2. Application type: **Web application**
3. Name: `ApptClass Backend`
4. No redirect URIs needed
5. Click **Create**
6. Copy the **Client ID** shown (looks like `123456789-abcdef.apps.googleusercontent.com`)

---

## Plugging in the Credentials

### Backend
Open `appt_api/src/ApptApi.API/appsettings.json` and fill in the Web Client ID from Step 5:
```json
"Google": {
  "ClientId": "YOUR_WEB_CLIENT_ID_HERE"
}
```

Also add it to your `.env` file if you use one for local overrides.

### Android
1. Place `google-services.json` (from Step 3) at: `appt_app/android/app/google-services.json`
2. Open `appt_app/android/settings.gradle.kts` and add to the `plugins` block:
   ```kotlin
   id("com.google.gms.google-services") version "4.4.2" apply false
   ```
3. Open `appt_app/android/app/build.gradle.kts` and add to the `plugins` block:
   ```kotlin
   id("com.google.gms.google-services")
   ```

### iOS
1. Add `GoogleService-Info.plist` (from Step 4) to the Xcode project:
   - Open `appt_app/ios/Runner.xcworkspace` in Xcode
   - Right-click the `Runner` folder → **Add Files to "Runner"**
   - Select `GoogleService-Info.plist` — make sure "Add to targets: Runner" is checked
2. Open `appt_app/ios/Runner/Info.plist` and add the URL scheme so iOS can redirect back after Google login:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleTypeRole</key>
       <string>Editor</string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>YOUR_REVERSED_CLIENT_ID</string>
       </array>
     </dict>
   </array>
   ```
   The reversed client ID is in `GoogleService-Info.plist` under the key `REVERSED_CLIENT_ID`. It looks like `com.googleusercontent.apps.XXXXXXX`.

---

## Final Steps — Apply Migration & Run

Once all credentials are in place:

```bash
# 1. Apply the database migration
cd appt_api
dotnet ef database update --project src/ApptApi.Infrastructure --startup-project src/ApptApi.API

# 2. Start the backend
dotnet run --project src/ApptApi.API

# 3. Run the Flutter app
cd ../appt_app
flutter run
```

---

## How to Verify It Works

**Test 1 — New Google user:**
- Tap "Continue with Google" → pick a Google account → should land on home screen
- Check DB: `SELECT email, password_hash, provider, provider_id FROM users WHERE provider = 'google';`
- Expected: `password_hash` is NULL, `provider` is `'google'`

**Test 2 — Returning Google user:**
- Sign out → sign in with Google again → should work instantly, same account

**Test 3 — Email collision:**
- Register with `test@gmail.com` via email/password
- Try Google Sign-In with the same Gmail account
- Expected: error banner "An account with this email already exists..."

**Test 4 — Cancellation:**
- Tap "Continue with Google" → dismiss the picker without selecting
- Expected: stays on login screen, no error shown
