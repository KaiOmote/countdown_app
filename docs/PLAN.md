<!-- countdown_app/docs/PLAN.md -->
# Implementation Plan (Step-by-Step, Ordered)

This plan is the **single source of truth** for building the Countdown / Reminder Widget App.  
Follow tasks **in order**. Each task block includes: Context + Files + Steps + Commands + Acceptance.

> Conventions:  
> - Use the locked structure in `FILE_STRUCTURE.md`.  
> - Store `DateTime` in **UTC**; format for display via `intl`.  
> - All user-facing text via `lib/l10n/*.arb` keys.  
> - Riverpod providers manage state.  
> - Business logic stays in repositories/services (not in widgets).  
> - Free users max **2 events**; Pro unlock removes the cap and ads.  
> - iOS + Android widgets via `home_widget`.  
> - Notifications via `flutter_local_notifications`.  
> - RevenueCat for one-time Pro unlock (entitlement: `pro`).

---

## 0. Project Bootstrap

### T0.1 - Create Project & Add Packages
**Files**: `pubspec.yaml`

**Steps**
1. Run `flutter create countdown_app`.
2. Add the following dependencies in `pubspec.yaml`:
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
   dev_dependencies:
     flutter_lints: ^4.0.0
     build_runner: ^2.4.9
   ```
3. Ensure `android/app/build.gradle` sets `minSdkVersion` to 21 or higher.

**Commands**
- `flutter pub get`

**Acceptance**
- `flutter analyze` passes.
- Project builds on a simulator (no runtime code yet).

---

## 1. Core Scaffold & Theming

### T1.1 - Core Folders & App Shell
**Files**
- `lib/core/app.dart`
- `lib/core/navigation/routes.dart`
- `lib/core/theme/colors.dart`
- `lib/core/theme/typography.dart`
- `lib/core/theme/themes.dart`
- `lib/core/utils/gaps.dart`
- `lib/core/utils/formatters.dart`
- `lib/core/utils/constants.dart`
- `lib/main.dart`

**Steps**
1. Create all files above as empty stubs with TODO headers.
2. In `colors.dart`, define the base palette (pastel + dark placeholders).
3. In `typography.dart`, define text styles using `google_fonts`.
4. In `themes.dart`, expose light and dark `ThemeData` builders.
5. In `routes.dart`, declare route names:
   - `/` (countdown_list)
   - `/countdown/detail`
   - `/countdown/add_edit`
   - `/settings`
   - `/settings/paywall`
6. In `app.dart`, build the `App` widget with `ProviderScope`, `MaterialApp`, themes, and the route map.
7. In `main.dart`, call `WidgetsFlutterBinding.ensureInitialized();` and `runApp(const App());`.

**Commands**
- `flutter run`

**Acceptance**
- App launches to a blank scaffold with no crashes.

---

## 2. Data Model & Hive Persistence

### T2.1 - CountdownEvent Model + Hive Setup
**Files**
- `lib/features/countdown/data/countdown_event.dart`
- `lib/features/countdown/data/countdown_repository.dart`
- `lib/features/countdown/providers.dart`
- `lib/main.dart`

**Steps**
1. Define `CountdownEvent` with fields:
   - `String id`
   - `String title`
   - `DateTime dateUtc` (must be stored in UTC)
   - `String? emoji`
   - `String? notes`
2. Annotate the model for Hive with a unique `typeId` (e.g., `1`) and implement the `TypeAdapter` manually (no code generation).
3. In `main.dart` (before `runApp`), add:
   ```dart
   await Hive.initFlutter();
   Hive.registerAdapter(CountdownEventAdapter());
   await Hive.openBox<CountdownEvent>('eventsBox');
   ```
4. Implement `CountdownRepository` to wrap a single `Box<CountdownEvent>` and provide:
   - `List<CountdownEvent> listAll()` sorted by `dateUtc` ascending.
   - `Future<void> add(CountdownEvent event)`.
   - `Future<void> update(CountdownEvent event)`.
   - `Future<void> remove(String id)`.
   - `CountdownEvent? nearestUpcoming(DateTime nowUtc)`.
5. In `providers.dart`, wire Riverpod providers:
   - `eventsBoxProvider` returning the opened Hive box.
   - `countdownRepositoryProvider`.
   - `eventsListProvider` (stream or notifier) publishing sorted events.
   - `nearestUpcomingProvider` reading the repository to expose the next event.

**Commands**
- `flutter run`

**Acceptance**
- App compiles.
- Hive box opens and closes without runtime exceptions.

---

## 3. Shared Widgets (UI Building Blocks)

### T3.1 - Reusable Components
**Files**
- `lib/widgets/countdown_card.dart`
- `lib/widgets/app_button.dart`
- `lib/widgets/app_text_field.dart`

**Steps**
1. Create `CountdownCard` with props `title`, `emoji`, `daysText`, `dateLabel`, `onTap`, `onLongPress`.
2. Implement `AppButton` with filled and tonal variants.
3. Implement `AppTextField` with standard styling, hint text, and optional controller.

**Acceptance**
- Components render in a temporary placeholder screen without errors.

---

## 4. Main List Screen

### T4.1 - Countdown List UI + Navigation
**Files**
- `lib/features/countdown/presentation/countdown_list_screen.dart`
- `lib/core/navigation/routes.dart`

**Steps**
1. Build `CountdownListScreen` with:
   - `AppBar` containing the title and a settings icon button navigating to `/settings`.
   - Body listening to `eventsListProvider` and mapping items to `CountdownCard` widgets.
   - Empty state with friendly message and CTA to add an event.
   - `FloatingActionButton` navigating to `/countdown/add_edit`.
2. Register the route in `routes.dart`.

**Acceptance**
- Launch shows the list (empty or populated).
- FAB and settings icon navigate to the correct routes.

---

## 5. Add/Edit Screen

### T5.1 - Add/Edit Form & Validation
**Files**
- `lib/features/countdown/presentation/add_edit_countdown_screen.dart`
- `lib/features/countdown/data/countdown_repository.dart`
- `lib/core/utils/formatters.dart`
- `lib/core/utils/constants.dart`
- `lib/core/navigation/routes.dart`

**Steps**
1. Build a form with fields:
   - Title (required).
   - Date picker (required, store as UTC).
   - Emoji picker (simple text field for MVP).
   - Notes (optional).
2. Add `kFreeEventCap = 2` to `constants.dart` for free tier enforcement.
3. When saving a new event:
   - If the user is at the free cap and not Pro, navigate to `/settings/paywall` and abort save.
   - Otherwise, create `CountdownEvent(id: uuid, dateUtc: pickedDate.toUtc(), ...)` and call `countdownRepository.add`.
4. On edit, prefill the form, call `countdownRepository.update`, and pop to the list.
5. Ensure `formatters.dart` provides helpers for date display.

**Acceptance**
- Events can be added and edited; they persist and display on the list.
- Date displays correctly per locale using the formatter helper.

---

## 6. Detail Screen & Share

### T6.1 - Detail View (D-Day, Notes, Share)
**Files**
- `lib/features/countdown/presentation/countdown_detail_screen.dart`
- `lib/core/utils/formatters.dart`

**Steps**
1. Compute D-Day with `days = dateUtc.difference(nowUtc).inDays`, normalizing both values to local midnight for display to avoid off-by-one.
2. For future events show `D-{n}` and localized copy like `{n} days`, and for past events show `D+{n}` / `{n} days ago`.
3. Layout sections:
   - Large D-Day number.
   - Title and emoji.
   - Localized date.
   - Notes (if present).
4. Add buttons for Edit, Share, and Notifications.
5. Implement share action using a formatted text payload (image export is a later iteration).

**Acceptance**
- Tapping a list item opens the detail view.
- D-Day calculations are correct across time zones (spot-check near midnight).
- Share sheet opens with meaningful text content.

---

## 7. Notifications

### T7.1 - Notification Service & Toggles
**Files**
- `lib/features/notifications/notification_service.dart`
- `lib/features/countdown/presentation/countdown_detail_screen.dart`

**Steps**
1. Initialize `flutter_local_notifications`:
   - On iOS, request permissions lazily when the user first enables reminders.
   - On Android, define a high-importance reminder channel.
2. Provide service API:
   - `Future<void> scheduleEventReminders(CountdownEvent event)` to schedule notifications at 09:00 local time on `event.date - 7d`, `event.date - 1d`, and `event.date`.
   - `Future<void> cancelEventReminders(String eventId)`.
3. Add reminder toggles in the detail screen (MVP can be a single "Enable reminders" switch that schedules all three reminders).
4. Reschedule reminders on edit and cancel when deleting.

**Acceptance**
- Enabling reminders requests permission (iOS) and schedules notifications.
- Editing or deleting events updates or cancels notifications accordingly.

---

## 8. Home Screen Widgets

### T8.1 - Widget Service & Data Bridge
**Files**
- `lib/features/widgets/widget_service.dart`
- `lib/features/countdown/providers.dart`

**Steps**
1. Implement service methods:
   - `Future<void> pushNextEventToWidget(CountdownEvent? event)` saving `title`, `emoji`, `dateIso`, `daysRemaining` via `HomeWidget.saveWidgetData`.
   - `Future<void> refreshWidgets()` calling `HomeWidget.updateWidget` for Android and triggering an iOS timeline reload.
2. Listen to `nearestUpcomingProvider` and push updates whenever the events list changes.
3. Stub platform configuration calls until native tasks below are ready.

**Acceptance**
- Service compiles and can be invoked without runtime errors (no-op until native widgets are configured).

### T8.2 - Android Widget Provider
**Files**
- `android/app/src/main/AndroidManifest.xml`
- Widget layout(s) under `android/app/src/main/res/layout/`
- Widget provider class per `home_widget` documentation

**Steps**
1. Declare the widget provider in the manifest.
2. Create widget layout XML (small and medium sizes).
3. Wire update paths following `home_widget` setup guidance.

**Acceptance**
- On Android device/emulator, the widget can be added and shows placeholder content, updating after data push.

### T8.3 - iOS Widget Extension
**Files**
- Xcode widget extension target and related Swift files

**Steps**
1. Add a WidgetKit extension target in Xcode.
2. Enable App Groups for the app and widget; use a shared group id (e.g., `group.com.your.bundle.countdown`).
3. Implement a timeline provider that reads saved values via `HomeWidget`.

**Acceptance**
- On a physical iPhone, the widget can be placed and displays the nearest event.

---

## 9. Settings, Theme, Language

### T9.1 - Theme Provider & Settings Screen
**Files**
- `lib/features/settings/theme_provider.dart`
- `lib/features/settings/presentation/settings_screen.dart`
- `lib/core/navigation/routes.dart`

**Steps**
1. Implement `theme_provider.dart` as a Riverpod provider managing theme selection (system, light, dark, pastel variants) and persist the choice via Hive or shared preferences.
2. Build `settings_screen.dart` with:
   - Theme selector (radio list).
   - Language toggle (JP/EN) updating the app `Locale`.
   - "Upgrade to Pro" button navigating to the paywall.
   - About/version section.
3. Register the settings route.

**Acceptance**
- Settings screen opens; theme and language changes update the UI and persist across restarts.

---

## 10. Paywall & Pro Entitlement

### T10.1 - RevenueCat Integration
**Files**
- `lib/features/settings/paywall_screen.dart`
- `lib/features/settings/iap_service.dart`
- `lib/features/countdown/presentation/add_edit_countdown_screen.dart`
- `lib/core/utils/constants.dart`

**Steps**
1. In `constants.dart`, define:
   - `const kEntitlementPro = 'pro';`
   - Product identifiers (e.g., `pro_lifetime_jp_1200`).
2. Implement `iap_service.dart`:
   - Initialize the Purchases SDK.
   - Provide `StreamProvider<bool> isProProvider`.
   - Implement `Future<bool> purchasePro()` and `Future<void> restorePurchases()`.
3. Build `paywall_screen.dart` with benefits list (unlimited events, no ads, premium themes) and pricing fetched from offerings (fallback to localized defaults).
4. Hook Add/Edit flow to enforce the free cap: if not Pro and `currentCount >= kFreeEventCap`, navigate to `/settings/paywall`.

**Acceptance**
- Sandbox purchase flow works and updates `isProProvider` to `true` after purchase or restore.
- Free cap is enforced before purchase and lifted afterward.

---

## 11. Localization (EN/JP)

### T11.1 - i18n Setup
**Files**
- `lib/l10n/intl_en.arb`
- `lib/l10n/intl_ja.arb`
- Any screen files currently holding hardcoded strings

**Steps**
1. Add ARB keys for all user-facing text (`appTitle`, `addCountdown`, `editCountdown`, `daysRemaining`, `eventPassed`, `upgradePro`, `proBenefits`, `remind7d`, `remind1d`, `remindToday`, `settings`, `theme`, `language`, `unlimited`, `noAds`, `exclusiveThemes`, etc.).
2. Configure `flutter` localization in `pubspec.yaml` (`generate: true` and `l10n` section if needed).
3. Replace hardcoded strings with `S.of(context).key`.

**Commands**
- `flutter pub get`

**Acceptance**
- Changing device locale or in-app language toggle updates strings.
- No missing translation warnings.

---

## 12. Polish: Formatting, Edge Cases, Ads Toggle

### T12.1 - Formatters & D-Day Edge Cases
**Files**
- `lib/core/utils/formatters.dart`

**Steps**
1. Add helpers:
   - `String formatDateLocalized(DateTime utc, Locale locale)`
   - `String formatDDayLabel(DateTime targetUtc, DateTime nowLocal, Locale locale)`
2. Normalize to local midnight when computing days to avoid off-by-one around clock changes.

**Acceptance**
- D-Day labels match expectations for today/tomorrow/yesterday across locales.

### T12.2 - (Optional MVP) Ads Gate
**Files**
- `lib/core/services/ads_service.dart`
- `lib/features/countdown/presentation/countdown_list_screen.dart`

**Steps**
1. Stub an ads service (no-op if AdMob is not integrated yet).
2. Render a fixed-height placeholder banner for free users; hide it for Pro users.

**Acceptance**
- Free users see a non-intrusive banner area; Pro users do not.

---

## 13. QA & Release

### T13.1 - QA Pass
**Checklist**
- Add, edit, delete events persist correctly.
- D-Day remains accurate near midnight.
- Notifications schedule and cancel as expected.
- Widgets refresh after event changes.
- Free cap enforced; paywall unlock works.
- English and Japanese strings present.
- Dark, light, and pastel themes render as expected.
- Performance: list scrolls at 60fps on a mid-range Android device; app start < 1.5s on iPhone XR.

### T13.2 - Store Prep
**Steps**
1. Prepare app icon (1024px) and adaptive Android icons.
2. Capture JP & EN screenshots (light and dark themes).
3. Write localized store descriptions.
4. Document privacy (local-only storage) and notification permission rationale.
5. Ensure RevenueCat products exist on both stores.
6. Verify iOS widget extension and App Group configuration.
7. Verify Android widget provider declaration.
8. Bump build numbers; run release builds on physical devices.

---

## Appendix A - Provider & Method Signatures (Reference)

**CountdownRepository**
- `List<CountdownEvent> listAll()`
- `Future<void> add(CountdownEvent event)`
- `Future<void> update(CountdownEvent event)`
- `Future<void> remove(String id)`
- `CountdownEvent? nearestUpcoming(DateTime nowUtc)`

**providers.dart**
- `Provider<Box<CountdownEvent>> eventsBoxProvider`
- `Provider<CountdownRepository> countdownRepositoryProvider`
- `StreamProvider<List<CountdownEvent>> eventsListProvider` (or `StateNotifierProvider`)
- `Provider<CountdownEvent?> nearestUpcomingProvider`

**notification_service.dart**
- `Future<void> initIfNeeded()`
- `Future<void> scheduleEventReminders(CountdownEvent event)`
- `Future<void> cancelEventReminders(String eventId)`

**widget_service.dart**
- `Future<void> pushNextEventToWidget(CountdownEvent? event)`
- `Future<void> refreshWidgets()`

**iap_service.dart**
- `final isProProvider = StreamProvider<bool>((ref) => ...)`
- `Future<bool> purchasePro()`
- `Future<void> restorePurchases()`

**formatters.dart**
- `String formatDateLocalized(DateTime utc, Locale locale)`
- `String formatDDayLabel(DateTime targetUtc, DateTime nowLocal, Locale locale)`

---

## Appendix B - Free Cap Enforcement

- Define `const kFreeEventCap = 2`.
- When saving in Add/Edit:
  - If `!isPro && currentCount >= kFreeEventCap`, navigate to `/settings/paywall` and abort the save.

---

## Appendix C - Time Handling Rules

- Persist `dateUtc` only in UTC.
- For display and D-Day math, convert to local time.
- Compare using local midnight to avoid off-by-one errors.
- Schedule notifications at 09:00 local time on `-7d`, `-1d`, and `0d`.

---

## Appendix D - Widget Data Contract

- Keys saved via `HomeWidget`:
  - `nextEventTitle` (String)
  - `nextEventEmoji` (String)
  - `nextEventDateIso` (UTC ISO-8601 String)
  - `nextEventDaysRemaining` (int)
- Update on app start, add/edit/delete operations, and app resume.

---

## Appendix E - Paywall Copy (JP/EN)

**JP**
- 無制限のカウントダウン
- 広告なし
- 限定テーマ

**EN**
- Unlimited countdowns
- No ads
- Exclusive themes

---

## Definition of Done (MVP)

- All tasks T0-T13 completed.
- App runs without crashes on a physical iPhone and Android phone.
- Widgets and notifications function for at least one test event.
- Pro purchase works in sandbox.
- Localization complete for JP/EN.
- Store assets ready.
