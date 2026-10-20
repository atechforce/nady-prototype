# NaDy Prototype

Prototype aplikasi pendamping kecemasan (anxiety) berbasis Flutter, dibuat untuk UTS Implementasi Perancangan Perangkat Lunak (IPPL).

> **Penting:** NaDy adalah prototype untuk keperluan akademik. Aplikasi ini **bukan alat diagnosis medis**. Skor kecemasan dan sesi monitoring adalah **simulasi**, bukan deteksi AI sungguhan.

- **Pembuat:** Dylan Sukma Yudha (11241027), Kelas A, Informatika, Institut Teknologi Kalimantan
- **Video presentasi:** https://youtu.be/hZiZB-Bnyp0?si=8CVKqm10iMoLsdMj
- **Repositori:** https://github.com/atechforce/nady-prototype
- **Dokumen acuan:** SRS NaDy dan SDD NaDy

---

## 1. Tujuan

NaDy dirancang untuk membantu penderita gangguan kecemasan: memberi edukasi, menyediakan chatbot pendamping, dan (pada rancangan penuh) memantau kondisi pengguna lalu memberi tahu orang terdekat saat kecemasan terdeteksi. Prototype ini mendemonstrasikan alur utamanya dengan data lokal dan simulasi.

## 2. Fitur dan status implementasi

| No | Fitur | Status | Keterangan | Acuan SRS |
|----|-------|--------|------------|-----------|
| 1 | Profil pengguna | Berfungsi (data lokal) | Lihat dan ubah nama, usia, email, riwayat kondisi. Ada validasi input. | Dari use case SDD, bukan FR SRS |
| 2 | Edukasi anxiety | Berfungsi | 5 materi: teknik napas, grounding, serangan panik, kapan ke profesional, cara mendampingi. | FR-04 |
| 3 | Chatbot | Demo | Jawaban berbasis kata kunci, bukan AI/LLM. Ada penanganan kata krisis (mengarahkan ke bantuan). | FR-05, FR-15 |
| 4 | Kontak darurat | Sebagian | Tambah, tampil, hapus, dengan validasi dan penolakan nomor ganda. Belum ada edit, prioritas, dan undangan verifikasi. | FR-02, FR-03 (sebagian) |
| 5 | Sesi monitoring | Simulasi | Mulai/akhiri sesi, timer batas versi gratis, skor acak, hitung mundur peringatan, tombol "Saya baik-baik saja", notifikasi simulasi ke kontak, ringkasan hasil. | FR-01, FR-07, FR-12, FR-13 (simulasi) |
| 6 | Uji notifikasi FCM | Eksperimen (branch `fcm-experiment`) | Menampilkan token perangkat dan menerima notifikasi dari Firebase Console. | Mengarah ke FR-13, FR-14 |

### Belum diimplementasikan

- FR-06 langganan premium dan pembayaran
- FR-08 sampai FR-11 analisis ekspresi wajah, nada bicara, kecepatan bicara, dan jeda napas (kamera dan mikrofon)
- FR-14 penerimaan dan respons notifikasi oleh kontak (hanya sebagian lewat uji FCM)
- Pemantauan latar belakang (background service)

## 3. Batasan prototype (jujur)

- Data profil, kontak, dan riwayat chat hanya disimpan di memori. **Semua hilang saat aplikasi ditutup.**
- Chatbot memakai pencocokan kata kunci lokal. Integrasi LLM (OpenAI/Gemini) sesuai SDD adalah tahap berikutnya.
- Sesi monitoring tidak memakai kamera, mikrofon, akselerometer, ataupun model AI. Skor dibuat acak.
- Untuk keperluan demo, batas 1 jam versi gratis dipercepat menjadi 120 detik, dan jeda 30 detik sebelum notifikasi menjadi 10 detik (konstanta di `lib/screens/monitoring_screen.dart`).
- Notifikasi ke kontak pada sesi monitoring hanya berupa catatan di layar (simulasi). Tidak ada SMS, WhatsApp, atau push yang terkirim otomatis.
- Uji FCM di branch `fcm-experiment` dipicu **manual** dari Firebase Console. Pemicu otomatis membutuhkan server yang menyimpan kunci Firebase (tahap setelah UTS).
- Belum ada login, backend, maupun database server.

