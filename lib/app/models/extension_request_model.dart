import 'package:ei_books/app/core/app_config.dart';

class ExtensionRequestModel {
  final int id;
  final int borrowingId;
  final String bookJudul;
  final String? coverImage;
  final int durasiHari;
  final String alasan;
  final String status; // pending, approved, rejected
  final String tanggalRequest;
  final String? tanggalProses;
  final String? catatanPetugas; // rejection_reason
  final String? tanggalKembaliBaru; // tanggal_kembali dari response
  final String? petugasNama;

  ExtensionRequestModel({
    required this.id,
    required this.borrowingId,
    this.bookJudul = '',
    this.coverImage,
    required this.durasiHari,
    required this.alasan,
    required this.status,
    required this.tanggalRequest,
    this.tanggalProses,
    this.catatanPetugas,
    this.tanggalKembaliBaru,
    this.petugasNama,
  });

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  factory ExtensionRequestModel.fromJson(Map<String, dynamic> j) {
    final raw = j['cover_image'] as String? ?? '';
    final cover = raw.isNotEmpty
        ? raw
            .replaceFirst(RegExp(r'https?://localhost:\d+'), AppConfig.baseUrl)
            .replaceFirst(RegExp(r'https?://127\.0\.0\.1:\d+'), AppConfig.baseUrl)
            .replaceFirst(RegExp(r'^/'), '${AppConfig.baseUrl}/')
        : null;

    return ExtensionRequestModel(
      id: j['id'] ?? 0,
      borrowingId: j['borrowing_id'] ?? 0,
      bookJudul: j['book_judul'] ?? '',
      coverImage: cover,
      durasiHari: j['durasi_hari'] ?? j['extension_days'] ?? 0,
      alasan: j['reason'] ?? j['alasan'] ?? '-',
      status: j['status'] ?? 'pending',
      tanggalRequest: j['request_time'] ?? j['created_at'] ?? '-',
      tanggalProses: j['approved_at'] ?? j['processed_at'],
      catatanPetugas: j['rejection_reason'] ?? j['catatan_petugas'],
      tanggalKembaliBaru: j['tanggal_kembali'] != null
          ? _formatDate(j['tanggal_kembali'] as String)
          : null,
      petugasNama: j['petugas_nama'],
    );
  }

  static String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw).toLocal();
      const bulan = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${dt.day} ${bulan[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}
