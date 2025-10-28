import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onKirim;

  const HomePage({super.key, required this.onKirim});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _namaMenuController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  XFile? _pickedFile;
  Uint8List? _imageBytes;

  // 🟢 Ambil gambar dari kamera atau galeri
  Future<void> _ambilGambar(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _pickedFile = pickedFile;
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
    }
  }

  void _simpanMenu() {
    if (_namaMenuController.text.isNotEmpty) {
      // Simpan data lengkap ke Riwayat
      widget.onKirim({
        "menu": _namaMenuController.text, // ubah dari 'nama' ke 'menu'
        "tanggal": DateTime.now().toString().substring(0, 16),
        "gambar": _imageBytes, // ubah dari 'gambarBytes' ke 'gambar'
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ Menu berhasil disimpan ke riwayat'),
          backgroundColor: Colors.green.shade600,
        ),
      );

      _namaMenuController.clear();
      setState(() {
        _pickedFile = null;
        _imageBytes = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Nama makanan wajib diisi'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAF4),
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        title: const Text(
          'Menu Hari Ini 🍽️',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Masukkan Menu Bergizi Hari Ini",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 🟢 Input nama makanan
                    TextField(
                      controller: _namaMenuController,
                      decoration: InputDecoration(
                        labelText: "Nama Makanan",
                        hintText: "Contoh: Nasi Ayam + Sayur Sop + Susu",
                        prefixIcon: const Icon(
                          Icons.restaurant_menu,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 🟢 Tambah foto makanan
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => SafeArea(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.green,
                                  ),
                                  title: const Text('Ambil dari Kamera'),
                                  onTap: () {
                                    _ambilGambar(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.photo_library,
                                    color: Colors.green,
                                  ),
                                  title: const Text('Pilih dari Galeri'),
                                  onTap: () {
                                    _ambilGambar(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: _imageBytes == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.green,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Tambahkan Foto Makanan",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  _imageBytes!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🟢 Tombol simpan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _simpanMenu,
                        icon: const Icon(Icons.save),
                        label: const Text("Simpan Menu"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            Text(
              "Pastikan makanan mengandung karbohidrat, protein, sayur, dan buah agar seimbang 💚",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green.shade800, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