## 4. Teknologi

- Flutter dan Dart
- Data lokal (in-memory)
- Firebase Cloud Messaging (hanya branch `fcm-experiment`)
- Git dan GitHub

## 5. Struktur folder

```
lib/
├── main.dart
├── app.dart
├── models/
│   ├── user_profile.dart
│   ├── education_material.dart
│   └── emergency_contact.dart
├── data/
│   ├── education_data.dart
│   └── chatbot_demo_data.dart
├── screens/
│   ├── dashboard_screen.dart
│   ├── profile_screen.dart
│   ├── education_screen.dart
│   ├── chatbot_screen.dart
│   ├── contacts_screen.dart
│   ├── monitoring_screen.dart
│   ├── placeholder_screen.dart
│   └── fcm_test_screen.dart      (hanya branch fcm-experiment)
└── widgets/
    └── feature_card.dart
```

## 6. Cara menjalankan dari awal

### 6.1 Prasyarat

- Flutter SDK (stable) dan Dart
- Android Studio dengan Android SDK
- Satu emulator Android (AVD) atau HP Android dengan USB debugging
- Git
- Windows: aktifkan **Developer Mode** (Settings, System, For developers) agar plugin dapat dibangun

Cek lingkungan:

```powershell
flutter doctor
```

### 6.2 Ambil kode

```powershell
git clone https://github.com/atechforce/nady-prototype.git
cd nady-prototype
flutter pub get
```

Branch `main` adalah **versi stabil** untuk UTS (tanpa Firebase). Cukup pakai `main` untuk mencoba kelima fitur.

### 6.3 Jalankan emulator

Buka PowerShell di folder project, lalu:

```powershell
# Hanya jika AVD disimpan di lokasi khusus (contoh: drive D)
$env:ANDROID_AVD_HOME = "D:\Android\avd"

flutter emulators
flutter emulators --launch Medium_Phone_API_37.0
```

Ganti `Medium_Phone_API_37.0` dengan ID yang tampil pada `flutter emulators`.

**Tunggu sampai home screen Android tampil penuh** (jam, ikon aplikasi, bilah pencarian). Perintah `--launch` langsung selesai tanpa menunggu booting, sehingga menjalankan `flutter run` terlalu cepat akan gagal.

### 6.4 Pastikan emulator terdeteksi, lalu jalankan

```powershell
flutter devices
flutter run -d emulator-5554
```

ID emulator bisa berbeda. Pakai ID yang tampil pada `flutter devices`.

Build pertama bisa memakan beberapa menit. Build berikutnya jauh lebih cepat.

### 6.5 Perintah berguna saat aplikasi berjalan

| Tombol | Fungsi |
|--------|--------|
| `r` | Hot reload |
| `R` | Hot restart (pakai ini setelah menambah file atau mengubah `main.dart`) |
| `q` | Keluar |

### 6.6 Alternatif tanpa emulator

```powershell
flutter run -d chrome
flutter run -d windows
```

Kode Dart sama. Ada kemungkinan tampilan sedikit berbeda dari Android.

### 6.7 Skenario uji (kelima fitur)

