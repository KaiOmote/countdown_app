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

  runApp(const App());
}