// lib/features/countdown/data/countdown_repository.dart
import 'dart:math';
import 'package:hive/hive.dart';
import 'countdown_event.dart';

abstract class CountdownRepository {
  List<CountdownEvent> getAll();
  CountdownEvent? getById(String id);
  CountdownEvent upsert(CountdownEvent event);
  void delete(String id);
}

// In-memory fallback (used before Hive is open, or for tests)
class InMemoryCountdownRepository implements CountdownRepository {
  final Map<String, CountdownEvent> _store = {};
  InMemoryCountdownRepository() {
    final id = _genId();
    _store[id] = CountdownEvent(
      id: id,
      title: 'Sample Event',
      date: DateTime.now().add(const Duration(days: 5)),
      notes: 'You can edit or delete me.',
    );
  }
  @override List<CountdownEvent> getAll() => (_store.values.toList()..sort((a,b)=>a.date.compareTo(b.date)));
  @override CountdownEvent? getById(String id) => _store[id];
  @override CountdownEvent upsert(CountdownEvent e){ final s = e.id.isEmpty? e.copyWith(id:_genId()):e; _store[s.id]=s; return s; }
  @override void delete(String id){ _store.remove(id); }
  String _genId(){ const c='abcdefghijklmnopqrstuvwxyz0123456789'; final r=Random(); return List.generate(12,(_)=>c[r.nextInt(c.length)]).join(); }
}

// Hive-backed implementation (persistent)
class HiveCountdownRepository implements CountdownRepository {
  HiveCountdownRepository(this._box);
  final Box<CountdownEvent> _box;

  @override
  List<CountdownEvent> getAll() {
    final list = _box.values.toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  @override
  CountdownEvent? getById(String id) => _box.get(id);

  @override
  CountdownEvent upsert(CountdownEvent event) {
    final saved = event.id.isEmpty ? event.copyWith(id: _genId()) : event;
    _box.put(saved.id, saved);
    return saved;
  }

  @override
  void delete(String id) => _box.delete(id);

  String _genId(){ const c='abcdefghijklmnopqrstuvwxyz0123456789'; final r=Random(); return List.generate(12,(_)=>c[r.nextInt(c.length)]).join(); }
}
