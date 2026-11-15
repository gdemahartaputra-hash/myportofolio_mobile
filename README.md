# myportofolio_mobile

Aplikasi mobile Flutter untuk portofolio pribadi saya. Aplikasi ini adalah klien mobile dari proyek web Django `myportofolio` dan nantinya akan terhubung ke REST API (DRF) di `/api/v1/`.

**Pemilik:** Gde Maharta Putra Wicaksana Ridjasa - 2506549051 - PBP A

## Setup & Menjalankan

1. Pasang Flutter SDK (stable) dan pastikan `flutter doctor` tidak menunjukkan error pada Flutter & Chrome.
2. Clone repositori:
   ```bash
   git clone https://github.com/gdemahartaputra-hash/myportofolio_mobile.git
   cd myportofolio_mobile
   flutter pub get
   ```
3. Jalankan di Chrome: `flutter run -d chrome` (atau `flutter run` untuk emulator/perangkat Android).
4. Cek kualitas kode: `flutter analyze`.

## Progres Mingguan

| Minggu | Topik | Ringkasan |
|---|---|---|
| Tutorial 08 | Basic Flutter | Inisialisasi proyek, pemisahan `menu.dart`, `MyHomePage` Stateless, `InfoCard` & `ItemCard`, SnackBar |
| Tugas 7 | Basic Flutter | Identitas pribadi di InfoCard, warna unik tiap tombol lewat atribut `color` pada model `ItemHomepage` |

## Struktur Kode

- `lib/main.dart`: entry point (`main()`) dan `MyApp` (MaterialApp + tema).
- `lib/menu.dart`: halaman utama `MyHomePage`, widget `InfoCard`, model `ItemHomepage`, dan widget `ItemCard`.

## Pertanyaan Reflektif

### Tugas 7

1. **Widget tree dan hubungan parent-child.**

   Di Flutter, seluruh UI tersusun dari widget yang saling bersarang membentuk pohon (*widget tree*). Root-nya di aplikasi ini adalah `MyApp`, lalu `MaterialApp`, `MyHomePage`, `Scaffold`, dan seterusnya sampai widget daun seperti `Text` dan `Icon`. Parent menentukan posisi dan batas ukuran (*constraints*) anaknya. Anak menentukan ukurannya sendiri di dalam batas itu, lalu parent menempatkannya. Singkatnya: *constraints go down, sizes go up, parent sets position*. Parent juga meneruskan data ke anak lewat parameter konstruktor (misalnya `MyHomePage` memberikan `npm` ke `InfoCard`). Anak bisa membaca data dari leluhurnya lewat `BuildContext`, misalnya `Theme.of(context)`. Kalau parent di-rebuild, subtree di bawahnya ikut dievaluasi ulang.

2. **Widget yang digunakan dan fungsinya.**
   - `MaterialApp`: root aplikasi yang menyediakan tema, navigasi, dan gaya Material Design.
   - `Scaffold`: kerangka halaman (AppBar, body) dan tempat SnackBar ditampilkan.
   - `AppBar`: bar judul di bagian atas halaman.
   - `Text`: menampilkan teks.
   - `Padding`: memberi jarak di sekeliling child.
   - `Column` / `Row`: menyusun children secara vertikal / horizontal.
   - `Center`: menempatkan child di tengah.
   - `SizedBox`: memberi jarak dengan ukuran tetap.
   - `Card`: kotak dengan bayangan (elevation) untuk `InfoCard`.
   - `Container`: mengatur lebar dan padding isi kartu.
   - `GridView.count`: menampilkan tombol dalam kisi 3 kolom.
   - `Material`: memberi warna latar dan sudut membulat pada kartu tombol, sekaligus permukaan untuk efek ripple.
   - `InkWell`: mendeteksi tap dan menampilkan efek ripple.
   - `Icon`: menampilkan ikon tombol.
   - `SnackBar` (lewat `ScaffoldMessenger`): notifikasi singkat di bawah layar saat tombol ditekan.
   - Widget buatan sendiri: `MyApp`, `MyHomePage`, `InfoCard`, `ItemCard`. Semuanya `StatelessWidget`.

3. **Fungsi `MaterialApp` dan alasan dipakai sebagai root.**
   `MaterialApp` membungkus aplikasi dengan semua yang dibutuhkan widget Material: `Theme` (warna dan tipografi dari `ThemeData`), `Navigator` dan routing, `ScaffoldMessenger` (yang dibutuhkan SnackBar), `MediaQuery`, lokalisasi, arah teks, serta properti `title` dan `home`. Widget seperti `Scaffold`, `AppBar`, `Card`, dan `InkWell` membaca data-data ini dari leluhurnya lewat `BuildContext`. Karena itu `MaterialApp` harus berada di paling atas, supaya seluruh widget di bawahnya bisa mengakses tema dan layanan tersebut.

4. **`StatelessWidget` vs `StatefulWidget`.**
   `StatelessWidget` tidak punya state internal yang bisa berubah. Tampilannya hanya bergantung pada parameter konstruktor dan data dari context, dan ia hanya di-build ulang kalau parent-nya berubah. `StatefulWidget` dipasangkan dengan objek `State` yang bertahan selama widget hidup. Data di dalam `State` bisa diubah, dan memanggil `setState()` membuat widget di-build ulang. Pilih `StatelessWidget` untuk tampilan statis, seperti halaman menu ini yang hanya menampilkan identitas dan tombol. Pilih `StatefulWidget` kalau UI harus berubah akibat interaksi atau data, misalnya counter, form input, checkbox, animasi, atau data yang dimuat dari API.

