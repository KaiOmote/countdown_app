import 'package:hive/hive.dart';

// part 'countdown_event.g.dart'; // not generating code; adapter will be manual below (no build_runner required)

@HiveType(typeId: 1)
class CountdownEvent {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime dateUtc; // must be UTC
  @HiveField(3)
  final String? emoji;
  @HiveField(4)
  final String? notes;

  const CountdownEvent({
    required this.id,
    required this.title,
    required this.dateUtc,
    this.emoji,
    this.notes,
  });

  CountdownEvent copyWith({
    String? id,
    String? title,
    DateTime? dateUtc,
    String? emoji,
    String? notes,
  }) => CountdownEvent(
        id: id ?? this.id,
        title: title ?? this.title,
        dateUtc: dateUtc ?? this.dateUtc,
        emoji: emoji ?? this.emoji,
        notes: notes ?? this.notes,
      );
}

// Manual TypeAdapter to avoid build_runner
class CountdownEventAdapter extends TypeAdapter<CountdownEvent> {
  @override
  final int typeId = 1;

  @override
  CountdownEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountdownEvent(
      id: fields[0] as String,
      title: fields[1] as String,
      dateUtc: fields[2] as DateTime,
      emoji: fields[3] as String?,
      notes: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CountdownEvent obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dateUtc)
      ..writeByte(3)
      ..write(obj.emoji)
      ..writeByte(4)
      ..write(obj.notes);
  }
}
