import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'hive_models.g.dart';

const _uuid = Uuid();

// ── TypeId constants ─────────────────────────────────────────
const int kStudentTypeId = 0;
const int kSoalTypeId = 1;

// ── Student ──────────────────────────────────────────────────
@HiveType(typeId: kStudentTypeId)
class StudentHive extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String className;

  @HiveField(3)
  late List<double> scores;

  StudentHive({
    String? id,
    required String name,
    required String className,
    List<double>? scores,
  }) {
    this.id = id ?? _uuid.v4();
    this.name = name;
    this.className = className;
    this.scores = scores ?? [];
  }

  double get average =>
      scores.isEmpty ? 0 : scores.reduce((a, b) => a + b) / scores.length;

  String get grade {
    final avg = average;
    if (avg >= 90) return 'A';
    if (avg >= 80) return 'B';
    if (avg >= 70) return 'C';
    if (avg >= 60) return 'D';
    return 'E';
  }
}

// ── SoalModel ────────────────────────────────────────────────
@HiveType(typeId: kSoalTypeId)
class SoalHive extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String pertanyaan;

  @HiveField(2)
  late String jawaban;

  @HiveField(3)
  late String kategori;

  @HiveField(4)
  late String tingkat;

  SoalHive({
    String? id,
    required String pertanyaan,
    required String jawaban,
    required String kategori,
    required String tingkat,
  }) {
    this.id = id ?? _uuid.v4();
    this.pertanyaan = pertanyaan;
    this.jawaban = jawaban;
    this.kategori = kategori;
    this.tingkat = tingkat;
  }
}
