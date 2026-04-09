import 'package:flutter/material.dart';
import 'package:ei_books/app/core/app_config.dart';

class TimelineItem {
  final String activity;
  final String description;
  final String createdAt;
  final IconData icon;
  final Color color;

  const TimelineItem({
    required this.activity,
    required this.description,
    required this.createdAt,
    required this.icon,
    required this.color,
  });

  static IconData iconFor(String activity) {
    switch (activity) {
      case 'perpanjangan': return Icons.event_repeat_rounded;
      case 'dikembalikan': return Icons.assignment_return_rounded;
      case 'denda':
      case 'bayar_denda': return Icons.monetization_on_outlined;
      default: return Icons.book_outlined;
    }
  }

  static Color colorFor(String activity) {
    switch (activity) {
      case 'perpanjangan': return const Color(0xFF6A1B9A);
      case 'dikembalikan': return const Color(0xFF2E7D32);
      case 'denda':
      case 'bayar_denda': return const Color(0xFFD32F2F);
      default: return const Color(0xFF1565C0);
    }
  }

  factory TimelineItem.fromJson(Map<String, dynamic> j) {
    final act = j['activity'] as String? ?? '';
    return TimelineItem(
      activity: act,
      description: j['description'] ?? j['keterangan'] ?? act,
      createdAt: j['created_at'] ?? j['tanggal'] ?? '',
      icon: iconFor(act),
      color: colorFor(act),
    );
  }
}

class BorrowingDetailModel {
  final int id;
  final String bookJudul;
  final String pengarang;
  final String? coverImage;
  final double rating;
  final int totalRating;
  final int totalDipinjam;
  final String? categoryName;
  final String? genre;
  final String userNama;
  final String nomorAnggota;
  final int quantity; // Jumlah stock yang dipinjam
  final String tanggalPinjam;
  final String tanggalPinjamFormatted;
  final String tanggalKembali;
  final String tanggalKembaliFormatted;
  final String? tanggalDikembalikan;
  final int durasiPinjam;
  final int jumlahPerpanjangan;
  final int hariTersisa;
  final String status;
  final int denda;
  final bool dendaDibayar;
  final int saldoKoin;
  final String kanal;
  final String kondisiBuku;
  final int koinEarned;
  final List<TimelineItem> timeline;

  BorrowingDetailModel({
    required this.id,
    required this.bookJudul,
    required this.pengarang,
    this.coverImage,
    required this.rating,
    required this.totalRating,
    required this.totalDipinjam,
    this.categoryName,
    this.genre,
    required this.userNama,
    required this.nomorAnggota,
    required this.quantity,
    required this.tanggalPinjam,
    required this.tanggalPinjamFormatted,
    required this.tanggalKembali,
    required this.tanggalKembaliFormatted,
    this.tanggalDikembalikan,
    required this.durasiPinjam,
    required this.jumlahPerpanjangan,
    required this.hariTersisa,
    required this.status,
    required this.denda,
    required this.dendaDibayar,
    required this.saldoKoin,
    required this.kanal,
    required this.kondisiBuku,
    required this.koinEarned,
    required this.timeline,
  });

  bool get terlambat => status == 'terlambat';
  bool get sudahDikembalikan => status == 'dikembalikan';
  bool get adaDenda => denda > 0;
  bool get koinCukup => saldoKoin >= denda;
  int get hariTerlambat => hariTersisa < 0 ? hariTersisa.abs() : 0;
  bool get isPopuler => totalDipinjam > 0 && rating >= 4.0 && totalRating >= 3;

  factory BorrowingDetailModel.fromJson(Map<String, dynamic> j) {
    final raw = j['cover_image'] as String? ?? '';
    final cover = raw.isNotEmpty
        ? raw
            .replaceFirst(RegExp(r'https?://localhost:\d+'), AppConfig.baseUrl)
            .replaceFirst(RegExp(r'https?://127\.0\.0\.1:\d+'), AppConfig.baseUrl)
            .replaceFirst(RegExp(r'^/'), '${AppConfig.baseUrl}/')
        : null;

    final rawTimeline = j['timeline'] as List? ?? [];
    final timeline = rawTimeline
        .map((e) => TimelineItem.fromJson(e as Map<String, dynamic>))
        .toList();

    return BorrowingDetailModel(
      id: j['id'] ?? 0,
      bookJudul: j['book_judul'] as String? ?? '-',
      pengarang: j['pengarang'] as String? ?? j['book_pengarang'] as String? ?? '-',
      coverImage: cover,
      rating: double.tryParse('${j['rating']}') ?? 0.0,
      totalRating: j['total_rating'] as int? ?? 0,
      totalDipinjam: j['book_total_dipinjam'] as int? ?? 0,
      categoryName: j['category_name'] as String?,
      genre: j['genre'] as String?,
      userNama: j['user_nama'] as String? ?? '-',
      nomorAnggota: j['nomor_anggota'] as String? ?? '-',
      quantity: j['quantity'] as int? ?? 1,
      tanggalPinjam: j['tanggal_pinjam'] as String? ?? '-',
      tanggalPinjamFormatted: j['tanggal_pinjam_formatted'] as String? ?? j['tanggal_pinjam'] as String? ?? '-',
      tanggalKembali: j['tanggal_kembali'] as String? ?? '-',
      tanggalKembaliFormatted: j['tanggal_kembali_formatted'] as String? ?? j['tanggal_kembali'] as String? ?? '-',
      tanggalDikembalikan: j['tanggal_dikembalikan'] as String?,
      durasiPinjam: j['durasi_pinjam'] as int? ?? 14,
      jumlahPerpanjangan: j['jumlah_perpanjangan'] as int? ?? 0,
      hariTersisa: j['hari_tersisa'] as int? ?? 0,
      status: j['status'] as String? ?? '',
      denda: j['denda'] as int? ?? 0,
      dendaDibayar: j['denda_dibayar'] == true || j['denda_dibayar'] == 1,
      saldoKoin: j['saldo_koin'] as int? ?? 0,
      kanal: (j['kanal'] as String? ?? '-').toUpperCase(),
      kondisiBuku: j['kondisi_buku'] as String? ?? '-',
      koinEarned: j['koin_earned'] as int? ?? 0,
      timeline: timeline,
    );
  }
}
