// lib/features/settings/language_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

const _settingsBoxName = 'settings';
const _localeKey = 'localeCode'; // 'en', 'ja', or null -> system

/// Holds the app's active Locale (null = follow system).
final localeProvider = StateNotifierProvider<LocaleController, Locale?>((ref) {
  // Box MUST be opened in main.dart before runApp
  final box = Hive.box(_settingsBoxName);
  final code = box.get(_localeKey) as String?;
  return LocaleController._(box, _codeToLocale(code));
});

class LocaleController extends StateNotifier<Locale?> {
  LocaleController._(this._box, Locale? initial) : super(initial);

  final Box _box;

  void setSystem() {
    state = null;
    _box.put(_localeKey, null);
  }

  void setEnglish() {
    state = const Locale('en');
    _box.put(_localeKey, 'en');
  }

  void setJapanese() {
    state = const Locale('ja');
    _box.put(_localeKey, 'ja');
  }
}

Locale? _codeToLocale(String? code) {
  if (code == null || code.isEmpty) return null;
  return Locale(code);
}
