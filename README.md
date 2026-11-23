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
| Tutorial 09 | Navigation, Layouts, Forms | `LeftDrawer`, form Tambah Proyek dengan validasi dan dialog, navigasi tombol, refactor ke `screens/` dan `widgets/` |
| Tugas 8 | Navigation, Layouts, Forms | Form Edukasi sesuai model `Education` dengan validasi (wajib diisi, batas panjang, rentang dan urutan tahun, format URL), kartu aksi dan opsi drawer baru |

## Struktur Kode

- `lib/main.dart`: entry point (`main()`) dan `MyApp` (MaterialApp + tema).
- `lib/screens/menu.dart`: halaman utama `MyHomePage`, widget `InfoCard`, dan model `ItemHomepage`.
- `lib/screens/project_form.dart`: form Tambah Proyek (Tutorial 09).
- `lib/screens/education_form.dart`: form Tambah Edukasi (Tugas 8).
- `lib/widgets/left_drawer.dart`: drawer navigasi (Home, Add Project, Add Education) yang dipakai di semua halaman.
- `lib/widgets/project_card.dart`: kartu aksi `ItemCard` beserta navigasinya.

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

### Tugas 7
Dalam pengerjaan Individual Assignment 7, saya menggunakan **Claude Opus 5.5** sebagai AI assistant untuk membantu memahami struktur, fungsi, dan implementasi kode Flutter. Penggunaan AI difokuskan sebagai sarana pembelajaran agar saya dapat mengimplementasikan setiap instruksi tugas secara mandiri berdasarkan pemahaman terhadap kode yang digunakan.

#### 1. Penggunaan AI

Claude Opus 5.5 digunakan untuk beberapa keperluan berikut:

- **Penjelasan Kode:** Meminta penjelasan secara bertahap mengenai setiap bagian kode, termasuk fungsi widget, atribut, parameter, konstruktor, serta hubungan parent-child dalam struktur widget tree.
- **Membimbing dalam Implementasi:** Memahami cara mengimplementasikan persyaratan Tugas 7, seperti pemisahan kode ke dalam `main.dart` dan `menu.dart`, penggunaan `StatelessWidget`, pembuatan `InfoCard` dan `ItemCard`, serta penerapan warna berbeda pada setiap tombol.
- **Pemahaman Konsep Dasar:** Memperdalam pemahaman mengenai konsep Flutter, khususnya `MaterialApp`, `BuildContext`, `StatelessWidget`, `StatefulWidget`, hot reload, dan hot restart.

#### 2. Log Prompt dan Interaksi AI

Berikut merupakan ringkasan jenis prompt yang digunakan selama proses pengerjaan:

| No. | Fokus | Tujuan Prompt |
|---|---|---|
| 1 | Code Structure | Meminta Claude menjelaskan fungsi setiap bagian kode pada `main.dart` dan `menu.dart`, termasuk hubungan antar-widget. |
| 2 | Widget Implementation | Meminta penjelasan mengenai implementasi `InfoCard`, `ItemCard`, dan `ItemHomepage`, serta bagaimana ketiganya saling berhubungan. |
| 3 | StatelessWidget | Memahami alasan penggunaan `StatelessWidget` pada `MyHomePage` dan perbedaannya dengan `StatefulWidget`. |
| 4 | Customization | Memahami cara memberikan warna berbeda pada setiap `ItemCard` menggunakan atribut `Color color` pada model `ItemHomepage`. |
| 5 | Interaction | Memahami penggunaan `InkWell`, `ScaffoldMessenger`, dan `SnackBar` untuk memberikan respons ketika tombol ditekan. |
| 6 | Debugging | Meminta penjelasan mengenai perbedaan hot reload dan hot restart serta penyebab perubahan struktur kelas tidak dapat diterapkan melalui hot reload. |

#### 3. Evaluasi Keterbatasan AI

Selama pengerjaan, saya menemukan bahwa AI tidak selalu benar dan tidak selalu sesuai dengan batasan tugas. Berikut kesalahan dan keterbatasan nyata yang saya temui, beserta cara saya menanganinya:

- **Verifikasi yang tidak lengkap.** Saat saya meminta pemeriksaan hasil Tutorial 08, AI menyatakan pekerjaan "sudah benar dan siap dikumpulkan" hanya berdasarkan `flutter analyze`. AI tidak memeriksa `test/widget_test.dart` bawaan `flutter create`, yang ternyata gagal karena masih menguji counter yang sudah dihapus. Hal ini baru ketahuan pada pemeriksaan berikutnya. Dari sini saya belajar bahwa "tidak ada error" pada analisis statis belum tentu berarti seluruh proyek sudah diperiksa.

