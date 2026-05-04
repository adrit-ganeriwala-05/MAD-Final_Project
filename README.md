# TropicaGuide 🌴

> Plan together, travel better.

A collaborative travel planning app built with Flutter and Firebase for the Mobile App Development course at Georgia State University.

**Student:** Adrit Ganeriwala (`aganeriwala1@student.gsu.edu`)
**Solo Project · May 3, 2026**

---

## Features

- **Auth** — Email/password sign-up, sign-in, password reset, Google Sign-In, session persistence
- **Trip Dashboard** — Real-time list of all trips you're a member of, with Hero cover images and budget progress bar
- **Create Trip** — Name, destination, budget, dates — with confetti on creation 🎉
- **Invite by Code** — Share a 6-character cryptographically secure code; anyone can join instantly
- **Itinerary Builder** — Drag-and-drop activity scheduling with real-time Firestore sync and batch position updates
- **AI Activity Suggestions** — Gemini 2.5 Flash suggests 10 activities for any destination in JSON mode
- **Activity Discovery** — Filter by category, search within results, add suggestions directly to a trip
- **Shared Checklist** — Atomic-transaction packing list (Firestore `runTransaction`) with swipe-to-delete, grouped by category
- **Trip Chat** — Real-time iMessage-style messaging between all trip members
- **Cloud Function Optimiser** — TypeScript callable function scores and reorders activities by budget fit, time fit, and variety
- **Push Notifications (FCM)** — Foreground snackbar, background system notification, terminated deep-link on launch
- **Firebase Storage** — 3 upload surfaces: profile avatars, trip cover photos, activity images
- **Profile Screen** — Display name, daily budget, travel pace, appearance (System/Light/Dark)
- **Security Rules** — Server-side member check on all reads and writes, deployed and emulator-validated

---

## Architecture

```
lib/
  core/           # Shared infrastructure (theme, routing, design system, utils)
  features/
    auth/         # Firebase Auth — sign-in, sign-up, password reset, Google Sign-In
    trips/        # Trip CRUD, invite codes, real-time dashboard, Storage cover photos
    itinerary/    # Activities, drag-and-drop builder, optimiser integration, Storage images
    checklist/    # Atomic-transaction shared packing list
    chat/         # Real-time trip messaging
    discovery/    # Gemini 2.5 Flash AI suggestions
    profile/      # User profile, preferences, avatar upload, bootstrap
```

**State management** — Riverpod 2.x with `@riverpod` codegen (`AsyncNotifier`, `StreamProvider`)
**Routing** — GoRouter 14.x with typed routes and a `refreshListenable` auth guard
**Backend** — Firebase (Auth, Firestore, Storage, Cloud Functions, FCM, Crashlytics, Analytics)
**Cloud Functions** — TypeScript, Node 20, 2nd-gen deployed to `us-central1`
**AI** — Google Gemini 2.5 Flash via HTTP, JSON mode enforced, API key via `--dart-define`

---

## Tech Stack

| Layer | Choice |
|---|---|
| UI Framework | Flutter 3.41.6 |
| Language | Dart 3.11.4 with sound null safety |
| State Management | Riverpod 2.x + riverpod_generator |
| Routing | GoRouter 14.x |
| Backend | Firebase (Auth, Firestore, Storage, Functions, FCM, Crashlytics, Analytics) |
| Cloud Functions | TypeScript, Node 20, 2nd-gen |
| AI Suggestions | Google Gemini 2.5 Flash |
| Lints | very_good_analysis |

---

## How to Run

```zsh
# 1. Install dependencies
flutter pub get

# 2. Run codegen (required after any model/provider changes)
dart run build_runner build --delete-conflicting-outputs

# 3. Run in dev mode (uses Firebase emulators)
flutter run --dart-define=ENVIRONMENT=dev --dart-define=GEMINI_API_KEY=your-key

# 4. Run in production mode (uses live Firebase project)
flutter run --dart-define=ENVIRONMENT=prod --dart-define=GEMINI_API_KEY=your-key

# 5. Build release APK
flutter build apk --dart-define=ENVIRONMENT=prod --dart-define=GEMINI_API_KEY=your-key
# Output: build/app/outputs/flutter-apk/app-release.apk
```

> **Note:** The Gemini API key is passed at build time via `--dart-define`. It is never stored in source code.

---

## How to Run Emulators

```zsh
# Start Auth, Firestore, and Storage emulators
firebase emulators:start --only auth,firestore,storage --project tropicaguide-adrit-2026

# Emulator UI available at:
# http://localhost:4000
```

---

## How to Seed Demo Data

```zsh
# Emulators must be running first
node firebase/emulator/seed.js
```

---

## Demo Credentials (dev/emulator mode only)

| User | Email | Password |
|---|---|---|
| Alice | alice@demo.com | demo1234 |
| Bob | bob@demo.com | demo1234 |

**Pre-seeded invite codes:**
- Cancún trip: `CAN4X9`
- Bali trip: `BALI77`

---

## Cloud Functions

Three functions deployed to `us-central1` on the Blaze plan:

| Function | Type | Purpose |
|---|---|---|
| `optimiseItinerary` | Callable (2nd gen) | Scores and ranks activities by budget fit, time fit, variety |
| `onActivityAdded` | Firestore trigger | Sends FCM push notification to trip members |
| `onMessageSent` | Firestore trigger | Sends FCM push notification to trip members |

```zsh
# Deploy functions
firebase deploy --only functions --project tropicaguide-adrit-2026

# Run unit tests (10/10 passing)
cd functions && npx jest --verbose
```

---

## Security Rules

All Firestore and Storage access is enforced server-side via a `isTripMember()` helper that checks the requesting user's UID against the trip's `memberIds` array. Rules are deployed to production and validated in the Firebase Emulator Suite.

```zsh
# Deploy rules and indexes
firebase deploy --only firestore:rules,firestore:indexes --project tropicaguide-adrit-2026
```

---

## Testing

```zsh
# Flutter static analysis (zero issues)
flutter analyze

# Flutter unit tests
flutter test

# Cloud Function unit tests (10/10 passing)
cd functions && npx jest --verbose
```

---

## Version History

| Version | Date | Scope |
|---|---|---|
| v0.1 | Apr 14–20 | Foundation — config, auth, routing |
| v0.2 | Apr 21–24 | Core features — trips CRUD, itinerary, Firestore sync |
| v0.3 | Apr 25–29 | Enhancement — checklist, chat, FCM |
| v1.0 | May 3 | Final delivery — AI discovery, security rules, polish |

---

## AI Usage

AI (Claude) was used to debug specific bugs during development. All architecture decisions, schema design, and feature planning were made independently. See `AI_Usage_Log.md` for the full log.

---

## License

MIT — built for academic purposes at Georgia State University, 2026.
