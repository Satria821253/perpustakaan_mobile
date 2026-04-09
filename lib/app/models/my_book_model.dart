import 'package:ei_books/app/core/app_config.dart';

class MyBookModel {
  final int id;
  final int bookId;
  final String bookJudul;
  final String? coverImage;
  final String tanggalPinjam;
  final String tanggalKembali;
  final int hariTersisa;
  final String status;
  final int denda;
  final bool dendaDibayar;
  final double rating;
  final int totalRating;
  final int totalDipinjam;
  final int durasiPinjam;
  final int quantity;
  final int jumlahPerpanjangan;
  final String kategori;
  final String genre;

  MyBookModel({
    required this.id,
    required this.bookId,
    required this.bookJudul,
    this.coverImage,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.hariTersisa,
    required this.status,
    required this.denda,
    required this.dendaDibayar,
    required this.rating,
    required this.totalRating,
    required this.totalDipinjam,
    required this.durasiPinjam,
    this.quantity = 1,
    this.jumlahPerpanjangan = 0,
    this.kategori = '',
    this.genre = '',
  });

  bool get isPopuler => totalDipinjam > 0 && rating >= 4.0 && totalRating >= 3;

  factory MyBookModel.fromJson(Map<String, dynamic> j) {
    final raw = j['cover_image'] as String? ?? '';
    final cover = raw.isNotEmpty
        ? raw
            .replaceFirst(RegExp(r'https?://localhost:\d+'), AppConfig.baseUrl)
            .replaceFirst(RegExp(r'https?://127\.0\.0\.1:\d+'), AppConfig.baseUrl)
            .replaceFirst(RegExp(r'^/'), '${AppConfig.baseUrl}/')
        : null;
    return MyBookModel(
      id: j['id'],
      bookId: j['book_id'],
      bookJudul: j['book_judul'] ?? '',
      coverImage: cover,
      tanggalPinjam: j['tanggal_pinjam'] ?? '',
      tanggalKembali: j['tanggal_kembali_formatted'] ?? j['tanggal_kembali'] ?? '',
      hariTersisa: j['hari_tersisa'] ?? 0,
      status: j['status'] ?? '',
      denda: j['denda'] ?? 0,
      dendaDibayar: (j['denda_dibayar'] == true || j['denda_dibayar'] == 1),
      rating: double.tryParse('${j['rating']}') ?? 0.0,
      totalRating: j['total_rating'] ?? 0,
      totalDipinjam: j['book_total_dipinjam'] ?? 0,
      durasiPinjam: j['durasi_pinjam'] ?? 14,
      quantity: j['quantity'] ?? 1,
      jumlahPerpanjangan: j['jumlah_perpanjangan'] ?? 0,
      kategori: j['category_name'] ?? '',
      genre: j['genre'] ?? '',
    );
  }
}
