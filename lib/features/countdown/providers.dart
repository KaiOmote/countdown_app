// lib/features/countdown/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../countdown/data/countdown_event.dart';
import '../countdown/data/countdown_repository.dart';

final countdownRepositoryProvider = Provider<CountdownRepository>((ref) {
  if (Hive.isBoxOpen('countdowns')) {
    return HiveCountdownRepository(Hive.box<CountdownEvent>('countdowns'));
  }
  return InMemoryCountdownRepository();
});

class CountdownListNotifier extends StateNotifier<List<CountdownEvent>> {
  CountdownListNotifier(this._repo) : super(_repo.getAll());
  final CountdownRepository _repo;

  void refresh() => state = _repo.getAll();
  CountdownEvent? getById(String id) => _repo.getById(id);
  CountdownEvent upsert(CountdownEvent e){ final s=_repo.upsert(e); refresh(); return s; }
  void delete(String id){ _repo.delete(id); refresh(); }
}

final countdownListProvider =
  StateNotifierProvider<CountdownListNotifier, List<CountdownEvent>>((ref) {
    final repo = ref.watch(countdownRepositoryProvider);
    return CountdownListNotifier(repo);
  });
