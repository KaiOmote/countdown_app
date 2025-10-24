// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/app.dart';
import 'features/countdown/data/countdown_event.dart';

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CountdownEventAdapter()); // from countdown_event.dart
  await Hive.openBox<CountdownEvent>('countdowns');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initHive(); // open the box before ProviderScope
  runApp(const ProviderScope(child: App()));
}
