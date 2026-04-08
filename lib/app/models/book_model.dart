import 'package:ei_books/app/core/app_config.dart';

class BookModel {
  final int id;
  final String judul;
  final String pengarang;
  final String? coverImage;
  final double rating;
  final int totalRating;
  final int totalDipinjam;
  final String status;
  final String kategori;
  final String genre;
  final int tahunTerbit;
  final String penerbit;
  final int stok;
  final int jumlahHalaman;

  BookModel({
    required this.id,
    required this.judul,
    required this.pengarang,
    this.coverImage,
    required this.rating,
    required this.totalRating,
    required this.totalDipinjam,
    required this.status,
    required this.kategori,
    required this.genre,
    required this.tahunTerbit,
    required this.penerbit,
    required this.stok,
    required this.jumlahHalaman,
  });

  factory BookModel.fromJson(Map<String, dynamic> j) {
    final raw = j['cover_image'] as String? ?? '';
    final cover = raw.isNotEmpty
        ? raw
              .replaceFirst(RegExp(r'https?://localhost:\d+'), AppConfig.baseUrl)
              .replaceFirst(RegExp(r'https?://127\.0\.0\.1:\d+'), AppConfig.baseUrl)
              .replaceFirst(RegExp(r'^/uploads'), '${AppConfig.baseUrl}/uploads')
        : null;
    return BookModel(
      id: j['id'],
      judul: j['judul'] ?? '',
      pengarang: j['pengarang'] ?? '',
      coverImage: cover,
      rating: double.tryParse('${j['rating']}') ?? 0.0,
      totalRating: j['total_rating'] ?? 0,
      totalDipinjam: j['total_dipinjam'] ?? 0,
      status: j['status'] ?? '',
      kategori: j['category_name'] ?? '',
      genre: j['genre'] ?? '',
      tahunTerbit: j['tahun_terbit'] ?? 0,
      penerbit: j['penerbit'] ?? '',
      stok: j['stok'] ?? 0,
      jumlahHalaman: j['jumlah_halaman'] ?? 0,
    );
  }
}
