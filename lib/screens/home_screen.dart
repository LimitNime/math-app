import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'siswa_screen.dart';
import 'nilai_screen.dart';
import 'kalkulator_screen.dart';
import 'soal_screen.dart';
import 'statistik_screen.dart';
import 'rumus_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      _MenuItem(
        icon: Icons.people_alt_rounded,
        label: 'Data Siswa',
        color: const Color(0xFF1565C0),
        screen: const SiswaScreen(),
      ),
      _MenuItem(
        icon: Icons.grade_rounded,
        label: 'Input Nilai',
        color: const Color(0xFF2E7D32),
        screen: const NilaiScreen(),
      ),
      _MenuItem(
        icon: Icons.calculate_rounded,
        label: 'Kalkulator',
        color: const Color(0xFF6A1B9A),
        screen: const KalkulatorScreen(),
      ),
      _MenuItem(
        icon: Icons.quiz_rounded,
        label: 'Bank Soal',
        color: const Color(0xFFE65100),
        screen: const SoalScreen(),
      ),
      _MenuItem(
        icon: Icons.bar_chart_rounded,
        label: 'Statistik',
        color: const Color(0xFF00695C),
        screen: const StatistikScreen(),
      ),
      _MenuItem(
        icon: Icons.functions_rounded,
        label: 'Rumus',
        color: const Color(0xFFC62828),
        screen: const RumusScreen(),
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF1A237E),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF3949AB)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.school_rounded, size: 48, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Guru Matematika',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Kelola kelas dengan mudah',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => _MenuCard(item: menus[i]),
                childCount: menus.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _InfoBanner(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final Widget screen;
  const _MenuItem({required this.icon, required this.label, required this.color, required this.screen});
}

class _MenuCard extends StatelessWidget {
  final _MenuItem item;
  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      shadowColor: item.color.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item.screen)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: item.color.withOpacity(0.15), width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, size: 36, color: item.color),
              ),
              const SizedBox(height: 12),
              Text(
                item.label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: const Color(0xFF1A237E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_rounded, color: Colors.amber, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tips Mengajar',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Gunakan bank soal untuk membuat latihan yang bervariasi!',
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
