import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PenilaianPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onKirim;

  const PenilaianPage({super.key, required this.onKirim});

  @override
  State<PenilaianPage> createState() => _PenilaianPageState();
}

class _PenilaianPageState extends State<PenilaianPage> {
  final TextEditingController _hasilController = TextEditingController();
  File? _gambar;
  final ImagePicker _picker = ImagePicker();

  Future<void> _ambilGambar(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _gambar = File(pickedFile.path);
      });
    }
  }

  void _kirimPenilaian() {
    if (_hasilController.text.isEmpty || _gambar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Isi hasil dan pilih gambar terlebih dahulu!"),
        ),
      );
      return;
    }

    final data = {
      'hasil': _hasilController.text,
      'gambar': _gambar!.path,
      'tanggal': DateTime.now().toString().substring(0, 16),
    };

    widget.onKirim(data);

    setState(() {
      _hasilController.clear();
      _gambar = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Penilaian berhasil dikirim!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF8E6),
      appBar: AppBar(
        title: const Text("Penilaian Makanan"),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Bagaimana pendapatmu tentang makanan hari ini?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Gambar jika ada
                  _gambar != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _gambar!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.green, width: 1),
                          ),
                          child: const Icon(
                            Icons.fastfood_rounded,
                            color: Colors.green,
                            size: 50,
                          ),
                        ),

                  const SizedBox(height: 15),

                  // Tombol ambil gambar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _ambilGambar(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Kamera"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _ambilGambar(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Galeri"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Kolom komentar
                  TextField(
                    controller: _hasilController,
                    decoration: InputDecoration(
                      hintText: "Tulis komentar...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 20),

                  // Tombol kirim
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _kirimPenilaian,
                      icon: const Icon(Icons.send),
                      label: const Text(
                        "Kirim Penilaian",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
