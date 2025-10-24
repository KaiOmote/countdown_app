// lib/features/countdown/data/countdown_event.dart
import 'package:flutter/foundation.dart';

// --- Hive TypeAdapter (manual, no codegen) ---
import 'package:hive/hive.dart';

@immutable
class CountdownEvent {
  final String id;
  final String title;
  final DateTime date; // local date (midnight)
  final String? notes;
  final bool remindersEnabled;

  const CountdownEvent({
    required this.id,
    required this.title,
    required this.date,
    this.notes,
    this.remindersEnabled = false,
  });

  // Compatibility for old code that referenced dateUtc/reminderOffsets:
  DateTime get dateUtc => date.toUtc();
  List<int> get reminderOffsets => const []; // extend later if you need multiple reminders

  CountdownEvent copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? notes,
    bool? remindersEnabled,
  }) {
    return CountdownEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'notes': notes,
        'remindersEnabled': remindersEnabled,
      };

  factory CountdownEvent.fromMap(Map<String, dynamic> map) {
    return CountdownEvent(
      id: map['id'] as String,
      title: map['title'] as String,
      date: DateTime.parse(map['date'] as String),
      notes: map['notes'] as String?,
      remindersEnabled: (map['remindersEnabled'] as bool?) ?? false,
    );
  }
}

class CountdownEventAdapter extends TypeAdapter<CountdownEvent> {
  @override
  final int typeId = 1; // keep stable

  @override
  CountdownEvent read(BinaryReader r) {
    final id = r.readString();
    final title = r.readString();
    final millis = r.readInt();
    final hasNotes = r.readBool();
    final notes = hasNotes ? r.readString() : null;
    final remindersEnabled = r.readBool();
    return CountdownEvent(
      id: id,
      title: title,
      date: DateTime.fromMillisecondsSinceEpoch(millis),
      notes: notes,
      remindersEnabled: remindersEnabled,
    );
  }

  @override
  void write(BinaryWriter w, CountdownEvent obj) {
    w.writeString(obj.id);
    w.writeString(obj.title);
    w.writeInt(obj.date.millisecondsSinceEpoch);
    w.writeBool(obj.notes != null);
    if (obj.notes != null) w.writeString(obj.notes!);
    w.writeBool(obj.remindersEnabled);
  }
}