- **Penilaian yang melebihi isi rubrik.** Setelah menemukan test yang gagal, AI justru menganggapnya sebagai hal yang "harus diperbaiki" dan menurunkan perkiraan nilai kualitas kode. Padahal, `flutter test` tidak diminta di Tutorial 08 maupun Tugas 7. Saya mengoreksi hal ini, dan AI mengakui bahwa itu adalah asumsinya sendiri, bukan isi rubrik. Sejak itu, setiap saran AI saya cocokkan langsung dengan teks rubrik dan checklist pada dokumen tugas.

- **Saran yang terlalu jauh dari tutorial.** Ketika saya meminta saran untuk mencapai nilai maksimal, AI mengusulkan memecah `menu.dart` ke folder `models/` dan `widgets/`, mengganti body dengan `SingleChildScrollView`, dan menambahkan `IntrinsicHeight`. Perubahan tersebut mengubah struktur yang diajarkan di Tutorial 08. Saya menolaknya dan memilih perubahan minimal (docstring dan SnackBar berwarna), karena rubrik nilai 4 menggunakan kata "atau" sehingga cukup dipenuhi salah satu kriterianya.

- **Instruksi yang tidak konsisten.** Setelah rencana diubah menjadi perubahan minimal tanpa banyak branch, AI masih menyarankan perintah `git push origin main` beserta nama-nama branch yang tidak pernah saya buat. Perintah tersebut akan gagal jika dijalankan apa adanya. Saya menanyakan alasannya dan akhirnya cukup menggunakan `git push origin main`.

- **AI tidak melihat kondisi aplikasi yang sedang berjalan.** Saat mengubah `MyHomePage` dari konstruktor `const` menjadi non-`const`, hot reload gagal dengan pesan `Const class cannot become non-const ... Hot reload rejected`. AI baru bisa menjelaskan penyebabnya setelah saya mengirimkan tangkapan layar terminal. Ini menunjukkan bahwa AI bergantung pada informasi yang saya berikan, sehingga saya tetap harus mengamati sendiri perilaku aplikasi.

- **Keterbatasan lingkungan kerja.** AI tidak dapat memastikan repositori GitHub bersifat publik karena GitHub CLI (`gh`) tidak terpasang di komputer saya, sehingga saya memeriksanya secara manual melalui jendela incognito.

Secara keseluruhan, AI paling berguna untuk menjelaskan konsep dan memberi arah. Namun, keputusan tentang apa yang benar-benar diminta tugas, seberapa jauh perubahan boleh dilakukan, dan apakah aplikasi sudah berjalan dengan benar tetap harus saya verifikasi sendiri.

#### 4. Verifikasi dan Perbaikan Mandiri

Untuk memastikan hasil pengerjaan sesuai dengan kebutuhan tugas, saya melakukan penyesuaian dan pemeriksaan terhadap implementasi yang dihasilkan.

Beberapa penyesuaian yang diterapkan meliputi:

- Mengganti data contoh dengan identitas pribadi, yaitu NPM, nama lengkap, dan kelas PBP.
- Menyesuaikan ikon, nama, serta warna setiap tombol agar sesuai dengan fungsi masing-masing.
- Menggunakan atribut `color` pada model `ItemHomepage` sehingga setiap kartu dapat memiliki warna masing-masing tanpa membutuhkan percabangan `if-else` berulang.
- Menambahkan komentar penjelas pada bagian-bagian penting kode untuk memperjelas fungsi widget dan implementasinya.
- Memastikan pesan `SnackBar` menyesuaikan nama tombol yang ditekan serta menyembunyikan notifikasi sebelumnya sebelum menampilkan notifikasi baru.

#### 5. Fitur dan Penyempurnaan Tambahan

Selain memenuhi checklist tugas, saya menambahkan beberapa penyempurnaan berikut tanpa mengubah struktur proyek dari Tutorial 08:

