import 'dart:io';

class PenilaianModel {
  final String komentar;
  final int rating;
  final File? foto;
  final DateTime tanggal;

  PenilaianModel({
    required this.komentar,
    required this.rating,
    required this.foto,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'komentar': komentar,
      'rating': rating,
      'foto': foto?.path, // path file disimpan agar bisa dibuka lagi
      'tanggal': tanggal.toString().split('.')[0],
    };
  }
}
