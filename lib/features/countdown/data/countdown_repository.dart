import 'package:hive/hive.dart';
import 'countdown_event.dart';

class CountdownRepository {
  static const String boxName = 'eventsBox';
  final Box<CountdownEvent> _box;

  CountdownRepository(this._box);

  List<CountdownEvent> listAll() {
    final items = _box.values.toList();
    items.sort((a, b) => a.dateUtc.compareTo(b.dateUtc));
    return items;
  }

  Future<void> add(CountdownEvent e) async {
    await _box.put(e.id, e);
  }

  Future<void> update(CountdownEvent e) async {
    await _box.put(e.id, e);
  }

  Future<void> remove(String id) async {
    await _box.delete(id);
  }

  CountdownEvent? nearestUpcoming(DateTime nowUtc) {
    CountdownEvent? best;
    for (final e in _box.values) {
      if (e.dateUtc.isAfter(nowUtc)) {
        if (best == null || e.dateUtc.isBefore(best!.dateUtc)) {
          best = e;
        }
      }
    }
    return best;
  }
}
