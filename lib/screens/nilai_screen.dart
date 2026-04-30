import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class NilaiScreen extends StatefulWidget {
  const NilaiScreen({super.key});
  @override
  State<NilaiScreen> createState() => _NilaiScreenState();
}

class _NilaiScreenState extends State<NilaiScreen> {
  Student? _selected;
  final _scoreCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Input Nilai')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('Pilih Siswa'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Student>(
                  value: _selected,
                  isExpanded: true,
                  hint: Text('-- Pilih Siswa --', style: GoogleFonts.poppins()),
                  items: state.students
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text('${s.name} (${s.className})',
                                style: GoogleFonts.poppins()),
                          ))
                      .toList(),
                  onChanged: (s) => setState(() => _selected = s),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _section('Masukkan Nilai'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _scoreCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: '0 - 100',
                      prefixIcon: const Icon(Icons.score_rounded, color: Color(0xFF2E7D32)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _tambahNilai,
                  child: Text('Tambah', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_selected != null) ...[
              _section('Riwayat Nilai - ${_selected!.name}'),
              const SizedBox(height: 8),
              if (_selected!.scores.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Belum ada nilai', style: GoogleFonts.poppins(color: Colors.grey)),
                  ),
                )
              else
                ...List.generate(
                  _selected!.scores.length,
                  (i) => _ScoreRow(
                    no: i + 1,
                    score: _selected!.scores[i],
                    color: _scoreColor(_selected!.scores[i]),
                  ),
                ),
              if (_selected!.scores.isNotEmpty) ...[
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rata-rata:', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                    Text(
                      '${_selected!.average.toStringAsFixed(2)} (${_selected!.grade})',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: _scoreColor(_selected!.average),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _tambahNilai() async {
    if (_selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih siswa terlebih dahulu')));
      return;
    }
    final val = double.tryParse(_scoreCtrl.text);
    if (val == null || val < 0 || val > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nilai harus antara 0 - 100')));
      return;
    }
    await context.read<AppState>().addScore(_selected!.id, val);
    _scoreCtrl.clear();
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Nilai ${val.toStringAsFixed(0)} berhasil ditambahkan!')));
    }
  }

  Color _scoreColor(double s) {
    if (s >= 90) return const Color(0xFF2E7D32);
    if (s >= 80) return const Color(0xFF1565C0);
    if (s >= 70) return const Color(0xFFF57F17);
    if (s >= 60) return const Color(0xFFE65100);
    return const Color(0xFFC62828);
  }

  Widget _section(String t) => Text(t,
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1A237E)));
}

class _ScoreRow extends StatelessWidget {
  final int no;
  final double score;
  final Color color;
  const _ScoreRow({required this.no, required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text('Nilai $no', style: GoogleFonts.poppins(color: Colors.grey)),
          const Spacer(),
          Text(score.toStringAsFixed(0),
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        ],
      ),
    );
  }
}
