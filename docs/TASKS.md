# TASKS.md — Active Tasks (T0–T2)

This file is a **single scratchpad** for the *current* in‑progress tasks that Gemini must follow **exactly**.  
Keep this file short and focused: when a task is finished, either:
- Move it to `TASKS_ARCHIVE.md`, **or**
- Collapse it to a single checked summary line here (to keep token usage low).

For now, this file contains **T0, T1, T2** only.

> Global rules for Gemini:
> - Do not add files not listed. Do not rename/move files. Follow paths exactly.
> - Store `DateTime` in **UTC** only. Convert to local for display.
> - All new user-visible strings will be localized later (T11). For now, keep placeholder text minimal.
> - If any step fails for >15 minutes, STOP and paste: exact error **message**, **file/line**, and what you tried.

---

## T0 — Project Bootstrap

### Context
Prepare the Flutter project for development.  
You already ran `flutter create countdown_app`. This task installs dependencies and validates Android baseline settings.

### Files To Modify
- `pubspec.yaml`
- `android/app/build.gradle`

### Checklist

#### T0.A — Dependencies
- [ ] Open `pubspec.yaml`.
- [ ] Under `dependencies:`, add **exactly**:
```
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
  purchases_flutter: ^6.24.0
```
- [ ] Under `dev_dependencies:`, ensure (add if missing):
```
dev_dependencies:
  flutter_lints: ^4.0.0
  build_runner: ^2.4.9
```
- [ ] Save the file.

#### T0.B — Android minSdk
- [ ] Open `android/app/build.gradle`.
- [ ] Confirm **`minSdkVersion` is 21 or higher** inside `defaultConfig { ... }`. Example:
```
defaultConfig {
    applicationId "com.example.countdown_app"
    minSdkVersion 21
    targetSdkVersion 34
}
```

#### T0.C — Install & Verify
- [ ] Run:
```
flutter pub get
```
- [ ] Run static analysis:
```
flutter analyze
```
- [ ] Build & launch on an emulator/device:
```
flutter run
```
- [ ] Verify: app launches (default Flutter counter app or blank screen, depending on your current code).

### Acceptance Criteria
- [ ] `flutter pub get` completes with no errors.
- [ ] `flutter analyze` has **0** errors.
- [ ] The project launches on Android emulator (or physical device) without runtime errors.

### Troubleshooting (Common)
- If `pub get` fails on a package: re‑run `flutter pub get`. If still failing, run `flutter clean && flutter pub get`. Paste full error into the chat.
- If Gradle error about `minSdkVersion`: update to **21** and re‑sync.
- If `purchases_flutter` gradle issues on first sync: run `flutter clean && flutter pub get`. Ensure internet access for Gradle to fetch dependencies.

---

## T1 — Core Scaffold & Theming

### Context
Create the global app shell: theming, routes, utilities, and entrypoint.  
This should compile and show a minimal scaffold (no feature UI yet).

### Files To Create
- `lib/core/app.dart`
- `lib/core/navigation/routes.dart`
- `lib/core/theme/colors.dart`
- `lib/core/theme/typography.dart`
- `lib/core/theme/themes.dart`
- `lib/core/utils/gaps.dart`
- `lib/core/utils/formatters.dart`
- `lib/core/utils/constants.dart`
- `lib/main.dart` (modify if exists)

### Checklist (with code stubs)

#### T1.A — Colors
- [ ] Create `lib/core/theme/colors.dart` with:
```dart
import 'package:flutter/material.dart';

class AppColors {
  // Pastel primaries
  static const Color pink = Color(0xFFFFB3C7);
  static const Color mint = Color(0xFFB8F2E6);
  static const Color lavender = Color(0xFFCFB7FF);

  // Accents
  static const Color accent = Color(0xFF7C4DFF);

  // Neutrals
  static const Color black = Color(0xFF121212);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey300 = Color(0xFFE0E0E0);
}
```

#### T1.B — Typography
- [ ] Create `lib/core/theme/typography.dart` with:
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 52, fontWeight: FontWeight.w800, height: 1.1),
    headlineMedium: GoogleFonts.inter(
      fontSize: 24, fontWeight: FontWeight.w700),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400, height: 1.4),
    labelLarge: GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w600),
  );
}
```

#### T1.C — Themes
- [ ] Create `lib/core/theme/themes.dart` with:
```dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.pink, brightness: Brightness.light),
  useMaterial3: true,
  textTheme: AppText.textTheme,
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lavender, brightness: Brightness.dark),
  useMaterial3: true,
  textTheme: AppText.textTheme.apply(
    bodyColor: Colors.white, displayColor: Colors.white),
);
```

#### T1.D — Routes
- [ ] Create `lib/core/navigation/routes.dart` with:
```dart
import 'package:flutter/material.dart';

class Routes {
  static const root = '/';
  static const countdownDetail = '/countdown/detail';
  static const countdownAddEdit = '/countdown/add_edit';
  static const settings = '/settings';
  static const paywall = '/settings/paywall';

