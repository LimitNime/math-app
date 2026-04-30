import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RumusScreen extends StatefulWidget {
  const RumusScreen({super.key});
  @override
  State<RumusScreen> createState() => _RumusScreenState();
}

class _RumusScreenState extends State<RumusScreen> {
  String _selected = 'Aljabar';

  final _categories = {
    'Aljabar': [
      _Rumus('Persamaan Kuadrat', 'x = (-b ± √(b²-4ac)) / 2a',
          'Mencari akar persamaan ax² + bx + c = 0\n• a, b, c adalah koefisien\n• Diskriminan D = b²-4ac'),
      _Rumus('Pemfaktoran a²-b²', '(a+b)(a-b)',
          'Selisih dua kuadrat\nContoh: x²-9 = (x+3)(x-3)'),
      _Rumus('(a+b)²', 'a² + 2ab + b²', 'Kuadrat dari penjumlahan dua suku'),
      _Rumus('(a-b)²', 'a² - 2ab + b²', 'Kuadrat dari pengurangan dua suku'),
      _Rumus('Deret Aritmetika', 'Sn = n/2 × (a + Un)\nUn = a + (n-1)b',
          'a = suku pertama\nb = beda\nn = banyak suku'),
      _Rumus('Deret Geometri', 'Sn = a(rⁿ-1)/(r-1)\nUn = a × r^(n-1)',
          'a = suku pertama\nr = rasio\nn = banyak suku'),
    ],
    'Geometri': [
      _Rumus('Luas Persegi', 'L = s²', 's = sisi persegi'),
      _Rumus('Luas Persegi Panjang', 'L = p × l', 'p = panjang, l = lebar'),
      _Rumus('Luas Segitiga', 'L = ½ × a × t', 'a = alas, t = tinggi'),
      _Rumus('Luas Lingkaran', 'L = π × r²', 'r = jari-jari, π ≈ 3.14159'),
      _Rumus('Keliling Lingkaran', 'K = 2πr = πd', 'd = diameter'),
      _Rumus('Teorema Pythagoras', 'c² = a² + b²', 'a,b = sisi siku-siku\nc = hipotenusa'),
      _Rumus('Volume Kubus', 'V = s³', 's = rusuk kubus'),
      _Rumus('Volume Balok', 'V = p × l × t', 'p = panjang, l = lebar, t = tinggi'),
      _Rumus('Volume Tabung', 'V = π × r² × t', 'r = jari-jari, t = tinggi'),
      _Rumus('Volume Bola', 'V = (4/3) × π × r³', 'r = jari-jari'),
      _Rumus('Volume Kerucut', 'V = (1/3) × π × r² × t', 'r = jari-jari alas, t = tinggi'),
    ],
    'Trigonometri': [
      _Rumus('Sin, Cos, Tan', 'sin θ = depan/miring\ncos θ = samping/miring\ntan θ = depan/samping',
          'Pada segitiga siku-siku'),
      _Rumus('Identitas Pitagoras', 'sin²θ + cos²θ = 1\n1 + tan²θ = sec²θ',
          'Identitas trigonometri dasar'),
      _Rumus('Aturan Sinus', 'a/sin A = b/sin B = c/sin C',
          'Berlaku untuk semua segitiga'),
      _Rumus('Aturan Kosinus', 'c² = a² + b² - 2ab cos C',
          'Berlaku untuk semua segitiga'),
      _Rumus('Nilai Sudut Istimewa', 'sin 30° = ½\nsin 45° = ½√2\nsin 60° = ½√3',
          'Cos dan tan dapat diturunkan dari sin'),
      _Rumus('Rumus Jumlah Sudut', 'sin(A+B) = sinA cosB + cosA sinB\ncos(A+B) = cosA cosB - sinA sinB', ''),
    ],
    'Statistika': [
      _Rumus('Rata-rata (Mean)', 'x̄ = Σx / n', 'Σx = jumlah semua data\nn = banyak data'),
      _Rumus('Median', 'Data tengah setelah diurutkan',
          'Ganjil: data ke-(n+1)/2\nGenap: rata-rata data ke-n/2 dan (n/2)+1'),
      _Rumus('Modus', 'Nilai yang paling sering muncul', 'Bisa lebih dari satu modus'),
      _Rumus('Varians', 'σ² = Σ(xi - x̄)² / n', 'Ukuran sebaran data dari rata-rata'),
      _Rumus('Simpangan Baku', 'σ = √(Σ(xi-x̄)²/n)', 'Akar dari varians'),
      _Rumus('Kombinasi', 'C(n,r) = n! / (r!(n-r)!)', 'Memilih r dari n tanpa urutan'),
      _Rumus('Permutasi', 'P(n,r) = n! / (n-r)!', 'Memilih r dari n dengan urutan'),
    ],
    'Kalkulus': [
      _Rumus('Turunan (Diferensial)', "f'(x) = lim[h→0] (f(x+h)-f(x))/h",
          'Definisi turunan fungsi'),
      _Rumus('Turunan Pangkat', "d/dx [xⁿ] = n·xⁿ⁻¹", 'Aturan pangkat'),
      _Rumus('Turunan Perkalian', "(uv)' = u'v + uv'", 'Product rule'),
      _Rumus('Turunan Pembagian', "(u/v)' = (u'v - uv') / v²", 'Quotient rule'),
      _Rumus('Integral Pangkat', '∫xⁿ dx = xⁿ⁺¹/(n+1) + C', 'n ≠ -1'),
      _Rumus('Integral Tentu', '∫[a to b] f(x)dx = F(b) - F(a)', 'F(x) = antiturunan f(x)'),
      _Rumus('Luas Daerah', 'L = ∫[a to b] |f(x)| dx', 'Luas antara kurva dan sumbu-x'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final rumusList = _categories[_selected] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Rumus Matematika')),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.keys.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final k = _categories.keys.elementAt(i);
                final sel = k == _selected;
                return FilterChip(
                  label: Text(k, style: GoogleFonts.poppins(fontSize: 13)),
                  selected: sel,
                  onSelected: (_) => setState(() => _selected = k),
                  selectedColor: const Color(0xFFC62828).withOpacity(0.15),
                  checkmarkColor: const Color(0xFFC62828),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: rumusList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _RumusCard(rumus: rumusList[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Rumus {
  final String nama;
  final String formula;
  final String keterangan;
  const _Rumus(this.nama, this.formula, this.keterangan);
}

class _RumusCard extends StatelessWidget {
  final _Rumus rumus;
  const _RumusCard({required this.rumus});

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
                const Icon(Icons.functions_rounded, color: Color(0xFFC62828), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(rumus.nama,
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1A237E))),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E).withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.2)),
              ),
              child: Text(
                rumus.formula,
                style: GoogleFonts.sourceCodePro(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFC62828),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (rumus.keterangan.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(rumus.keterangan,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600, height: 1.5)),
            ],
          ],
        ),
      ),
    );
  }
}
