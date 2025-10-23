// lib/features/settings/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// -------------------------------
/// Theme Mode (existing behavior)
/// -------------------------------
final themeProvider = StateNotifierProvider<ThemeController, ThemeMode>((ref) {
  return ThemeController();
});

class ThemeController extends StateNotifier<ThemeMode> {
  static const _boxName = 'settingsBox';
  static const _themeKey = 'themeMode';

  ThemeController() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox(_boxName);
    final saved = box.get(_themeKey);
    if (saved != null && saved is int && saved >= 0 && saved < ThemeMode.values.length) {
      state = ThemeMode.values[saved];
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final box = await Hive.openBox(_boxName);
    await box.put(_themeKey, mode.index);
    debugPrint('[Theme] Switched to: $mode');
  }
}

/// -------------------------------
/// Seed Color (new!)
/// -------------------------------
final seedColorProvider =
    StateNotifierProvider<SeedColorController, Color>((ref) {
  return SeedColorController();
});

class SeedColorController extends StateNotifier<Color> {
  static const _boxName = 'settingsBox';
  static const _seedKey = 'seedColor';

  SeedColorController() : super(Colors.pink) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox(_boxName);
    final raw = box.get(_seedKey) as int?;
    if (raw != null) state = Color(raw);
  }

  Future<void> setSeed(Color c) async {
    state = c;
    final box = await Hive.openBox(_boxName);
    await box.put(_seedKey, c.value);
    debugPrint('[Theme] Seed color set: ${c.value.toRadixString(16)}');
  }
}

/// -------------------------------
/// ThemeData from seed (M3)
/// -------------------------------
ThemeData _buildFromSeed(Color seed, Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    // (Optional) add global component tweaks here if you like
  );
}

final themeDataLightProvider = Provider<ThemeData>((ref) {
  final seed = ref.watch(seedColorProvider);
  return _buildFromSeed(seed, Brightness.light);
});

final themeDataDarkProvider = Provider<ThemeData>((ref) {
  final seed = ref.watch(seedColorProvider);
  return _buildFromSeed(seed, Brightness.dark);
});
