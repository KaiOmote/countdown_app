# Countdown / Reminder Widget App (Flutter)

A JP-first, aesthetic countdown app with iOS/Android widgets. Goal: ship fast (2–4 weeks), learn full store flow, and keep costs ~0 (local storage first).

## Goals
- Easy to ship MVP.
- No backend (Hive).
- Monetizable: free (2 events + ads) → Pro unlock (one-time).
- Good UI (pastel/dark themes, JP/EN).

## Tech Stack
- Flutter (stable)
- State: Riverpod
- Storage: Hive + hive_flutter; prefs: shared_preferences (later if needed)
- Widgets: home_widget
- Dates/i18n: intl
- Local notifications: flutter_local_notifications
- UI: google_fonts, flutter_animate (optionally Rive)
- Monetization: RevenueCat (`purchases_flutter`) **or** `in_app_purchase`

## Packages (baseline)
```yaml
flutter_riverpod: ^2.4.0
hive: ^2.2.3
hive_flutter: ^1.1.0
intl: ^0.19.0
google_fonts: ^6.0.0
home_widget: ^0.5.0
flutter_local_notifications: ^16.0.0
flutter_animate: ^4.3.0
purchases_flutter: ^6.24.0 # or in_app_purchase ^3.1.0