1. **Profil:** ubah nama lalu simpan. Kosongkan nama dan simpan, harus muncul pesan error. Buka ulang halaman, data harus tetap (selama aplikasi belum ditutup).
2. **Edukasi:** buka daftar 5 materi, ketuk salah satu untuk membuka detail.
3. **Chatbot:** ketik "napas", "panik", "cemas", lalu "halo" (jawaban default). Uji juga kata krisis untuk melihat respons yang mengarahkan ke bantuan.
4. **Kontak darurat:** tambah kontak, coba nomor sama dua kali (ditolak), hapus kontak (ada konfirmasi).
5. **Sesi monitoring:**
   1. Buka tanpa kontak: muncul pesan dan tombol tambah kontak.
   2. Tambah 1 kontak, kembali, tekan **Mulai sesi**.
   3. Tekan **Simulasikan lonjakan**, lalu **Saya baik-baik saja** (dicatat sebagai alarm palsu).
   4. Simulasikan lagi dan jangan dibatalkan, setelah 10 detik muncul catatan notifikasi simulasi.
   5. Tekan **Akhiri sesi** untuk melihat ringkasan, atau biarkan 120 detik sampai berhenti otomatis.

## 7. Membangun APK

```powershell
flutter build apk --release
```

Hasil: `build\app\outputs\flutter-apk\app-release.apk`

Untuk memasang di HP: izinkan "Install unknown apps" lalu buka file APK. Peringatan keamanan muncul karena aplikasi tidak dari Play Store, ini normal.

Versi debug (`--debug`) lebih besar dan lebih lambat, cukup untuk pengujian internal.

## 8. Uji notifikasi FCM (eksperimen)

Hanya tersedia di branch `fcm-experiment`.

```powershell
git checkout fcm-experiment
flutter pub get
```

1. Buat project di console.firebase.google.com, tambahkan aplikasi Android dengan package name `com.example.nady_prototype`.
2. Unduh `google-services.json` dan taruh di `android/app/`. File ini **tidak ikut repositori** (ada di `.gitignore`), sehingga setiap pengguna harus memakai project Firebase miliknya sendiri.
3. Jalankan aplikasi, ketuk ikon lonceng di dashboard, izinkan notifikasi, lalu salin token perangkat.
4. Di Firebase Console buka Messaging, buat campaign **Firebase Notification messages**, klik **Send test message**, tempel token, lalu **Test**.
5. Tutup aplikasi (atau tekan tombol home) sebelum menekan Test. Saat aplikasi terbuka di layar, pesan hanya tercatat di daftar "Pesan diterima" dan tidak muncul di status bar.

Untuk menguji dua perangkat (emulator sebagai pengguna, HP nyata sebagai orang terdekat), tempel kedua token pada kotak Send test message.

Kembali ke versi stabil:

```powershell
git checkout main
flutter clean
flutter pub get
```

## 9. Pemecahan masalah

Daftar berikut berasal dari kendala nyata selama pengembangan.

### 9.1 Emulator tidak muncul di `flutter devices`

| Gejala | Penyebab | Solusi |
|--------|----------|--------|
| `No supported devices found with name or id matching 'emulator-5554'` | Emulator belum selesai booting, atau belum dinyalakan | Tunggu home screen tampil penuh, lalu ulangi `flutter devices` |
| `Device emulator-5554 is offline` | Android masih booting | Tunggu 2 sampai 4 menit tanpa mengetik apa pun, lalu cek lagi |
| Tetap `offline` setelah 5 menit | Koneksi adb macet | Jalankan perintah di bawah |
| Jendela emulator tidak muncul sama sekali | Gagal menyala | Jalankan emulator langsung agar pesan error terlihat (di bawah) |

Reset adb:

```powershell
$adb = "C:\Users\<NAMA_USER>\AppData\Local\Android\Sdk\platform-tools\adb.exe"
& $adb kill-server
& $adb start-server
& $adb devices
```

Hasil yang benar: `emulator-5554   device`.

Jalankan emulator langsung (biarkan terminal tetap terbuka, pakai terminal kedua untuk Flutter):

```powershell
& "C:\Users\<NAMA_USER>\AppData\Local\Android\Sdk\emulator\emulator.exe" -avd Medium_Phone_API_37.0
```

### 9.2 Emulator gagal menyala karena ruang disk

