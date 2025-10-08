// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/app.dart';
import 'features/countdown/data/countdown_event.dart';
import 'features/countdown/data/countdown_repository.dart';
import 'features/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await NotificationService.instance.initialize();
  await NotificationService.instance.ensurePermissions();

  // Initialize Hive and boxes
  await Hive.initFlutter();
  Hive.registerAdapter(CountdownEventAdapter());
  await Hive.openBox<CountdownEvent>(CountdownRepository.boxName);

  // Add demo event if box is empty
  final box = Hive.box<CountdownEvent>(CountdownRepository.boxName);
  if (box.isEmpty) {
    box.put(
      'demo1',
      CountdownEvent(
        id: 'demo1',
        title: 'Demo Event',
        dateUtc: DateTime.now().toUtc().add(const Duration(days: 3)),
        emoji: null,
        notes: 'This is a demo entry.',
        reminderOffsets: const [1],
      ),
    );
  }

  // ✅ Wrap in ProviderScope for Riverpod
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
