import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class SoalScreen extends StatefulWidget {
  const SoalScreen({super.key});
  @override
  State<SoalScreen> createState() => _SoalScreenState();
}

class _SoalScreenState extends State<SoalScreen> {
  String _filterKategori = 'Semua';
  bool _showAnswer = false;

  final _kategoriList = ['Semua', 'Aljabar', 'Geometri', 'Statistika', 'Kalkulus', 'Aritmetika', 'Trigonometri'];
  final _tingkatList = ['Mudah', 'Sedang', 'Sulit'];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final filtered = _filterKategori == 'Semua'
        ? state.soalList
        : state.soalList.where((s) => s.kategori == _filterKategori).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Soal'),
        actions: [
          IconButton(
            icon: Icon(_showAnswer ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showAnswer = !_showAnswer),
            tooltip: _showAnswer ? 'Sembunyikan jawaban' : 'Tampilkan jawaban',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context),
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text('Tambah Soal'),
        backgroundColor: const Color(0xFFE65100),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _filterRow(),
          Expanded(
            child: filtered.isEmpty
                ? _empty()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) => _SoalCard(
                        soal: filtered[i], showAnswer: _showAnswer),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterRow() => SizedBox(
        height: 52,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          scrollDirection: Axis.horizontal,
          itemCount: _kategoriList.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final k = _kategoriList[i];
            final sel = k == _filterKategori;
            return FilterChip(
              label: Text(k, style: GoogleFonts.poppins(fontSize: 13)),
              selected: sel,
              onSelected: (_) => setState(() => _filterKategori = k),
              selectedColor: const Color(0xFFE65100).withOpacity(0.15),
              checkmarkColor: const Color(0xFFE65100),
            );
          },
        ),
      );

  Widget _empty() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('Belum ada soal', style: GoogleFonts.poppins(color: Colors.grey)),
          ],
        ),
      );

  void _showForm(BuildContext context) {
    final pertCtrl = TextEditingController();
    final jawCtrl = TextEditingController();
    String kat = 'Aljabar';
    String tingkat = 'Sedang';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tambah Soal',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFFE65100))),
                const SizedBox(height: 16),
                TextField(
                  controller: pertCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Pertanyaan',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: jawCtrl,
                  decoration: InputDecoration(
                    labelText: 'Jawaban / Pembahasan',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: kat,
                        decoration: InputDecoration(
                            labelText: 'Kategori',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        items: _kategoriList
                            .where((k) => k != 'Semua')
                            .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                            .toList(),
                        onChanged: (v) => setS(() => kat = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: tingkat,
                        decoration: InputDecoration(
                            labelText: 'Tingkat',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        items: _tingkatList
                            .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                            .toList(),
                        onChanged: (v) => setS(() => tingkat = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE65100),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      if (pertCtrl.text.isEmpty || jawCtrl.text.isEmpty) return;
                      await context.read<AppState>().addSoal(SoalModel(
                          pertanyaan: pertCtrl.text,
                          jawaban: jawCtrl.text,
                          kategori: kat,
                          tingkat: tingkat));
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: Text('Simpan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SoalCard extends StatelessWidget {
  final SoalModel soal;
  final bool showAnswer;
  const _SoalCard({required this.soal, required this.showAnswer});

  Color get _tingkatColor {
    switch (soal.tingkat) {
      case 'Mudah': return const Color(0xFF2E7D32);
      case 'Sedang': return const Color(0xFFF57F17);
      default: return const Color(0xFFC62828);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE65100).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(soal.kategori,
                      style: GoogleFonts.poppins(
                          color: const Color(0xFFE65100), fontSize: 12, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _tingkatColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(soal.tingkat,
                      style: GoogleFonts.poppins(
                          color: _tingkatColor, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => context.read<AppState>().deleteSoal(soal.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(soal.pertanyaan, style: GoogleFonts.poppins(fontSize: 14, height: 1.5)),
            if (showAnswer) ...[
              const Divider(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(soal.jawaban,
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF2E7D32), fontSize: 13, fontStyle: FontStyle.italic)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
