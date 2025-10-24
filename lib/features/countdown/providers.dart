// lib/features/countdown/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'data/countdown_event.dart';
import 'data/countdown_repository.dart';

const _boxName = 'countdowns';

/// The repo should be available because we open Hive box in main.dart before runApp.
final countdownRepositoryProvider = Provider<CountdownRepository>((ref) {
  if (!Hive.isBoxOpen(_boxName)) {
    throw StateError('Hive box "$_boxName" is not open. Ensure Hive is initialized in main.dart before runApp.');
  }
  return HiveCountdownRepository(Hive.box<CountdownEvent>(_boxName));
});

/// Plain list for UI (recomputes when ref.invalidate(eventsListProvider) is called)
final eventsListProvider = Provider<List<CountdownEvent>>((ref) {
  final repo = ref.watch(countdownRepositoryProvider);
  return repo.listAll();
});

/// The next upcoming event (>= today), or null if none.
final nearestUpcomingProvider = Provider<CountdownEvent?>((ref) {
  final list = ref.watch(eventsListProvider);
  final now = DateTime.now().toUtc();
  final today = DateTime.utc(now.year, now.month, now.day);
  CountdownEvent? best;
  for (final e in list) {
    final d = DateTime.utc(e.dateUtc.year, e.dateUtc.month, e.dateUtc.day);
    if (d.isBefore(today)) continue;
    if (best == null ||
        d.isBefore(DateTime.utc(best!.dateUtc.year, best!.dateUtc.month, best!.dateUtc.day))) {
      best = e;
    }
  }
  return best;
});
