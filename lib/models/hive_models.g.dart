// GENERATED CODE - DO NOT MODIFY BY HAND
// Manually written TypeAdapters for Hive (replaces build_runner output)

part of 'hive_models.dart';

// ── StudentHive Adapter ──────────────────────────────────────
class StudentHiveAdapter extends TypeAdapter<StudentHive> {
  @override
  final int typeId = kStudentTypeId;

  @override
  StudentHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentHive(
      id: fields[0] as String,
      name: fields[1] as String,
      className: fields[2] as String,
      scores: (fields[3] as List).cast<double>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudentHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.className)
      ..writeByte(3)
      ..write(obj.scores);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ── SoalHive Adapter ─────────────────────────────────────────
class SoalHiveAdapter extends TypeAdapter<SoalHive> {
  @override
  final int typeId = kSoalTypeId;

  @override
  SoalHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoalHive(
      id: fields[0] as String,
      pertanyaan: fields[1] as String,
      jawaban: fields[2] as String,
      kategori: fields[3] as String,
      tingkat: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SoalHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pertanyaan)
      ..writeByte(2)
      ..write(obj.jawaban)
      ..writeByte(3)
      ..write(obj.kategori)
      ..writeByte(4)
      ..write(obj.tingkat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoalHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