Gejala: partisi data emulator butuh sekitar 12 GB, sedangkan drive C kurang.

Solusi yang sudah dipakai: pindahkan AVD ke drive lain.

1. Buat folder, misalnya `D:\Android\avd`.
2. Salin folder `.avd` dan file `.ini` dari `C:\Users\<NAMA_USER>\.android\avd` ke folder baru.
3. Perbarui path di file `.ini` agar menunjuk ke folder baru.
4. Set variabel lingkungan (wajib diulang di setiap terminal baru):

```powershell
$env:ANDROID_AVD_HOME = "D:\Android\avd"
```

### 9.3 Error saat build

| Pesan error | Penyebab | Solusi |
|-------------|----------|--------|
| `Package ndk not found` atau `sdkmanager did not install NDK` | NDK belum terpasang | Android Studio, SDK Manager, SDK Tools, centang **NDK (Side by side)** dan versi yang diminta, lalu Apply. Atau jalankan ulang `flutter run` karena sering terpasang otomatis |
| `Building with plugins requires symlink support` | Developer Mode Windows mati | `start ms-settings:developers`, nyalakan **Developer Mode**, lalu `flutter pub get` |
| `Could not close incremental caches` atau `Storage ... is already registered` (task `compileDebugKotlin`) | Cache build Kotlin rusak atau terkunci | Lihat 9.4 |
| Build pertama sangat lama (5 sampai 15 menit) | Gradle mengunduh dependensi | Normal, jangan dihentikan. Build berikutnya hanya hitungan detik |
| `WARNING: restricted method ...` atau `plugins that apply Kotlin Gradle Plugin` | Peringatan Java/Gradle | Aman diabaikan |

### 9.4 Cache Kotlin atau Gradle rusak

Urutan perbaikan, dari yang paling ringan:

```powershell
# 1. Coba jalankan perintah yang sama sekali lagi (percobaan kedua sering lolos)
flutter run -d emulator-5554

# 2. Hentikan daemon dan bersihkan build
cd android
.\gradlew --stop
cd ..
flutter clean
flutter pub get
flutter run -d emulator-5554
```

Jika masih gagal, tambahkan baris ini di akhir `android/gradle.properties`, lalu ulangi `flutter clean` dan `flutter run`:

```
kotlin.compiler.execution.strategy=in-process
```

Pastikan hanya satu proses `flutter run` yang aktif. Jika `flutter clean` gagal menghapus folder karena terkunci, tutup IDE sepenuhnya lalu ulangi.

### 9.5 Error kode Dart

| Pesan error | Penyebab | Solusi |
|-------------|----------|--------|
| `Couldn't find constructor 'NadyApp'` | `app.dart` kosong, belum tersimpan, atau nama class salah | Isi `app.dart` dengan class `NadyApp` lalu simpan |
| `Error when reading 'lib/models/....dart': The system cannot find the path specified` | Folder atau file belum dibuat, atau salah nama | Buat folder `models` dan `data`, pastikan nama file persis (huruf kecil, pakai garis bawah) |
| `Can't find '}' to match '{'` | File terpotong saat disalin | Hapus isi file, tempel ulang kode lengkap sampai kurung penutup terakhir |
| `Not a constant expression` pada `const NamaScreen()` | Class atau file layar bermasalah, atau konstruktor `const` tidak ada | Periksa file layar tersebut ada, namanya sama persis, dan memiliki `const NamaScreen({super.key});` |
| `Type 'X' not found` atau `Method not found: 'X'` | Import hilang atau file model bermasalah | Periksa baris `import` dan isi file model |

Setelah menambah file atau folder baru, gunakan **`R`** (hot restart). Jika terminal macet, tekan `q` lalu `flutter run` lagi.

### 9.6 Aplikasi berjalan tetapi bermasalah

