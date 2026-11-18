import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Tombol Tambah Proyek membuka form dan validasi berjalan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);

    // Navigasi ke form melalui tombol di halaman utama.
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);

    // Tutup SnackBar agar tidak menutupi tombol Save di viewport tes.
    tester
        .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
        .removeCurrentSnackBar();
    await tester.pumpAndSettle();

    // Menekan Save dengan field kosong memunculkan pesan validasi.
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);

    // Mengisi field wajib lalu Save memunculkan dialog berisi data.
    await tester.enterText(find.byType(TextFormField).at(0), 'Burhanpedia');
    await tester.enterText(find.byType(TextFormField).at(1), 'Ensiklopedia');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Nama Proyek: Burhanpedia'), findsOneWidget);
  });

  testWidgets('Drawer berisi navigasi Home dan Add Project', (
    WidgetTester tester,
  ) async {
    // Font tes (Ahem) jauh lebih lebar dari Roboto sehingga teks DrawerHeader
    // meluap di lingkungan tes; perkecil skala teks agar tata letak realistis.
    tester.platformDispatcher.textScaleFactorTestValue = 0.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);
  });
}
