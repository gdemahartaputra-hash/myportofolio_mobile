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

Dalam pengerjaan Individual Assignment 7, saya menggunakan **Claude Opus 5.5** sebagai AI assistant untuk membantu memahami struktur, fungsi, dan implementasi kode Flutter. Penggunaan AI difokuskan sebagai sarana pembelajaran agar saya dapat mengimplementasikan setiap instruksi tugas secara mandiri berdasarkan pemahaman terhadap kode yang digunakan.

### 1. Penggunaan AI

Claude Opus 5.5 digunakan untuk beberapa keperluan berikut:

- **Penjelasan Kode:** Meminta penjelasan secara bertahap mengenai setiap bagian kode, termasuk fungsi widget, atribut, parameter, konstruktor, serta hubungan parent-child dalam struktur widget tree.
- **Membimbing dalam Implementasi:** Memahami cara mengimplementasikan persyaratan Tugas 7, seperti pemisahan kode ke dalam `main.dart` dan `menu.dart`, penggunaan `StatelessWidget`, pembuatan `InfoCard` dan `ItemCard`, serta penerapan warna berbeda pada setiap tombol.
- **Pehamahman Konsep Dasar:** Memperdalam pemahaman mengenai konsep Flutter, khususnya `MaterialApp`, `BuildContext`, `StatelessWidget`, `StatefulWidget`, hot reload, dan hot restart.

### 2. Log Prompt dan Interaksi AI

Berikut merupakan ringkasan jenis prompt yang digunakan selama proses pengerjaan:

| No. | Fokus | Tujuan Prompt |
|---|---|---|
| 1 | Code Structure | Meminta Claude menjelaskan fungsi setiap bagian kode pada `main.dart` dan `menu.dart`, termasuk hubungan antar-widget. |
| 2 | Widget Implementation | Meminta penjelasan mengenai implementasi `InfoCard`, `ItemCard`, dan `ItemHomepage`, serta bagaimana ketiganya saling berhubungan. |
| 3 | StatelessWidget | Memahami alasan penggunaan `StatelessWidget` pada `MyHomePage` dan perbedaannya dengan `StatefulWidget`. |
| 4 | Customization | Memahami cara memberikan warna berbeda pada setiap `ItemCard` menggunakan atribut `Color color` pada model `ItemHomepage`. |
| 5 | Interaction | Memahami penggunaan `InkWell`, `ScaffoldMessenger`, dan `SnackBar` untuk memberikan respons ketika tombol ditekan. |
| 6 | Debugging | Meminta penjelasan mengenai perbedaan hot reload dan hot restart serta penyebab perubahan struktur kelas tidak dapat diterapkan melalui hot reload. |

### 3. Evaluasi Keterbatasan AI

Dalam proses pengerjaan, saya menyadari bahwa AI tidak selalu dapat memberikan solusi yang langsung sesuai dengan kondisi proyek.

Salah satu contoh nyata terjadi ketika saya mengubah `MyHomePage` dari struktur kelas yang menggunakan konstruktor `const` menjadi implementasi non-`const` sesuai kebutuhan proyek. Pada saat itu, hot reload mengalami kegagalan dengan pesan:

`Const class cannot become non-const ... Hot reload rejected`

Pengalaman tersebut menunjukkan bahwa meskipun AI dapat menjelaskan perubahan kode, AI tidak dapat menggantikan pemahaman mengenai kondisi aplikasi yang sedang berjalan. Saya perlu memahami bahwa perubahan tertentu membutuhkan hot restart, bukan sekadar hot reload.

Selain itu, penjelasan AI terkadang terlalu berfokus pada konsep umum tanpa langsung mempertimbangkan struktur proyek yang sedang dikerjakan. Oleh karena itu, setiap penjelasan perlu dicocokkan kembali dengan kode aktual dan instruksi tugas agar implementasinya tidak menyimpang.

### 4. Verifikasi dan Perbaikan Mandiri

Untuk memastikan hasil pengerjaan sesuai dengan kebutuhan tugas, saya melakukan penyesuaian dan pemeriksaan terhadap implementasi yang dihasilkan.

Beberapa penyesuaian yang diterapkan meliputi:

- Mengganti data contoh dengan identitas pribadi, yaitu NPM, nama lengkap, dan kelas PBP.
- Menyesuaikan ikon, nama, serta warna setiap tombol agar sesuai dengan fungsi masing-masing.
- Menggunakan atribut `color` pada model `ItemHomepage` sehingga setiap kartu dapat memiliki warna masing-masing tanpa membutuhkan percabangan `if-else` berulang.
- Menambahkan komentar penjelas pada bagian-bagian penting kode untuk memperjelas fungsi widget dan implementasinya.
- Memastikan pesan `SnackBar` menyesuaikan nama tombol yang ditekan serta menyembunyikan notifikasi sebelumnya sebelum menampilkan notifikasi baru.

### 5. Fitur dan Penyempurnaan Tambahan

Selain memenuhi checklist tugas, saya menambahkan beberapa penyempurnaan berikut tanpa mengubah struktur proyek dari Tutorial 08:

- **SnackBar berwarna sesuai tombol:** `SnackBar` menggunakan `backgroundColor: item.color`, sehingga warna notifikasi sama dengan warna tombol yang ditekan. Fitur ini memanfaatkan atribut `color` pada model `ItemHomepage` yang sudah ada, tanpa logika tambahan.
- **SnackBar melayang (floating):** `SnackBar` ditampilkan dengan `behavior: SnackBarBehavior.floating`, sehingga muncul sebagai kartu melayang di atas konten, bukan bar penuh di bagian bawah layar.
- **Palet warna yang serasi dengan tema:** Warna tombol menggunakan shade Material (`Colors.indigo.shade600`, `Colors.teal.shade600`, `Colors.deepOrange.shade700`). Ketiganya kontras satu sama lain, selaras dengan tema `seedColor: Colors.indigo`, dan tetap terbaca dengan ikon serta teks berwarna putih. Merah-oranye dipakai untuk Logout karena umum digunakan sebagai penanda aksi keluar.
- **Docstring pada setiap kelas:** Kelas `MyHomePage`, `InfoCard`, `ItemHomepage`, dan `ItemCard` di `menu.dart` diberi docstring Dart (`///`) yang menjelaskan peran masing-masing, termasuk alasan warna disimpan di model.
- **Komentar kode diperbarui:** Komentar pada `ItemCard` diperbaiki agar sesuai dengan implementasi terbaru (warna diambil dari `item.color`, bukan lagi dari warna sekunder tema).

### 6. Kesimpulan

Penggunaan Claude Opus 5.5 membantu saya memahami implementasi Flutter secara lebih mendalam, khususnya dalam memahami fungsi setiap bagian kode sebelum menerapkannya. Namun, saya menyadari bahwa AI memiliki keterbatasan dalam memahami konteks proyek secara keseluruhan dan tidak selalu dapat menentukan tindakan yang tepat berdasarkan kondisi aplikasi yang sedang berjalan.
