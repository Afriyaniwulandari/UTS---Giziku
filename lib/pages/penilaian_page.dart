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
  final TextEditingController _penilaianController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  double? _rating;

  // Ambil gambar dari kamera
  Future<void> _ambilDariKamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  // Ambil gambar dari galeri
  Future<void> _ambilDariGaleri() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  // Kirim penilaian
  void _kirimPenilaian() {
    if (_penilaianController.text.isEmpty || _rating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi penilaian dan beri rating!')),
      );
      return;
    }

    widget.onKirim({
      'komentar': _penilaianController.text,
      'rating': _rating,
      'foto': _imageFile?.path,
      'tanggal': DateTime.now().toString(),
    });

    setState(() {
      _penilaianController.clear();
      _imageFile = null;
      _rating = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Penilaian berhasil dikirim!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penilaian Makanan'),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Bagaimana pendapatmu tentang makanan hari ini?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),

                // Rating bintang
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          _rating = (index + 1).toDouble();
                        });
                      },
                      icon: Icon(
                        Icons.star,
                        size: 32,
                        color: (index + 1) <= (_rating ?? 0)
                            ? Colors.amber
                            : Colors.grey.shade400,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),

                // TextField komentar
                TextField(
                  controller: _penilaianController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Tulis komentar',
                    hintText: 'contoh: Rasanya enak dan segar!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Preview gambar
                _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _imageFile!,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Text(
                        "Belum ada foto diunggah",
                        style: TextStyle(color: Colors.grey),
                      ),
                const SizedBox(height: 12),

                // Tombol kamera dan galeri
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _ambilDariKamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Kamera"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _ambilDariGaleri,
                      icon: const Icon(Icons.photo),
                      label: const Text("Galeri"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tombol kirim
                ElevatedButton.icon(
                  onPressed: _kirimPenilaian,
                  icon: const Icon(Icons.send),
                  label: const Text('Kirim Penilaian'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