  static Map<String, WidgetBuilder> builders() => {
    root: (_) => const _PlaceholderScreen(title: 'Countdown List'),
    countdownDetail: (_) => const _PlaceholderScreen(title: 'Countdown Detail'),
    countdownAddEdit: (_) => const _PlaceholderScreen(title: 'Add/Edit Countdown'),
    settings: (_) => const _PlaceholderScreen(title: 'Settings'),
    paywall: (_) => const _PlaceholderScreen(title: 'Paywall'),
  };
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
```

#### T1.E — Gaps
- [ ] Create `lib/core/utils/gaps.dart` with:
```dart
import 'package:flutter/widgets.dart';

const gap8 = SizedBox(height: 8, width: 8);
const gap12 = SizedBox(height: 12, width: 12);
const gap16 = SizedBox(height: 16, width: 16);
const gap24 = SizedBox(height: 24, width: 24);
```

#### T1.F — Formatters (stubs)
- [ ] Create `lib/core/utils/formatters.dart` with:
```dart
import 'package:intl/intl.dart';

String formatDateLocalized(DateTime utc, String locale) {
  // NOTE: will refine in T12, for now basic yMMMd
  final local = utc.toLocal();
  return DateFormat.yMMMd(locale).format(local);
}

String formatDDayLabel(DateTime targetUtc, DateTime nowLocal, String locale) {
  final targetLocal = targetUtc.toLocal();
  final now = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
  final target = DateTime(targetLocal.year, targetLocal.month, targetLocal.day);
  final diff = target.difference(now).inDays;
  if (diff > 0) return '$diff days';
  if (diff == 0) return 'Today';
  return '${diff.abs()} days ago';
}
```

#### T1.G — Constants
- [ ] Create `lib/core/utils/constants.dart` with:
```dart
const kFreeEventCap = 2;
const kEntitlementPro = 'pro';

// Product IDs (fill real IDs later)
const kProductProLifetimeIOS = 'pro_lifetime_jp_1200';
const kProductProLifetimeAndroid = 'pro_lifetime_jp_1200';
```

#### T1.H — App
- [ ] Create `lib/core/app.dart` with:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/themes.dart';
import 'navigation/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Countdown',
        theme: lightTheme,
        darkTheme: darkTheme,
        routes: Routes.builders(),
        initialRoute: Routes.root,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
```

#### T1.I — Main
- [ ] Replace `lib/main.dart` with:
```dart
import 'package:flutter/material.dart';
import 'core/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}
```

#### T1.J — Build & Smoke Test
- [ ] Run:
```
flutter pub get
flutter analyze
flutter run
```
- [ ] Verify: App launches with a top AppBar reading “Countdown List”. Placeholders render without crashes.

### Acceptance Criteria
- [ ] App builds with **0** analyzer errors.
- [ ] Placeholder navigation works if pushed via `Navigator.pushNamed(context, '/settings')` from a debug button/snippet.
- [ ] Light/Dark themes compile without runtime errors.

### Troubleshooting (Common)
- “fontFamily not found” → Ensure `google_fonts` is in deps and `flutter pub get` re‑run.
- “Route not found” → Confirm you used `Routes.*` constants and `Routes.builders()` in `MaterialApp`.

---

## T2 — Data Model & Hive Persistence

### Context
Implement `CountdownEvent` model, Hive storage, repository, and providers.  
End state: you can create, list, update, delete events programmatically; `nearestUpcoming` works.

### Files To Create/Modify
- `lib/features/countdown/data/countdown_event.dart` (new)
- `lib/features/countdown/data/countdown_repository.dart` (new)
- `lib/features/countdown/providers.dart` (new)
- `lib/main.dart` (modify: Hive init and box open)

### Checklist (with code stubs)

#### T2.A — Model (Hive TypeAdapter)
- [ ] Create `lib/features/countdown/data/countdown_event.dart`:
```dart
import 'package:hive/hive.dart';

part 'countdown_event.g.dart'; // not generating code; adapter will be manual below (no build_runner required)

@HiveType(typeId: 1)
class CountdownEvent {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime dateUtc; // must be UTC
  @HiveField(3)
  final String? emoji;
  @HiveField(4)
  final String? notes;

  const CountdownEvent({
    required this.id,
    required this.title,
    required this.dateUtc,
    this.emoji,
    this.notes,
  });

  CountdownEvent copyWith({
    String? id,
    String? title,
    DateTime? dateUtc,
    String? emoji,
    String? notes,
  }) => CountdownEvent(
        id: id ?? this.id,
        title: title ?? this.title,
        dateUtc: dateUtc ?? this.dateUtc,
        emoji: emoji ?? this.emoji,
        notes: notes ?? this.notes,
      );
}

// Manual TypeAdapter to avoid build_runner
class CountdownEventAdapter extends TypeAdapter<CountdownEvent> {
  @override
  final int typeId = 1;

  @override
  CountdownEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountdownEvent(
      id: fields[0] as String,
      title: fields[1] as String,
      dateUtc: fields[2] as DateTime,
      emoji: fields[3] as String?,
      notes: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CountdownEvent obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dateUtc)
      ..writeByte(3)
      ..write(obj.emoji)
      ..writeByte(4)
      ..write(obj.notes);
  }
}
```

#### T2.B — Repository
- [ ] Create `lib/features/countdown/data/countdown_repository.dart`:
```dart
import 'package:hive/hive.dart';
import 'countdown_event.dart';

class CountdownRepository {
  static const String boxName = 'eventsBox';
  final Box<CountdownEvent> _box;

  CountdownRepository(this._box);

  List<CountdownEvent> listAll() {
    final items = _box.values.toList();
    items.sort((a, b) => a.dateUtc.compareTo(b.dateUtc));
    return items;
  }

  Future<void> add(CountdownEvent e) async {
    await _box.put(e.id, e);
  }

  Future<void> update(CountdownEvent e) async {
    await _box.put(e.id, e);
  }

  Future<void> remove(String id) async {
    await _box.delete(id);
  }

  CountdownEvent? nearestUpcoming(DateTime nowUtc) {
    CountdownEvent? best;
    for (final e in _box.values) {
      if (e.dateUtc.isAfter(nowUtc)) {
        if (best == null || e.dateUtc.isBefore(best!.dateUtc)) {
          best = e;
        }
      }
    }
    return best;
  }
}
```

#### T2.C — Providers
- [ ] Create `lib/features/countdown/providers.dart`:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/countdown_event.dart';
import 'data/countdown_repository.dart';

final eventsBoxProvider = Provider<Box<CountdownEvent>>((ref) {
  final box = Hive.box<CountdownEvent>(CountdownRepository.boxName);
  return box;
});

final countdownRepositoryProvider = Provider<CountdownRepository>((ref) {
  final box = ref.watch(eventsBoxProvider);
  return CountdownRepository(box);
});

// Simple snapshot providers (will wire to UI later)
final eventsListProvider = Provider<List<CountdownEvent>>((ref) {
  final repo = ref.watch(countdownRepositoryProvider);
  return repo.listAll();
});

final nearestUpcomingProvider = Provider<CountdownEvent?>((ref) {
  final repo = ref.watch(countdownRepositoryProvider);
  return repo.nearestUpcoming(DateTime.now().toUtc());
});
```

#### T2.D — Hive Init in main()
- [ ] Modify `lib/main.dart` to initialize Hive and open the box before `runApp`:
```dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/app.dart';
import 'features/countdown/data/countdown_event.dart';
import 'features/countdown/data/countdown_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CountdownEventAdapter());
  await Hive.openBox<CountdownEvent>(CountdownRepository.boxName);

