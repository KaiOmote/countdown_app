// lib/features/countdown/data/countdown_repository.dart
import 'dart:math';
import 'package:hive/hive.dart';
import 'countdown_event.dart';

abstract class CountdownRepository {
  /// Synchronous list for your UI (you invalidate providers after writes)
  List<CountdownEvent> listAll();

  Future<void> add(CountdownEvent event);
  Future<void> update(CountdownEvent event);
  Future<void> remove(String id);
}

class HiveCountdownRepository implements CountdownRepository {
  HiveCountdownRepository(this._box);
  final Box<CountdownEvent> _box;

  @override
  List<CountdownEvent> listAll() {
    final list = _box.values.toList();
    list.sort((a, b) => a.dateUtc.compareTo(b.dateUtc));
    return list;
  }

  @override
  Future<void> add(CountdownEvent event) async {
    final saved = event.id.isEmpty ? event.copyWith(id: _genId()) : event;
    await _box.put(saved.id, saved);
  }

  @override
  Future<void> update(CountdownEvent event) async {
    if (event.id.isEmpty) {
      throw ArgumentError('event.id must not be empty for update');
    }
    await _box.put(event.id, event);
  }

  @override
  Future<void> remove(String id) async {
    await _box.delete(id);
  }

  String _genId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final r = Random();
    return List.generate(12, (_) => chars[r.nextInt(chars.length)]).join();
  }
}
