import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';

import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Kartu tombol aksi berikon dengan warna latar dari [ItemHomepage.color].
///
/// Saat ditekan, menampilkan SnackBar berisi nama tombol. Khusus tombol
/// "Tambah Proyek", kartu juga membuka [ProjectFormPage] dengan
/// [Navigator.push] sehingga pengguna dapat kembali dengan tombol Back.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Warna latar unik per tombol, diambil dari model ItemHomepage.
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // Area responsif terhadap sentuhan
        onTap: () async {
          final messenger = ScaffoldMessenger.of(context);
          void showMessage(String text) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(text),
                  backgroundColor: item.color,
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }

          switch (item.name) {
            case 'Lihat Proyek':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectListScreen(),
                ),
              );
            case 'Tambah Proyek':
              if (!await ensureLoggedIn(context)) return;
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectFormPage(),
                ),
              );
            case 'Tambah Edukasi':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EducationFormPage(),
                ),
              );
            case 'Logout':
              final auth = context.read<AuthState>();
              if (!auth.isLoggedIn) {
                showMessage('Kamu belum login.');
                return;
              }
              await auth.logout();
              showMessage('Berhasil logout.');
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
