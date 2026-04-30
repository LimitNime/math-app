# 📐 Aplikasi Guru Matematika (Flutter)

Aplikasi Android lengkap untuk guru matematika, dibangun dengan Flutter.

---

## ✨ Fitur Lengkap

| Fitur | Keterangan |
|---|---|
| 👨‍🎓 Data Siswa | Tambah, edit, hapus data siswa beserta kelas |
| 📊 Input Nilai | Input nilai per siswa, hitung rata-rata & grade otomatis |
| 🧮 Kalkulator | Kalkulator ilmiah dengan ekspresi matematika |
| 📝 Bank Soal | Kelola soal per kategori & tingkat kesulitan |
| 📈 Statistik | Grafik bar & pie distribusi nilai kelas |
| 📖 Rumus | Referensi rumus Aljabar, Geometri, Trigonometri, Statistika, Kalkulus |

---

## 🛠️ Cara Build & Install APK

### Syarat
- Flutter SDK **3.x** atau lebih baru → https://flutter.dev/docs/get-started/install
- Android Studio atau VS Code
- Android SDK (API 21+)
- Perangkat Android atau emulator

### Langkah-langkah

**1. Install Flutter** (jika belum)
```bash
# Download dari https://flutter.dev
# Tambahkan ke PATH, lalu:
flutter doctor
```

**2. Clone / Ekstrak project ini**
```bash
# Ekstrak zip, lalu masuk ke folder:
cd math_teacher_app
```

**3. Install dependencies**
```bash
flutter pub get
```

**4. Jalankan di emulator/device (mode debug)**
```bash
flutter run
```

**5. Build APK (bisa langsung install)**
```bash
# APK debug (langsung install untuk testing):
flutter build apk --debug

# APK release (lebih kecil & cepat):
flutter build apk --release
```

**6. Lokasi file APK setelah build**
```
build/app/outputs/flutter-apk/app-debug.apk
build/app/outputs/flutter-apk/app-release.apk
```

**7. Install ke HP Android**
```bash
# Via USB (dengan USB Debugging aktif):
flutter install

# Atau copy APK ke HP dan buka filenya
```

---

## 📁 Struktur Project

```
math_teacher_app/
├── lib/
│   ├── main.dart               # Entry point & tema
│   ├── models/
│   │   └── app_state.dart      # State management (Provider)
│   └── screens/
│       ├── home_screen.dart    # Halaman utama
│       ├── siswa_screen.dart   # Data siswa
│       ├── nilai_screen.dart   # Input nilai
│       ├── kalkulator_screen.dart  # Kalkulator
│       ├── soal_screen.dart    # Bank soal
│       ├── statistik_screen.dart   # Grafik statistik
│       └── rumus_screen.dart   # Referensi rumus
├── android/                    # Konfigurasi Android
└── pubspec.yaml                # Dependencies
```

---

## 📦 Dependencies

- `provider` — state management
- `fl_chart` — grafik bar & pie
- `math_expressions` — evaluasi ekspresi kalkulator
- `google_fonts` — font Poppins
- `uuid` — ID unik untuk data
- `shared_preferences` — penyimpanan lokal
- `intl` — format angka & tanggal

---

## 💡 Tips

- **Long press** kartu siswa untuk menghapus
- Di bank soal, tekan ikon 👁 untuk toggle tampilkan/sembunyikan jawaban
- Kalkulator mendukung: `+`, `-`, `×`, `÷`, `%`, desimal
- Grade otomatis: A(≥90), B(≥80), C(≥70), D(≥60), E(<60)

---

## 🎨 Tech Stack

- **Flutter 3.x** + Dart
- **Material Design 3**
- **Provider** untuk state management
- **fl_chart** untuk visualisasi data
