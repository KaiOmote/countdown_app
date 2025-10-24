// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/app.dart';
import 'features/countdown/data/countdown_event.dart';

const _countdownsBox = 'countdowns';
const _settingsBox = 'settings';

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CountdownEventAdapter());

  // Open countdowns box; nuke only if corrupt (dev safety)
  try {
    await Hive.openBox<CountdownEvent>(_countdownsBox);
  } catch (_) {
    await Hive.deleteBoxFromDisk(_countdownsBox);
    await Hive.openBox<CountdownEvent>(_countdownsBox);
  }

  // Open settings box (dynamic, no adapters needed)
  try {
    await Hive.openBox(_settingsBox);
  } catch (_) {
    await Hive.deleteBoxFromDisk(_settingsBox);
    await Hive.openBox(_settingsBox);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initHive();
  runApp(const ProviderScope(child: App()));
}
