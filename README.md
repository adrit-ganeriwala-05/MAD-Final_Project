# TropicaGuide 🌴

> Plan together, travel better.

A collaborative travel planning app built with Flutter and Firebase for the Mobile App Development course at Georgia State University.

---

## Features

- **Auth** — Email/password sign-up, sign-in, password reset, session persistence
- **Trip Dashboard** — Real-time list of all trips you're a member of
- **Create Trip** — Name, destination, budget, dates — with confetti on creation 🎉
- **Invite by Code** — Share a 6-character code; anyone can join your trip instantly
- **Itinerary Builder** — Drag-and-drop activity scheduling with real-time Firestore sync
- **Explainable Score Chips** — Distance / Budget / Time-fit scores written by Cloud Function
- **AI Activity Suggestions** — Claude AI suggests activities for any destination
- **Activity Discovery** — Browse 8 curated seed activities, filter by category
- **Shared Checklist** — Atomic-transaction packing list with swipe-to-delete
- **Trip Chat** — Real-time iMessage-style messaging between all trip members
- **Cloud Function Optimiser** — TypeScript callable function scores and reorders activities
- **Profile Screen** — Edit display name, daily budget, and travel pace preference
- **Budget Progress Bar** — Visual spend tracker on each trip card
- **Dark Mode** — Full light/dark theme, system-following

---

## Architecture

```
lib/
  core/           # Shared infrastructure (theme, routing, design system, utils)
  features/
    auth/         # Firebase Auth — sign-in, sign-up, password reset
    trips/        # Trip CRUD, invite codes, real-time dashboard
    itinerary/    # Activities, drag-and-drop builder, optimiser integration
    checklist/    # Atomic-transaction shared packing list
    chat/         # Real-time trip messaging
    discovery/    # AI suggestions + curated seed activities
    profile/      # User profile, preferences, bootstrap
```

**State management** — Riverpod 2.x with `@riverpod` codegen (`AsyncNotifier`, `StreamProvider`)  
**Routing** — GoRouter 14.x with typed routes and a `refreshListenable` auth guard  
**Backend** — Firebase (Auth, Firestore, Storage, Cloud Functions, Crashlytics, Analytics)  
**Cloud Functions** — TypeScript, Node 20, 2nd-gen callable functions deployed to `us-central1`

---

## Tech Stack

| Layer | Choice |
|---|---|
| UI Framework | Flutter 3.41.6 |
| Language | Dart 3.11.4 with sound null safety |
| State Management | Riverpod 2.x + riverpod_generator |
| Routing | GoRouter 14.x |
| Backend | Firebase (Auth, Firestore, Storage, Functions) |
| Cloud Functions | TypeScript, Node 20 |
| AI Suggestions | Anthropic Claude API |
| Lints | very_good_analysis + flutter_lints |

---

## How to Run

```bash
# 1. Install dependencies
flutter pub get

# 2. Run codegen (required after any model/provider changes)
dart run build_runner build --delete-conflicting-outputs

# 3. Run on Android emulator (dev mode — uses Firebase emulators)
flutter run --dart-define=ENVIRONMENT=dev

# 4. Run in production mode (uses live Firebase project)
flutter run --dart-define=ENVIRONMENT=prod
```

---

## How to Run Emulators

```bash
# Start Auth, Firestore, and Storage emulators
firebase emulators:start --only auth,firestore,storage --project tropicaguide-adrit-2026

# Emulator UI available at:
# http://localhost:4000
```

---

## How to Seed Demo Data

```bash
# Emulators must be running first
node firebase/emulator/seed.js
```

---

## Demo Credentials

| User | Email | Password |
|---|---|---|
| Alice | alice@demo.com | demo1234 |
| Bob | bob@demo.com | demo1234 |

**Invite codes (pre-seeded):**
- Cancún trip: `CAN4X9`
- Bali trip: `BALI77`

---

## Testing

```bash
# Flutter unit + widget tests
flutter test

# Firestore security rules tests (emulators must be running)
cd firebase && npx jest --forceExit

# Cloud Function unit tests
cd functions && npm install && npm test
```

---

## AI Activity Suggestions

The discovery screen uses the Anthropic Claude API to suggest activities for any destination. To enable it:

1. Open `lib/features/discovery/data/ai_suggestions_repository.dart`
2. Replace `YOUR_ANTHROPIC_API_KEY_HERE` with your real API key
3. In production, move the key to a Cloud Function (the TODO comment marks the exact location)

---

## Known Limitations & Next Steps

- **Google Sign-In** — Wired in the stack but not implemented; email/password only for now
- **Push Notifications (FCM)** — Declared in pubspec; topic subscriptions not wired to UI
- **Map View** — Activities show as a list; a Google Maps pin view would be the next visual upgrade
- **API Key Security** — The Anthropic API key is currently a client-side constant; production builds should proxy through a Cloud Function
- **Image Upload** — Firebase Storage is configured but activity/trip images use placeholder icons; a real image picker would complete the UI
- **Pagination** — Trip and activity lists load all documents; cursor-based pagination needed for scale

---

## License

MIT — built for academic purposes at Georgia State University, 2026.