| Gejala | Penyebab | Solusi |
|--------|----------|--------|
| Muncul `Flutter Demo Home Page` bukan dashboard NaDy | Aplikasi lama masih berjalan | Simpan semua file, tekan `R`, atau jalankan ulang `flutter run` |
| Terminal berhenti di `Performing hot reload...` | Aplikasi tidak tampil di layar (masuk background) | Buka aplikasi `nady_prototype` dari App Drawer emulator, lalu tekan `R` |
| `Lost connection to device` | Emulator tertutup atau kehabisan RAM | Nyalakan ulang emulator, tutup aplikasi berat lain, jalankan ulang |
| `Skipped N frames` pada log | Normal di emulator saat start pertama | Abaikan |
| Pop-up "Try out your stylus" muncul di kolom teks | Fitur stylus Gboard di emulator, bukan bagian aplikasi | Settings emulator, cari "stylus", matikan. Atau: `adb shell settings put secure stylus_handwriting_enabled 0` |
| `flutter test` error `MyApp` tidak ditemukan | `test/widget_test.dart` bawaan masih ada | Hapus atau sesuaikan file tersebut |

### 9.7 Masalah Git

| Gejala | Solusi |
|--------|--------|
| `fatal: not a git repository` | Anda berada di folder yang salah. Masuk ke folder project: `cd "<path>\nady_prototype"` |
| Ingin pindah branch tetapi ada perubahan belum di-commit | `git add .` lalu `git commit -m "pesan"`, atau simpan sementara dengan `git stash -u` |
| `google-services.json` ikut muncul di `git status` | Pastikan `.gitignore` memuat `android/app/google-services.json` dan sudah disimpan |
| Setelah ganti branch, aplikasi error atau ikon tidak sesuai | `flutter clean`, `flutter pub get`, lalu `flutter run` |

### 9.8 Masalah FCM

| Gejala | Penyebab | Solusi |
|--------|----------|--------|
| Ikon lonceng tidak ada | Berada di branch `main`, atau emulator menjalankan versi lama | `git checkout fcm-experiment`, lalu `flutter run` ulang |
| Token tidak muncul dan ada tulisan `Gagal: ...` | Firebase belum terinisialisasi | Pastikan `google-services.json` ada di `android/app/`, plugin Google Services ada di file Gradle, dan package name cocok |
| Token ada tetapi notifikasi tidak datang | Izin ditolak, mode hemat baterai, atau aplikasi sedang terbuka | Nyalakan izin notifikasi di pengaturan HP, tutup aplikasi sebelum menekan Test |
| Console menyatakan berhasil tetapi perangkat diam | Token salah salin atau sudah berubah | Salin ulang token utuh. Token berubah bila aplikasi dipasang ulang |
| HP tidak mendapat token | APK di HP bukan build dari branch FCM, atau tidak ada Google Play Services | Bangun ulang APK dari branch `fcm-experiment` |

## 10. Rencana pengembangan

1. Analisis ekspresi wajah, nada, kecepatan bicara, dan jeda napas on-device dengan TensorFlow Lite dan MediaPipe (FR-08 sampai FR-11).
2. Pemantauan di latar belakang (background service) dan penggabungan skor berbobot dengan baseline pengguna (FR-12).
3. Backend REST API dengan PostgreSQL, serta penyimpanan lokal SQLite.
4. Pengiriman notifikasi otomatis lewat FCM/APNs dari server dengan fallback SMS (FR-13, FR-14).
5. Undangan verifikasi, edit, dan prioritas kontak darurat (FR-03).
6. Chatbot berbasis LLM dengan penanganan krisis yang lebih lengkap (FR-05, FR-15).
7. Langganan premium dan pembayaran (FR-06).

## 11. Disclaimer

NaDy tidak menggantikan tenaga profesional. Jika Anda atau orang terdekat berada dalam situasi darurat atau memiliki pikiran untuk menyakiti diri sendiri, segera hubungi layanan darurat setempat atau tenaga kesehatan profesional.
