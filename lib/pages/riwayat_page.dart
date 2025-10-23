import 'package:flutter/material.dart';
import 'dart:io';

class RiwayatPage extends StatelessWidget {
  final List<Map<String, dynamic>> riwayatPenilaian;
  final List<Map<String, dynamic>> riwayatMenu;

  const RiwayatPage({
    super.key,
    required this.riwayatPenilaian,
    required this.riwayatMenu,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Penilaian'),
              Tab(text: 'Menu Harian'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(riwayatPenilaian, 'Belum ada riwayat penilaian'),
            _buildList(riwayatMenu, 'Belum ada riwayat menu'),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> data, String emptyText) {
    if (data.isEmpty) {
      return Center(child: Text(emptyText));
    }
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: item['gambar'] != null
                ? Image.file(
                    File(item['gambar']),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image),
            title: Text(item['nama'] ?? item['hasil'] ?? 'Tidak ada judul'),
            subtitle: Text(item['tanggal'] ?? ''),
          ),
        );
      },
    );
  }
}
