import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('Halaman utama menampilkan sambutan', (tester) async {
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
  });

  testWidgets('Tambah Proyek saat belum login membuka LoginScreen', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();

    expect(find.text('Username'), findsWidgets);
    expect(find.text('Password'), findsWidgets);
  });
}
