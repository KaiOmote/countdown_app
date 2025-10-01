// countdown_app/lib/features/countdown/providers.dart
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
