import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/app_state.dart';

class StatistikScreen extends StatelessWidget {
  const StatistikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final dist = state.gradeDistribution;
    final avg = state.classAverage;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik Kelas')),
      body: state.students.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart_rounded, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('Belum ada data siswa', style: GoogleFonts.poppins(color: Colors.grey)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _summaryRow(state, avg),
                  const SizedBox(height: 20),
                  _card(
                    title: 'Distribusi Nilai (Bar)',
                    child: SizedBox(
                      height: 220,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: (state.students.length + 1).toDouble(),
                          barGroups: dist.entries.map((e) {
                            return BarChartGroupData(
                              x: ['A', 'B', 'C', 'D', 'E'].indexOf(e.key),
                              barRods: [
                                BarChartRodData(
                                  toY: e.value.toDouble(),
                                  color: _gradeColor(e.key),
                                  width: 32,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            );
                          }).toList(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, _) => Text(
                                  ['A', 'B', 'C', 'D', 'E'][v.toInt()],
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (v, _) => Text(
                                  v.toInt().toString(),
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ),
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(show: true, horizontalInterval: 1),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _card(
                    title: 'Distribusi Nilai (Pie)',
                    child: SizedBox(
                      height: 220,
                      child: PieChart(
                        PieChartData(
                          sections: dist.entries
                              .where((e) => e.value > 0)
                              .map((e) => PieChartSectionData(
                                    value: e.value.toDouble(),
                                    color: _gradeColor(e.key),
                                    title: '${e.key}\n${e.value}',
                                    titleStyle: GoogleFonts.poppins(
                                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    radius: 90,
                                  ))
                              .toList(),
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _card(
                    title: 'Daftar Nilai Siswa',
                    child: Column(
                      children: state.students.map((s) => _studentRow(s)).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _summaryRow(AppState state, double avg) {
    return Row(
      children: [
        _statTile('Jumlah Siswa', '${state.students.length}', Icons.people_rounded, const Color(0xFF1565C0)),
        const SizedBox(width: 12),
        _statTile('Rata-rata Kelas', avg.toStringAsFixed(1), Icons.equalizer_rounded, const Color(0xFF2E7D32)),
      ],
    );
  }

  Widget _statTile(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1A237E))),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _studentRow(Student s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF1A237E).withOpacity(0.1),
            child: Text(s.name[0], style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF1A237E))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(s.name, style: GoogleFonts.poppins(fontSize: 14))),
          Text(s.average.toStringAsFixed(1),
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: _gradeColor(s.grade))),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _gradeColor(s.grade).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(s.grade,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: _gradeColor(s.grade), fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Color _gradeColor(String g) {
    switch (g) {
      case 'A': return const Color(0xFF2E7D32);
      case 'B': return const Color(0xFF1565C0);
      case 'C': return const Color(0xFFF57F17);
      case 'D': return const Color(0xFFE65100);
      default: return const Color(0xFFC62828);
    }
  }
}