- **SnackBar berwarna sesuai tombol:** `SnackBar` menggunakan `backgroundColor: item.color`, sehingga warna notifikasi sama dengan warna tombol yang ditekan. Fitur ini memanfaatkan atribut `color` pada model `ItemHomepage` yang sudah ada, tanpa logika tambahan.
- **SnackBar melayang (floating):** `SnackBar` ditampilkan dengan `behavior: SnackBarBehavior.floating`, sehingga muncul sebagai kartu melayang di atas konten, bukan bar penuh di bagian bawah layar.
- **Palet warna yang serasi dengan tema:** Warna tombol menggunakan shade Material (`Colors.indigo.shade600`, `Colors.teal.shade600`, `Colors.deepOrange.shade700`). Ketiganya kontras satu sama lain, selaras dengan tema `seedColor: Colors.indigo`, dan tetap terbaca dengan ikon serta teks berwarna putih. Merah-oranye dipakai untuk Logout karena umum digunakan sebagai penanda aksi keluar.
- **Docstring pada setiap kelas:** Kelas `MyHomePage`, `InfoCard`, `ItemHomepage`, dan `ItemCard` di `menu.dart` diberi docstring Dart (`///`) yang menjelaskan peran masing-masing, termasuk alasan warna disimpan di model.
- **Komentar kode diperbarui:** Komentar pada `ItemCard` diperbaiki agar sesuai dengan implementasi terbaru (warna diambil dari `item.color`, bukan lagi dari warna sekunder tema).

#### 6. Kesimpulan

Penggunaan Claude Opus 5.5 membantu saya memahami implementasi Flutter secara lebih mendalam, khususnya dalam memahami fungsi setiap bagian kode sebelum menerapkannya. Namun, saya menyadari bahwa AI memiliki keterbatasan dalam memahami konteks proyek secara keseluruhan dan tidak selalu dapat menentukan tindakan yang tepat berdasarkan kondisi aplikasi yang sedang berjalan.

### Tugas 8

Dalam pengerjaan Individual Assignment 8, saya menggunakan **Claude Opus 5.5** sebagai AI assistant untuk membantu memahami, merancang, dan memeriksa implementasi navigasi, layout, serta formulir pada aplikasi Flutter. Penggunaan AI dilakukan dengan pendekatan *AI-assisted development*, yaitu menjadikan AI sebagai pendamping pembelajaran dan pemberi arahan teknis, sementara keputusan implementasi, penyesuaian kode, dan verifikasi hasil tetap saya lakukan secara mandiri.

#### 1. Penggunaan AI

Claude Opus 5.5 digunakan sebagai pendamping selama proses pengerjaan Tugas 8, khususnya dalam beberapa aspek berikut:

- **Analisis Persyaratan Tugas:** Meminta Claude membantu menguraikan checklist Tugas 8 menjadi langkah-langkah implementasi yang lebih terstruktur, serta mengidentifikasi hubungan antara materi Tutorial 09 dengan pengembangan aplikasi yang sudah dibuat pada Tugas 7.
- **Implementasi Formulir:** Memahami cara membuat halaman `EducationFormPage` menggunakan `StatefulWidget`, `Form`, dan `GlobalKey<FormState>`. AI juga membantu menjelaskan penggunaan berbagai widget input, seperti `TextFormField` dan `DropdownButtonFormField`.
- **Validasi Input:** Memahami cara menerapkan validator untuk setiap field berdasarkan karakteristik data pendidikan, seperti kewajiban pengisian, batas maksimal karakter, validasi tahun, urutan tahun mulai dan selesai, serta format URL thumbnail.
- **Implementasi Navigasi:** Memahami perbedaan penggunaan `Navigator.push()` dan `Navigator.pushReplacement()` dalam menghubungkan halaman utama, formulir, dan drawer.
- **Integrasi Komponen:** Meminta bantuan untuk memahami cara menghubungkan halaman formulir baru dengan `ItemCard` dan `LeftDrawer` tanpa menghilangkan fungsionalitas yang sudah dibuat pada Tugas 7 dan Tutorial 09.
- **Debugging dan Code Review:** Meminta Claude memeriksa struktur kode, konsistensi implementasi, kemungkinan kesalahan validasi, serta kesesuaian hasil pengerjaan dengan instruksi dan rubrik penilaian.

#### 2. Log Prompt dan Interaksi AI

Berikut merupakan ringkasan jenis prompt yang digunakan selama proses pengerjaan Tugas 8. Ringkasan ini menggambarkan fokus interaksi dengan Claude Opus 5.5, bukan transkrip verbatim seluruh percakapan.

