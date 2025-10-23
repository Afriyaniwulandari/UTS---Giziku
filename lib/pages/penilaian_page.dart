import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PenilaianPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onKirim;

  const PenilaianPage({super.key, required this.onKirim});

  @override
  State<PenilaianPage> createState() => _PenilaianPageState();
}

class _PenilaianPageState extends State<PenilaianPage> {
  File? _image;
  final TextEditingController _hasilController = TextEditingController();

  Future<void> _ambilGambar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _kirimPenilaian() {
    if (_hasilController.text.isNotEmpty && _image != null) {
      widget.onKirim({
        "hasil": _hasilController.text,
        "gambar": _image!.path,
        "tanggal": DateTime.now().toString(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Penilaian berhasil dikirim')),
      );
      _hasilController.clear();
      setState(() => _image = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Penilaian Gizi')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _hasilController,
              decoration: const InputDecoration(
                labelText: 'Hasil Penilaian',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _image == null
                ? const Text('Belum ada gambar')
                : Image.file(_image!, height: 200),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _ambilGambar,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Ambil Gambar'),
                ),
                ElevatedButton.icon(
                  onPressed: _kirimPenilaian,
                  icon: const Icon(Icons.send),
                  label: const Text('Kirim'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
