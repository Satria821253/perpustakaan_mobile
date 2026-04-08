import 'package:ei_books/app/core/app_config.dart';

class BookDetailModel {
  final int id;
  final String judul;
  final String pengarang;
  final String penerbit;
  final String? coverImage;
  final double rating;
  final int totalRating;
  final int totalDipinjam;
  final int totalDibaca;
  final int uniqueReaders;
  final int stok;
  final int jumlahHalaman;
  final String format;
  final String kategori;
  final String genre;
  final int tahunTerbit;
  final String deskripsi;
  final bool isPopuler;
  final String status;
  final String? previewPdf;

  BookDetailModel({
    required this.id,
    required this.judul,
    required this.pengarang,
    required this.penerbit,
    this.coverImage,
    required this.rating,
    required this.totalRating,
    required this.totalDipinjam,
    required this.totalDibaca,
    this.uniqueReaders = 0,
    required this.stok,
    required this.jumlahHalaman,
    required this.format,
    required this.kategori,
    required this.genre,
    required this.tahunTerbit,
    required this.deskripsi,
    required this.isPopuler,
    required this.status,
    this.previewPdf,
  });

  bool get tersedia => stok > 0 && status == 'tersedia';

  factory BookDetailModel.fromJson(Map<String, dynamic> j) {
    final raw = j['cover_image'] as String? ?? '';
    final cover = raw.isNotEmpty
        ? raw
              .replaceFirst(RegExp(r'https?://localhost:\d+'), AppConfig.baseUrl)
              .replaceFirst(RegExp(r'https?://127\.0\.0\.1:\d+'), AppConfig.baseUrl)
              .replaceFirst(RegExp(r'^/uploads'), '${AppConfig.baseUrl}/uploads')
        : null;
    final totalDipinjam = j['total_dipinjam'] ?? 0;
    final rating = double.tryParse('${j['rating']}') ?? 0.0;
    final totalRating = j['total_rating'] ?? 0;
    return BookDetailModel(
      id: j['id'],
      judul: j['judul'] ?? '',
      pengarang: j['pengarang'] ?? '',
      penerbit: j['penerbit'] ?? '',
      coverImage: cover,
      rating: rating,
      totalRating: totalRating,
      totalDipinjam: totalDipinjam,
      totalDibaca: j['total_dibaca'] ?? 0,
      uniqueReaders: j['unique_readers'] ?? 0,
      stok: j['stok'] ?? 0,
      jumlahHalaman: j['jumlah_halaman'] ?? 0,
      format: j['format'] ?? 'Fisik',
      kategori: j['category_name'] ?? '',
      genre: j['genre'] ?? '',
      tahunTerbit: j['tahun_terbit'] ?? 0,
      deskripsi: j['deskripsi'] ?? '',
      isPopuler: totalDipinjam > 0 && rating >= 4.0 && totalRating >= 3,
      status: j['status'] ?? '',
      previewPdf: j['preview_pdf'] as String?,
    );
  }
}