| No. | Fokus | Tujuan Prompt |
|---|---|---|
| 1 | Task Analysis | Meminta Claude menganalisis instruksi Tugas 8 dan mengidentifikasi bagian-bagian yang perlu ditambahkan pada proyek Flutter dari Tugas 7. |
| 2 | Form Structure | Meminta penjelasan mengenai struktur `StatefulWidget`, `Form`, `GlobalKey<FormState>`, dan cara mengimplementasikannya pada halaman formulir edukasi. |
| 3 | Input Elements | Memahami pemilihan widget input yang sesuai untuk setiap atribut pendidikan, termasuk penggunaan `TextFormField` dan `DropdownButtonFormField`. |
| 4 | Input Validation | Meminta penjelasan dan arahan implementasi validator untuk input wajib, batas karakter, tahun mulai, tahun selesai, serta URL thumbnail. |
| 5 | Navigation | Memahami penggunaan `Navigator.push()` untuk membuka formulir melalui kartu aksi dan `Navigator.pushReplacement()` untuk navigasi melalui drawer. |
| 6 | Widget Integration | Meminta bantuan mengintegrasikan halaman `EducationFormPage` dengan `ItemCard` dan `LeftDrawer`, sekaligus mempertahankan fitur dari tugas sebelumnya. |
| 7 | Dialog Implementation | Memahami cara menggunakan `FormState.validate()`, `showDialog()`, dan `AlertDialog` untuk menampilkan ringkasan isian setelah validasi berhasil. |
| 8 | Code Review | Meminta Claude memeriksa implementasi akhir berdasarkan checklist tugas, keterbacaan kode, dan kemungkinan kesalahan pada alur navigasi maupun validasi. |

#### 3. Evaluasi Keterbatasan AI

Selama menggunakan Claude Opus 5.5, saya menyadari bahwa AI dapat memberikan arahan teknis yang membantu, tetapi hasilnya tetap membutuhkan pemahaman konteks dan pemeriksaan secara mandiri. Beberapa keterbatasan yang perlu diperhatikan dalam pengerjaan ini adalah:

- **Pemilihan jenis input tidak menjamin validitas data.** Penggunaan `keyboardType: TextInputType.number` pada field tahun memang membantu menampilkan papan ketik numerik. Namun, hal tersebut tidak menjamin bahwa pengguna hanya memasukkan angka. Oleh karena itu, saya tetap menerapkan `int.tryParse()` di dalam validator untuk memastikan input benar-benar dapat dikonversi menjadi integer. Hal ini menunjukkan bahwa saran penggunaan widget input saja belum cukup untuk menjamin validitas data.

- **Validasi harus mempertimbangkan hubungan antar-field.** Validasi setiap kolom secara terpisah tidak cukup untuk memastikan data pendidikan konsisten. Sebagai contoh, tahun selesai tidak boleh lebih awal daripada tahun mulai. Karena itu, validator pada field tahun selesai juga perlu membaca nilai `_startedYear` agar dapat memeriksa hubungan kedua input tersebut.

- **AI perlu memahami karakteristik model data.** Field Nilai/IPK tidak selalu berbentuk angka karena pengguna dapat memasukkan nilai berupa angka seperti `3.85` maupun huruf seperti `A`. Oleh sebab itu, penggunaan validasi numerik secara langsung justru dapat menolak data yang sebenarnya diperbolehkan. Saya mempertahankan input berbentuk teks dengan batas maksimal 100 karakter agar lebih sesuai dengan variasi nilai yang dapat digunakan.

- **Perbedaan kebutuhan navigasi.** `Navigator.push()` dan `Navigator.pushReplacement()` sama-sama dapat membuka halaman baru, tetapi memiliki dampak berbeda terhadap navigation stack. Penggunaan keduanya tidak boleh disamakan. Pada implementasi ini, `Navigator.push()` digunakan pada kartu aksi agar pengguna dapat kembali menggunakan tombol Back, sedangkan `Navigator.pushReplacement()` digunakan pada drawer agar halaman sebelumnya digantikan ketika berpindah menu.

- **Pemeriksaan kode tidak sama dengan pengujian fungsional.** AI dapat membantu memeriksa struktur dan kemungkinan kesalahan pada kode, tetapi tidak dapat menjadikan analisis kode sebagai bukti bahwa seluruh interaksi aplikasi sudah berjalan sesuai harapan. Navigasi dari kartu dan drawer, validasi input tidak valid, serta tampilan dialog setelah input valid tetap perlu diuji secara langsung.

Dari keterbatasan tersebut, saya memahami bahwa AI sebaiknya digunakan untuk membantu mempercepat proses pemahaman dan implementasi, bukan sebagai satu-satunya sumber kebenaran. Setiap saran tetap harus disesuaikan dengan model data, instruksi tugas, dan perilaku aplikasi yang sebenarnya.

