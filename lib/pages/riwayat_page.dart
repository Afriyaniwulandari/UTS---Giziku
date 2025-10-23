import 'dart:io';
import 'package:flutter/material.dart';

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
      length: 2, // Dua tab: Menu & Penilaian
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF8E6),
        appBar: AppBar(
          title: const Text(
            "Riwayat",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.restaurant_menu), text: "Menu Harian"),
              Tab(icon: Icon(Icons.star_rate), text: "Penilaian"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1 - Riwayat Menu Harian
            _buildRiwayatList(
              context,
              riwayatMenu,
              "Belum ada menu yang dimasukkan.",
              Icons.fastfood,
              Colors.green[100]!,
            ),

            // Tab 2 - Riwayat Penilaian
            _buildRiwayatList(
              context,
              riwayatPenilaian,
              "Belum ada penilaian yang dikirim.",
              Icons.check_circle_outline,
              Colors.orange[100]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatList(
    BuildContext context,
    List<Map<String, dynamic>> dataList,
    String emptyMessage,
    IconData icon,
    Color color,
  ) {
    if (dataList.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: dataList.reversed.map((data) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: data['gambar'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(data['gambar']),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundColor: color,
                    child: Icon(icon, color: Colors.green[800]),
                  ),
            title: Text(
              data['menu'] ?? data['hasil'] ?? 'Tidak ada data',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              data['tanggal'] ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        );
      }).toList(),
    );
  }
}
