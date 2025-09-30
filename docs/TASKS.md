# TASKS.md — Current In-Progress Tasks

This file tracks the **active implementation tasks**.  
Each section corresponds to a PLAN.md task.  
Gemini should check off `[x]` when steps are complete.

---

## T0 — Project Bootstrap

### Context
Initialize the project with required dependencies.  
You have already run `flutter create countdown_app`.  
This step ensures all packages are installed and baseline config is correct.

### Files To Modify
- pubspec.yaml
- android/app/build.gradle

### Checklist
- [ ] Add dependencies to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  intl: ^0.19.0
  google_fonts: ^6.0.0
  flutter_local_notifications: ^16.0.0
  home_widget: ^0.5.0
  flutter_animate: ^4.3.0
  purchases_flutter: ^6.24.0 # RevenueCat
```

- [ ] Add dev dependencies to `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_lints: ^4.0.0
  build_runner: ^2.4.9
```

- [ ] In `android/app/build.gradle`, confirm:
  - `minSdkVersion` is **21** or higher.

- [ ] Run commands:
  - [ ] `flutter pub get`
  - [ ] `flutter analyze`

### Acceptance Criteria
- [ ] `flutter pub get` runs without errors.
- [ ] `flutter analyze` passes with no issues.
- [ ] Project builds successfully on simulator/emulator.

---

## T1 — Core Scaffold & Theming

### Context
Set up the core app shell, global theming, navigation, and utilities.  
This provides the foundation for all features.

### Files To Create
- [ ] `lib/core/app.dart`
- [ ] `lib/core/navigation/routes.dart`
- [ ] `lib/core/theme/colors.dart`
- [ ] `lib/core/theme/typography.dart`
- [ ] `lib/core/theme/themes.dart`
- [ ] `lib/core/utils/gaps.dart`
- [ ] `lib/core/utils/formatters.dart`
- [ ] `lib/core/utils/constants.dart`
- [ ] `lib/main.dart`

### Checklist

#### Colors
- [ ] In `colors.dart`, define base palette:
  - Primary pastel (pink, mint, lavender).
  - Dark theme primary/secondary.
  - Neutral greys.
- [ ] Expose constants like `AppColors.primaryPink`.

#### Typography
- [ ] In `typography.dart`, define text styles with `google_fonts`:
  - h1 (large D-Day numbers).
  - h2 (titles).
  - body (notes).
- [ ] Export styles via `AppText`.

#### Themes
- [ ] In `themes.dart`, create:
  - `ThemeData lightTheme` (pastel).
  - `ThemeData darkTheme`.
- [ ] Use `AppColors` + `AppText` consistently.

#### Routes
- [ ] In `routes.dart`, define route constants:
  - `/` (countdown list)
  - `/countdown/detail`
  - `/countdown/add_edit`
  - `/settings`
  - `/settings/paywall`
- [ ] Export a `Map<String, WidgetBuilder>` or a `RouteGenerator`.

#### Gaps
- [ ] In `gaps.dart`, define spacing constants:
  - `gap8`, `gap16`, `gap24`.

#### Formatters
- [ ] In `formatters.dart`, stub helpers:
  - `String formatDateLocalized(DateTime utc, Locale locale)`
  - `String formatDDayLabel(DateTime targetUtc, DateTime nowLocal, Locale locale)`

#### Constants
- [ ] In `constants.dart`, define:
  - `const kFreeEventCap = 2;`
  - `const kEntitlementPro = 'pro';`
  - Product ID placeholders for IAP (to be updated later).

#### App
- [ ] In `app.dart`, create `App` widget:
  - Wrap in `ProviderScope`.
  - Use `MaterialApp` with:
    - title: localized.
    - theme: `lightTheme`.
    - darkTheme: `darkTheme`.
    - routes: from `routes.dart`.
    - initialRoute: `/`.

#### Main
- [ ] In `main.dart`:
  - Call `WidgetsFlutterBinding.ensureInitialized();`
  - Stub Hive init (real setup in T2).
  - Run `runApp(const App());`

### Commands
- [ ] `flutter pub get`
- [ ] `flutter analyze`
- [ ] `flutter run`

### Acceptance Criteria
- [ ] App compiles and runs on device/emulator.
- [ ] Blank scaffold loads with light/dark theme applied.
- [ ] No errors in `flutter analyze`.
