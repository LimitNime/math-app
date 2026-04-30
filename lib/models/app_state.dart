import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'hive_models.dart';

// Alias agar semua screen tidak perlu diubah
typedef Student = StudentHive;
typedef SoalModel = SoalHive;

const String _boxStudents = 'students';
const String _boxSoal = 'soal';

class AppState extends ChangeNotifier {
  late Box<StudentHive> _studentBox;
  late Box<SoalHive> _soalBox;
  bool _initialized = false;

  bool get initialized => _initialized;

  // ── Init Hive ─────────────────────────────────────────────
  Future<void> init() async {
    _studentBox = await Hive.openBox<StudentHive>(_boxStudents);
    _soalBox = await Hive.openBox<SoalHive>(_boxSoal);
    _initialized = true;
    notifyListeners();
  }

  // ── Getters ───────────────────────────────────────────────
  List<StudentHive> get students => _studentBox.values.toList();
  List<SoalHive> get soalList => _soalBox.values.toList();

  // ── Students ──────────────────────────────────────────────
  Future<void> addStudent(StudentHive s) async {
    await _studentBox.put(s.id, s);
    notifyListeners();
  }

  Future<void> updateStudent(StudentHive s) async {
    await _studentBox.put(s.id, s);
    notifyListeners();
  }

  Future<void> deleteStudent(String id) async {
    await _studentBox.delete(id);
    notifyListeners();
  }

  Future<void> addScore(String studentId, double score) async {
    final s = _studentBox.get(studentId);
    if (s != null) {
      s.scores = [...s.scores, score];
      await s.save();
      notifyListeners();
    }
  }

  Future<void> deleteScore(String studentId, int index) async {
    final s = _studentBox.get(studentId);
    if (s != null) {
      final updated = [...s.scores];
      updated.removeAt(index);
      s.scores = updated;
      await s.save();
      notifyListeners();
    }
  }

  // ── Soal ─────────────────────────────────────────────────
  Future<void> addSoal(SoalHive soal) async {
    await _soalBox.put(soal.id, soal);
    notifyListeners();
  }

  Future<void> deleteSoal(String id) async {
    await _soalBox.delete(id);
    notifyListeners();
  }

  // ── Stats ─────────────────────────────────────────────────
  Map<String, int> get gradeDistribution {
    final map = {'A': 0, 'B': 0, 'C': 0, 'D': 0, 'E': 0};
    for (final s in students) {
      map[s.grade] = (map[s.grade] ?? 0) + 1;
    }
    return map;
  }

  double get classAverage {
    final list = students;
    if (list.isEmpty) return 0;
    return list.map((s) => s.average).reduce((a, b) => a + b) / list.length;
  }
}