5. **`BuildContext`.**
   `BuildContext` adalah penanda posisi sebuah widget di dalam widget tree (secara teknis, referensi ke `Element`-nya). Ini penting karena lewat context sebuah widget bisa mencari data dan layanan dari leluhurnya. Contoh di proyek ini:
   - `Theme.of(context).colorScheme.primary` untuk warna AppBar.
   - `MediaQuery.of(context).size.width` untuk lebar `InfoCard`.
   - `ScaffoldMessenger.of(context)` untuk menampilkan SnackBar.

   Method `build(BuildContext context)` menerima context milik widget itu sendiri. Context yang dipakai harus berada di bawah widget yang dicari. Misalnya, `ScaffoldMessenger.of(context)` hanya berhasil kalau context-nya ada di bawah `MaterialApp`.

6. **Hot reload vs hot restart.**
   *Hot reload* (`r`) menyuntikkan kode yang berubah ke Dart VM yang sedang berjalan, lalu menjalankan ulang `build()`. Hasilnya muncul dalam hitungan milidetik, dan state aplikasi tetap dipertahankan. *Hot restart* (`R`) memuat ulang seluruh kode dan memulai aplikasi dari `main()`, sehingga semua state kembali ke awal. Hot reload tidak cukup ketika:
   - Struktur kelas berubah, misalnya `StatefulWidget` menjadi `StatelessWidget`, atau konstruktor `const` menjadi non-const. Saya mengalami error *"Const class cannot become non-const ... Hot reload rejected"* saat mengubah `MyHomePage`.
   - Ada perubahan di `main()` atau `initState()`, karena keduanya tidak dijalankan ulang oleh hot reload.
   - Ada perubahan nilai awal variabel global atau static.
   - Ada perubahan enum atau tipe generic.

   *Full restart* (hentikan dengan `q` lalu jalankan `flutter run` lagi) diperlukan ketika ada perubahan kode native (Android/iOS), menambah package di `pubspec.yaml` yang punya plugin native, atau mengubah aset dan konfigurasi build.

## AI Disclosure

Dalam pengerjaan Individual Assignment 7, saya menggunakan **Claude Opus 5.5** sebagai AI assistant untuk membantu memahami struktur dan implementasi kode Flutter. Penggunaan AI difokuskan sebagai sarana pembelajaran, bukan sebagai pengganti proses pemahaman dan pengerjaan mandiri.

Secara spesifik, Claude Opus 5.5 saya gunakan untuk:

1. **Penjelasan Kode:** Meminta penjelasan mengenai setiap bagian kode, termasuk fungsi widget, atribut, parameter, serta hubungan antar-widget dalam struktur *widget tree*. Hal ini membantu saya memahami cara kerja kode sebelum mengimplementasikannya.
2. **Membimbing dalam Proses Implementasi:** Memahami cara menerapkan instruksi Tugas 7, seperti pemisahan kode ke dalam `main.dart` dan `menu.dart`, penggunaan `StatelessWidget`, pembuatan `InfoCard` dan `ItemCard`, serta penerapan warna dan `SnackBar` pada tombol aksi.
3. **Memahami Konsep Dasar:** Memperdalam pemahaman mengenai konsep dasar Flutter, terutama `MaterialApp`, `BuildContext`, perbedaan `StatelessWidget` dan `StatefulWidget`, serta mekanisme *hot reload* dan *hot restart*.

### Evaluasi dan Keterbatasan AI

Saya menyadari bahwa penjelasan dan saran yang diberikan AI tidak selalu dapat langsung diterapkan tanpa pemeriksaan lebih lanjut. AI dapat memberikan penjelasan yang kurang sesuai dengan konteks proyek, mengasumsikan struktur kode tertentu, atau menghasilkan solusi yang secara sintaksis benar tetapi belum tentu sesuai dengan kebutuhan tugas. Oleh karena itu, saya tidak menjadikan jawaban AI sebagai acuan mutlak.

### Verifikasi dan Perbaikan Mandiri

Untuk memastikan hasil implementasi sesuai dengan instruksi tugas, saya melakukan beberapa langkah secara mandiri:

- Mempelajari kembali penjelasan AI dan mencocokkannya dengan materi Tutorial 08 serta ketentuan Individual Assignment 7.
- Memahami fungsi setiap bagian kode sebelum menerapkannya ke dalam proyek, sehingga saya dapat mengetahui peran masing-masing widget dan atribut yang digunakan.
- Memeriksa kembali struktur kode dan memastikan pemisahan komponen antara `main.dart` dan `menu.dart` berjalan sesuai ketentuan.
- Menyesuaikan implementasi dengan kebutuhan portofolio pribadi, termasuk informasi identitas, nama tombol aksi, ikon, dan pemilihan warna masing-masing kartu.
- Melakukan pemeriksaan dan pengujian terhadap aplikasi untuk memastikan setiap tombol menampilkan pesan `SnackBar` yang sesuai dengan nama tombolnya.

Dengan demikian, Claude Opus 5.5 berperan sebagai pendamping pembelajaran yang membantu saya memahami kode dan proses implementasi. Keputusan akhir mengenai penerapan kode, penyesuaian kebutuhan proyek, serta evaluasi hasil tetap menjadi tanggung jawab saya sendiri.
