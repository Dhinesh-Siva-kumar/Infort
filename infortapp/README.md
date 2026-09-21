# Infort Founder

A secure Flutter mobile dashboard for the Infort Solutions Founder/Owner —
login, dashboard overview, and full management of Contact Us requests
submitted from the [Infort website](../frontend), backed by the
[Infort API](../backend).

## Stack

- Flutter 3.47.5 (stable) / Dart 3.13.4
- State management: Riverpod (`flutter_riverpod`)
- Routing: `go_router` (auth-gated redirects, deep links, bottom-nav shell)
- Networking: `dio` (centralized `ApiClient` — auth header injection,
  single-flight token refresh on 401, consistent error mapping)
- Secure storage: `flutter_secure_storage` (Android Keystore / iOS Keychain —
  tokens are never put in SharedPreferences)
- Biometric unlock: `local_auth`
- Non-sensitive prefs (theme, biometric toggle): `shared_preferences`

## Architecture

```
lib/
├── core/            # config, network (ApiClient), storage, router, theme, providers, utils
├── features/
│   ├── auth/        # login, session, lock screen
│   ├── splash/
│   ├── dashboard/   # today's overview + recent requests
│   ├── contacts/    # the primary feature — list/detail/status of contact requests
│   ├── notifications/
│   ├── profile/
│   └── settings/    # theme, biometric toggle
└── shared/          # cross-feature widgets (empty/error/loading states) and models
```

Each feature follows `data/` (API + repository) → `presentation/providers/`
(Riverpod state) → `presentation/screens|widgets/`. This mirrors the
`features/`-based structure used in the target architecture for the rest of
the monorepo (`frontend/`, `backend/`).

## Environment configuration

No URL is hard-coded outside `AppConfig`. Pass the API base URL at build/run
time:

```bash
# Android emulator (10.0.2.2 is the emulator's alias for the host machine)
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api --dart-define=ENV=development

# iOS simulator / physical device on the same network as the backend
flutter run --dart-define=API_BASE_URL=http://<your-lan-ip>:3000/api --dart-define=ENV=development

# Production
flutter build apk --release --dart-define=API_BASE_URL=https://api.infort.in/api --dart-define=ENV=production
```

If omitted, it defaults to `http://10.0.2.2:3000/api` (Android emulator
talking to a local backend) in debug.

## Setup

```bash
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
```

The backend must be running first — see `../backend/README.md` — including
having run its migrations and created a Founder account via
`npm run create-founder`.

## Android build

Requires the Android SDK (Android Studio, or the standalone command-line
tools + `sdkmanager --licenses`). `minSdk` is pinned to 23 (required by
`local_auth`'s biometric APIs).

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://api.infort.in/api --dart-define=ENV=production
flutter build appbundle --release --dart-define=API_BASE_URL=https://api.infort.in/api --dart-define=ENV=production
```

## iOS build

Requires Xcode on macOS (iOS builds cannot be produced on Windows/Linux —
this is a platform limitation, not a project configuration issue).

```bash
flutter build ios --release --dart-define=API_BASE_URL=https://api.infort.in/api --dart-define=ENV=production
```

`Info.plist` already declares `NSFaceIDUsageDescription` (for biometric
unlock) and the `infortfounder://` URL scheme (for notification deep links).

## Push notifications

Not wired up yet — there is no Firebase project configured for this app. The
backend already has the supporting pieces (`notifications` and
`device_tokens` tables, `POST /api/notifications/device-token`), and the
in-app Notifications screen reads real data via polling/pull-to-refresh.
Adding FCM later means: add `firebase_messaging`, call the existing
device-token endpoint with the FCM token, and send from the backend when a
`notifications` row is created.

## Deep linking

`infortfounder://contact-request/123` resolves to `/contact-requests/123` in
the app's `go_router` config (`lib/core/router/app_router.dart`). The
Android intent-filter and iOS `CFBundleURLTypes` are already registered for
this scheme.

## Backend API this app depends on

See `../backend/README.md` for the full contract. Summary:

```
POST   /api/auth/login
POST   /api/auth/refresh
POST   /api/auth/logout
POST   /api/auth/change-password

GET    /api/contact-requests            (paginated, search, status filter, sort)
GET    /api/contact-requests/summary    (dashboard stat counts)
GET    /api/contact-requests/:id
PATCH  /api/contact-requests/:id/status

GET    /api/notifications
PATCH  /api/notifications/:id/read
PATCH  /api/notifications/read-all
POST   /api/notifications/device-token  (scaffold for future push)

GET    /api/profile
PATCH  /api/profile
```

All of the above (except `POST /api/auth/login|refresh`) require a Bearer
access token and the `FOUNDER` role, enforced server-side.
