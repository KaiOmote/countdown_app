// lib/features/countdown/data/countdown_event.dart
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

@immutable
class CountdownEvent {
  final String id;
  final String title;
  /// Store the target date in UTC (midnight UTC works fine for day math)
  final DateTime dateUtc;
  final String? emoji;
  final String? notes;
  /// e.g. [1, 3, 7] means “remind 1/3/7 days before”
  final List<int> reminderOffsets;

  const CountdownEvent({
    required this.id,
    required this.title,
    required this.dateUtc,
    this.emoji,
    this.notes,
    this.reminderOffsets = const [],
  });

  CountdownEvent copyWith({
    String? id,
    String? title,
    DateTime? dateUtc,
    String? emoji,
    String? notes,
    List<int>? reminderOffsets,
  }) {
    return CountdownEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      dateUtc: dateUtc ?? this.dateUtc,
      emoji: emoji ?? this.emoji,
      notes: notes ?? this.notes,
      reminderOffsets: reminderOffsets ?? this.reminderOffsets,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'dateUtc': dateUtc.toIso8601String(),
        'emoji': emoji,
        'notes': notes,
        'reminderOffsets': reminderOffsets,
      };

  factory CountdownEvent.fromMap(Map<String, dynamic> map) {
    return CountdownEvent(
      id: map['id'] as String,
      title: map['title'] as String,
      dateUtc: DateTime.parse(map['dateUtc'] as String),
      emoji: map['emoji'] as String?,
      notes: map['notes'] as String?,
      reminderOffsets: (map['reminderOffsets'] as List?)?.map((e) => e as int).toList() ?? const [],
    );
  }
}

/// Manual Hive TypeAdapter (no build_runner needed)
class CountdownEventAdapter extends TypeAdapter<CountdownEvent> {
  @override
  final int typeId = 1; // keep stable once shipped

  @override
  CountdownEvent read(BinaryReader r) {
    final id = r.readString();
    final title = r.readString();
    final epochMillisUtc = r.readInt();
    final hasEmoji = r.readBool();
    final emoji = hasEmoji ? r.readString() : null;
    final hasNotes = r.readBool();
    final notes = hasNotes ? r.readString() : null;
    final len = r.readInt();
    final offsets = List<int>.generate(len, (_) => r.readInt(), growable: false);
    return CountdownEvent(
      id: id,
      title: title,
      dateUtc: DateTime.fromMillisecondsSinceEpoch(epochMillisUtc, isUtc: true),
      emoji: emoji,
      notes: notes,
      reminderOffsets: offsets,
    );
  }

  @override
  void write(BinaryWriter w, CountdownEvent obj) {
    w.writeString(obj.id);
    w.writeString(obj.title);
    w.writeInt(obj.dateUtc.toUtc().millisecondsSinceEpoch);
    if (obj.emoji == null) {
      w.writeBool(false);
    } else {
      w.writeBool(true);
      w.writeString(obj.emoji!);
    }
    if (obj.notes == null) {
      w.writeBool(false);
    } else {
      w.writeBool(true);
      w.writeString(obj.notes!);
    }
    w.writeInt(obj.reminderOffsets.length);
    for (final o in obj.reminderOffsets) {
      w.writeInt(o);
    }
  }
}
