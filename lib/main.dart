import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/penilaian_page.dart';
import 'pages/riwayat_page.dart';

void main() {
  runApp(const GiziAmanApp());
}

class GiziAmanApp extends StatelessWidget {
  const GiziAmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gizi Aman',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key});

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  int _selectedIndex = 0;

  /// 🟩 Data riwayat untuk dua halaman
  List<Map<String, dynamic>> _riwayatPenilaian = [];
  List<Map<String, dynamic>> _riwayatMenu = [];

  /// 🟩 Fungsi untuk menambahkan data penilaian dari halaman Penilaian
  void _tambahPenilaian(Map<String, dynamic> penilaian) {
    setState(() {
      _riwayatPenilaian.add(penilaian);
    });
  }

  /// 🟩 Fungsi untuk menambahkan data menu dari halaman Home
  void _tambahMenu(Map<String, dynamic> menu) {
    setState(() {
      _riwayatMenu.add(menu);
    });
  }

  @override
  Widget build(BuildContext context) {
    /// ✅ Urutan halaman dalam BottomNav
    final List<Widget> pages = [
      HomePage(onKirim: _tambahMenu), // kirim data menu ke sini
      PenilaianPage(onKirim: _tambahPenilaian), // kirim data penilaian ke sini
      RiwayatPage(
        riwayatMenu: _riwayatMenu,
        riwayatPenilaian: _riwayatPenilaian,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Penilaian',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
      ),
    );
  }
}
