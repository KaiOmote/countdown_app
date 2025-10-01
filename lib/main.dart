import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/app.dart';
import 'features/countdown/data/countdown_event.dart';
import 'features/countdown/data/countdown_repository.dart';
import 'features/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive init
  await Hive.initFlutter();
  Hive.registerAdapter(CountdownEventAdapter());
  await Hive.openBox<CountdownEvent>(CountdownRepository.boxName);

  // ⚠️ DEV ONLY: uncomment to wipe data after model changes
  // final box = Hive.box<CountdownEvent>(CountdownRepository.boxName);
  // await box.clear();

  // Notifications init
  await NotificationService.instance.initialize();

  // DEBUG seed (optional)
  final box = Hive.box<CountdownEvent>(CountdownRepository.boxName);
  if (box.isEmpty) {
    box.put(
      'demo1',
      CountdownEvent(
        id: 'demo1',
        title: 'Demo Event',
        dateUtc: DateTime.now().toUtc().add(const Duration(days: 3)),
        emoji: '🎉',
        notes: 'This is a demo entry.',
        reminderOffsets: const [1], // 1 day before
      ),
    );
  }

  runApp(const App());
}
