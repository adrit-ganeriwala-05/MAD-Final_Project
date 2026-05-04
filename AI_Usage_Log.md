# AI Usage Log — TropicaGuide

All AI assistance received during development of this project.

| Date | Tool | Issue | What I Learned |
|---|---|---|---|
| Apr 14 | Claude | Firebase emulator hot restart — `Firebase.initializeApp()` threw AlreadyInitialized on hot restart | `Firebase.apps.isEmpty` guard prevents double-init on hot restart. File: `lib/main.dart` |
| Apr 21 | Claude | Riverpod stream overwriting local UI state — profile screen travel pace SegmentedButton was being reset by Firestore stream on every emission | `_initialised` boolean flag blocks `_populate()` after first call, preventing stream from overwriting local state. File: `lib/features/profile/presentation/profile_screen.dart` |
| Apr 25 | Claude | Firestore Security Rules — needed cross-document read syntax for `isTripMember()` function | Learned the `get(/databases/$(db)/documents/trips/$(tripId))` syntax for reading another document inside a rules function. File: `firebase/firestore.rules` |
| May 1 | Claude | Gemini returning truncated JSON — valid JSON cut off mid-string causing parse crash | Setting `responseMimeType: 'application/json'` and increasing `maxOutputTokens` to 4096 eliminates truncation. File: `lib/features/discovery/data/ai_suggestions_repository.dart` |

## Summary

AI was used exclusively to debug specific technical errors. All architecture decisions, Firestore schema design, feature planning, and implementation were done independently.
