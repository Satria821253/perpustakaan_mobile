import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/book_detail_model.dart';
import '../services/book_detail_service.dart';

class DetailBukuController extends GetxController {
  final int bookId;
  DetailBukuController({required this.bookId});

  final _service = BookDetailService();

  final isLoading = true.obs;
  final buku = Rx<BookDetailModel?>(null);
  final isFavorit = false.obs;
  final selectedTab = 0.obs;
  final showFullDesc = false.obs;

  bool get tersedia =>
      (buku.value?.stok ?? 0) > 0 && buku.value?.status == 'tersedia';

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    _loadAll();
  }

  Future<void> _loadAll() async {
    isLoading(true);
    try {
      // [1] dan [2] paralel
      final results = await Future.wait([
        _service.getDetail(bookId),
        _service.checkFavorit(bookId),
      ]);
      buku.value = results[0] as BookDetailModel;
      isFavorit.value = results[1] as bool;
    } catch (e) {
      print('[DETAIL CTRL] ERROR: $e');
      Get.snackbar('Gagal', 'Tidak dapat memuat detail buku',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> refresh() => _loadAll();

  void setTab(int i) => selectedTab(i);
  void toggleDesc() => showFullDesc(!showFullDesc.value);

  // [3] Toggle favorit
  Future<void> toggleFavorit() async {
    final prev = isFavorit.value;
    isFavorit(!prev); // optimistic update
    try {
      if (prev) {
        await _service.removeFavorit(bookId);
      } else {
        await _service.addFavorit(bookId);
      }
    } catch (e) {
      isFavorit(prev); // rollback
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // [4] Reservasi buku
  Future<void> pinjamBuku() async {
    try {
      final result = await _service.reserveBuku(bookId);
      _showKodeBRW(result);
      await _loadAll();
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
  void _showKodeBRW(Map<String, dynamic> result) {
    final kode = result['code'] ?? '';
    final judul = result['book_judul'] ?? buku.value?.judul ?? '';
    final expiresAt = result['expires_at'] ?? '';

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reservasi Berhasil! 🎉',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(judul,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 16),
            const Text('Kode Reservasi:',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(kode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 22,
                      fontWeight: FontWeight.w800, color: Color(0xFF1565C0),
                      letterSpacing: 2)),
            ),
            const SizedBox(height: 12),
            if (expiresAt.isNotEmpty)
              Text('Berlaku hingga: $expiresAt',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.black45)),
            const SizedBox(height: 8),
            const Text('Tunjukkan kode ini ke petugas perpustakaan.',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.black54)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tutup',
                style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF1565C0))),
          ),
        ],
      ),
    );
  }

  // [5] Preview PDF
  void bukaPdf() {
    final pdf = buku.value?.previewPdf;
    if (pdf == null) return;
    Get.toNamed('/baca-preview', arguments: {'pdf_url': pdf});
  }
}
