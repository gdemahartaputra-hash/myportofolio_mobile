import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambahkan riwayat pendidikan.
///
/// Field mengikuti model Django `Education`: `school_name`, `major`, `grade`,
/// `category`, `started_year`, `ended_year` (opsional), dan `thumbnail`
/// (opsional).
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _schoolName = "";
  String _major = "";
  String _grade = "";
  String _category = "Bachelor's Degree"; // default
  String _startedYear = "";
  String _endedYear = "";
  String _thumbnail = "";

  final List<String> _categories = [
    "Master's Degree",
    "Bachelor's Degree",
    'Senior High School',
    'Junior High School',
    'Elementary School',
  ];

  // Tahun saat ini, dipakai untuk membatasi rentang tahun yang valid.
  final int _currentYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Education Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Nama Institusi (school_name, max 255) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Universitas Indonesia",
                    labelText: "Nama Institusi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _schoolName = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama institusi tidak boleh kosong!";
                    }
                    if (value.trim().length > 255) {
                      return "Nama institusi maksimal 255 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Jurusan (major, max 255) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Ilmu Komputer",
                    labelText: "Jurusan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _major = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Jurusan tidak boleh kosong!";
                    }
                    if (value.trim().length > 255) {
                      return "Jurusan maksimal 255 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Nilai/IPK (grade, max 100) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: 3.85 atau A",
                    labelText: "Nilai/IPK",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _grade = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nilai/IPK tidak boleh kosong!";
                    }
                    if (value.trim().length > 100) {
                      return "Nilai/IPK maksimal 100 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Jenjang Pendidikan (category) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Jenjang Pendidikan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),

              // === Tahun Mulai (started_year) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Contoh: 2025",
                    labelText: "Tahun Mulai",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _startedYear = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Tahun mulai tidak boleh kosong!";
                    }
                    final year = int.tryParse(value.trim());
                    if (year == null) {
                      return "Tahun mulai harus berupa angka!";
                    }
                    if (year < 1950 || year > _currentYear) {
                      return "Tahun mulai harus antara 1950 dan $_currentYear!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tahun Selesai (ended_year, opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Kosongkan jika masih berlangsung",
                    labelText: "Tahun Selesai (opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _endedYear = value!;
                    });
                  },
                  validator: (String? value) {
                    // Opsional: kosong berarti pendidikan masih berlangsung.
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    final year = int.tryParse(value.trim());
                    if (year == null) {
                      return "Tahun selesai harus berupa angka!";
                    }
                    final startYear = int.tryParse(_startedYear.trim());
                    if (startYear != null && year < startYear) {
                      return "Tahun selesai tidak boleh sebelum tahun mulai!";
                    }
                    if (year > _currentYear + 10) {
                      return "Tahun selesai maksimal ${_currentYear + 10}!";
                    }
                    return null;
                  },
                ),
              ),

              // === URL Thumbnail (thumbnail, opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "URL Thumbnail (opsional)",
                    labelText: "Thumbnail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _thumbnail = value!;
                    });
                  },
                  validator: (String? value) {
                    // Opsional: boleh kosong.
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    if (value.trim().length > 200) {
                      return "URL maksimal 200 karakter!";
                    }
                    final uri = Uri.tryParse(value.trim());
                    if (uri == null ||
                        !(uri.scheme == 'http' || uri.scheme == 'https') ||
                        uri.host.isEmpty) {
                      return "URL harus diawali http:// atau https://";
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Edukasi berhasil disimpan!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama Institusi: $_schoolName'),
                                    Text('Jurusan: $_major'),
                                    Text('Nilai/IPK: $_grade'),
                                    Text('Jenjang: $_category'),
                                    Text(
                                      'Tahun: $_startedYear - '
                                      '${_endedYear.trim().isEmpty ? "Sekarang" : _endedYear}',
                                    ),
                                    Text('Thumbnail: $_thumbnail'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
