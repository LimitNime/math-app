import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class SiswaScreen extends StatelessWidget {
  const SiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Data Siswa')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Tambah Siswa'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: state.students.isEmpty
          ? _empty()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.students.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) => _StudentCard(student: state.students[i]),
            ),
    );
  }

  Widget _empty() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_rounded, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('Belum ada data siswa',
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16)),
            Text('Tekan tombol + untuk menambah',
                style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 13)),
          ],
        ),
      );

  void _showForm(BuildContext context, [Student? existing]) {
    final nameCtrl = TextEditingController(text: existing?.name);
    final classCtrl = TextEditingController(text: existing?.className);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(existing == null ? 'Tambah Siswa' : 'Edit Siswa',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1A237E))),
            const SizedBox(height: 16),
            _field(nameCtrl, 'Nama Siswa', Icons.person_rounded),
            const SizedBox(height: 12),
            _field(classCtrl, 'Kelas', Icons.class_rounded),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (nameCtrl.text.isEmpty || classCtrl.text.isEmpty) return;
                  final state = context.read<AppState>();
                  if (existing == null) {
                    await state.addStudent(Student(name: nameCtrl.text, className: classCtrl.text));
                  } else {
                    existing.name = nameCtrl.text;
                    existing.className = classCtrl.text;
                    await state.updateStudent(existing);
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: Text(existing == null ? 'Simpan' : 'Update',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon) => TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2)),
        ),
      );
}

class _StudentCard extends StatelessWidget {
  final Student student;
  const _StudentCard({required this.student});

  Color get _gradeColor {
    switch (student.grade) {
      case 'A': return const Color(0xFF2E7D32);
      case 'B': return const Color(0xFF1565C0);
      case 'C': return const Color(0xFFF57F17);
      case 'D': return const Color(0xFFE65100);
      default: return const Color(0xFFC62828);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1A237E).withOpacity(0.1),
          child: Text(
            student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
            style: GoogleFonts.poppins(color: const Color(0xFF1A237E), fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(student.name,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text('Kelas ${student.className}  •  ${student.scores.length} nilai',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
        trailing: student.scores.isEmpty
            ? null
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _gradeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${student.average.toStringAsFixed(1)} (${student.grade})',
                  style: GoogleFonts.poppins(
                      color: _gradeColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
        onLongPress: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Hapus Siswa?'),
              content: Text('Yakin hapus ${student.name}?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                TextButton(
                    onPressed: () async {
                      await context.read<AppState>().deleteStudent(student.id);
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text('Hapus', style: TextStyle(color: Colors.red))),
              ],
            ),
          );
        },
      ),
    );
  }
}