  runApp(const App());
}
```

#### T2.E — Smoke Test (Temporary)
- [ ] Add a **temporary** debug sanity check in `main()` right after opening the box:
```dart
  // DEBUG ONLY: basic smoke test (remove after T4)
  final box = Hive.box<CountdownEvent>(CountdownRepository.boxName);
  if (box.isEmpty) {
    box.put('demo1', CountdownEvent(
      id: 'demo1',
      title: 'Demo Event',
      dateUtc: DateTime.now().toUtc().add(const Duration(days: 3)),
      emoji: '🎉',
      notes: 'This is a demo entry.',
    ));
  }
  // print nearest upcoming
  final repo = CountdownRepository(box);
  final next = repo.nearestUpcoming(DateTime.now().toUtc());
  // ignore: avoid_print
  print('NEXT EVENT: ${next?.title} at ${next?.dateUtc.toIso8601String()}');
```

### Commands
- [ ] Run:
```
flutter pub get
flutter analyze
flutter run
```
- [ ] Observe console log for `NEXT EVENT:` line.

### Acceptance Criteria
- [ ] App compiles and launches.
- [ ] No `HiveError` about unknown typeId (confirms adapter registration).
- [ ] `NEXT EVENT:` prints a valid event on first run.
- [ ] Restart app; event persists (confirm `NEXT EVENT:` prints same id/title).

### Troubleshooting (Common)
- **`HiveError: Cannot write, unknown typeId: 1`** → You forgot `Hive.registerAdapter(CountdownEventAdapter())` before opening the box.
- **`HiveError: Box not found` or `box not opened`** → Ensure `await Hive.openBox<CountdownEvent>(CountdownRepository.boxName)` is called before use.
- **Data not persisted between runs** → You may be hot‑restarting before `await` completes; stop the app, `flutter run` again.
- **Wrong timezone math later** → Ensure `dateUtc` is created with `.toUtc()` when saving.

---

## Guidance: How to Maintain TASKS.md

- Keep **only the current in‑focus task(s)** at the top (e.g., T2 only), and move completed tasks into `TASKS_ARCHIVE.md`.  
- Alternatively, keep sections but collapse them to a single checked summary when done (saves tokens).  
- Always include: *Context → Files → Checklist (with code) → Commands → Acceptance → Troubleshooting*.  