#### 4. Verifikasi dan Perbaikan Mandiri

Setelah memperoleh arahan dari Claude Opus 5.5, saya melakukan penyesuaian terhadap implementasi agar sesuai dengan kebutuhan aplikasi dan karakteristik data pendidikan.

Beberapa implementasi dan penyesuaian yang dilakukan meliputi:

- Membuat halaman `EducationFormPage` dalam file Dart tersendiri pada direktori `lib/screens/`, menggunakan `StatefulWidget` dan `GlobalKey<FormState>`.
- Menyesuaikan field formulir dengan atribut model `Education`, yaitu nama institusi, jurusan, nilai/IPK, jenjang pendidikan, tahun mulai, tahun selesai, dan thumbnail.
- Menerapkan validasi `trim().isEmpty` agar input yang hanya berisi spasi tetap dianggap tidak valid.
- Menambahkan batas maksimal 255 karakter untuk nama institusi dan jurusan, serta 100 karakter untuk nilai/IPK.
- Memastikan tahun mulai berada dalam rentang 1950 hingga tahun saat ini, serta tahun selesai tidak lebih awal daripada tahun mulai.
- Membuat field tahun selesai dan thumbnail bersifat opsional sesuai karakteristik datanya.
- Memvalidasi URL thumbnail agar hanya menerima alamat dengan skema HTTP atau HTTPS dan host yang valid.
- Mengintegrasikan halaman edukasi ke dalam `ItemCard` dan `LeftDrawer` tanpa menghilangkan menu Home dan Add Project.
- Memastikan ringkasan data hanya ditampilkan melalui `AlertDialog` setelah seluruh input berhasil melewati validasi.

Saya juga mempertahankan struktur proyek dari tugas sebelumnya dengan memisahkan halaman ke dalam direktori `screens/` dan komponen yang digunakan kembali ke dalam direktori `widgets/`.

#### 5. Fitur dan Penyempurnaan Tambahan

Selain implementasi utama yang diminta dalam checklist, terdapat beberapa penyempurnaan pada formulir dan navigasi aplikasi:

- **Validasi rentang tahun dinamis:** Batas maksimal tahun mulai menggunakan `DateTime.now().year`, sehingga batas validasi mengikuti tahun saat aplikasi dijalankan dan tidak perlu diperbarui secara manual.
- **Field opsional yang kontekstual:** Tahun selesai dapat dikosongkan untuk menunjukkan bahwa pendidikan masih berlangsung. Pada dialog ringkasan, kondisi tersebut ditampilkan sebagai "Sekarang".
- **Validasi URL thumbnail:** Pengguna dapat menambahkan gambar thumbnail melalui URL. Sistem memeriksa skema HTTP/HTTPS, keberadaan host, dan batas maksimal panjang URL sebelum menerima input.
- **Pilihan jenjang pendidikan:** Menggunakan `DropdownButtonFormField` dengan beberapa pilihan, yaitu Master's Degree, Bachelor's Degree, Senior High School, Junior High School, dan Elementary School.
- **Navigasi drawer yang terintegrasi:** Opsi Add Education ditambahkan ke drawer yang sama dengan halaman utama dan formulir proyek, sehingga pengguna memperoleh pengalaman navigasi yang konsisten.
- **Layout formulir yang dapat digulir:** Penggunaan `SingleChildScrollView` memungkinkan seluruh field dan tombol Simpan tetap dapat dijangkau ketika konten lebih panjang daripada ruang layar yang tersedia.

#### 6. Kesimpulan

Penggunaan Claude Opus 5.5 dalam pengerjaan Tugas 8 membantu saya memahami penerapan navigasi, pengelolaan formulir, validasi input, dan integrasi antar-widget dalam Flutter. Saya belajar bahwa pembuatan formulir bukan hanya tentang menampilkan kolom input, tetapi juga memastikan bahwa data yang diterima memenuhi aturan dan memiliki hubungan yang konsisten satu sama lain.

Melalui proses ini, saya semakin memahami pentingnya memeriksa setiap saran AI berdasarkan kebutuhan aplikasi dan instruksi tugas. AI membantu memberikan arahan serta mempercepat proses pembelajaran, tetapi tanggung jawab untuk menentukan implementasi yang tepat, melakukan penyesuaian, dan memastikan aplikasi berjalan dengan baik tetap berada pada saya.
