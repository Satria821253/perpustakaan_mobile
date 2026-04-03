import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/review_service.dart';

class ReviewController extends GetxController {
  final int bookId;
  ReviewController({required this.bookId});

  final _service = ReviewService();

  final isLoading = true.obs;
  final isSubmitting = false.obs;

  final averageRating = 0.0.obs;
  final totalReviews = 0.obs;
  final distribution = <String, int>{}.obs;
  final reviews = <Map<String, dynamic>>[].obs;

  final selectedRating = 0.obs;
  final reviewText = ''.obs;

  final repliesMap = <int, List<Map<String, dynamic>>>{}.obs;
  final loadingReplies = <int, bool>{}.obs;
  final expandedReplies = <int, bool>{}.obs;
  final replyingTo = <int, Map<String, String>?>{}.obs;

  int? get myUserId => AuthController.to.user.value?.id;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    isLoading(true);
    try {
      final results = await Future.wait([
        _service.getStats(bookId),
        _service.getReviews(bookId),
      ]);
      final stats = results[0] as Map<String, dynamic>;
      averageRating.value = double.tryParse('${stats['average_rating']}') ?? 0.0;
      totalReviews.value = stats['total_reviews'] ?? 0;
      distribution.value = Map<String, int>.from(
        (stats['rating_distribution'] as Map? ?? {}).map(
          (k, v) => MapEntry(k.toString(), int.tryParse('$v') ?? 0),
        ),
      );
      reviews.value = List<Map<String, dynamic>>.from(results[1] as List);
      _prefetchReplies();
    } catch (e) {
      print('[REVIEW CTRL] loadAll error: $e');
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> _prefetchReplies() async {
    final ids = reviews.map((r) => (r['id'] as num).toInt()).toList();
    await Future.wait(ids.map((id) async {
      try {
        repliesMap[id] = await _service.getReplies(id);
      } catch (_) {}
    }));
    repliesMap.refresh();
  }

  Future<void> submitReview() async {
    if (selectedRating.value == 0) {
      Get.snackbar('Perhatian', 'Pilih rating terlebih dahulu',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isSubmitting(true);
    try {
      final msg = await _service.postReview(bookId, selectedRating.value, reviewText.value);
      Get.snackbar('Berhasil', msg, snackPosition: SnackPosition.BOTTOM);
      selectedRating(0);
      reviewText('');
      await loadAll();
    } catch (e) {
      print('[REVIEW CTRL] submit error: $e');
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting(false);
    }
  }

  Future<void> editReview(int reviewId, int rating, String text) async {
    isSubmitting(true);
    try {
      final msg = await _service.putReview(reviewId, rating, text);
      Get.snackbar('Berhasil', msg, snackPosition: SnackPosition.BOTTOM);
      await loadAll();
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting(false);
    }
  }

  Future<void> deleteReview(int reviewId) async {
    try {
      await _service.deleteReview(reviewId);
      await loadAll();
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void showEditDialog(Map<String, dynamic> review) {
    final ratingEdit = (review['rating'] as num).toInt().obs;
    final textCtrl = TextEditingController(text: review['review'] ?? '');
    Get.bottomSheet(
      Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 36, height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              const Text('Edit Ulasan',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 12),
              Obx(() => Row(
                children: List.generate(5, (i) {
                  final star = i + 1;
                  return GestureDetector(
                    onTap: () => ratingEdit.value = star,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        star <= ratingEdit.value ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: const Color(0xFFFFB300), size: 36,
                      ),
                    ),
                  );
                }),
              )),
              const SizedBox(height: 12),
              TextField(
                controller: textCtrl,
                maxLines: 4,
                style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                decoration: InputDecoration(
                  hintText: 'Tulis ulasan kamu...',
                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400], fontFamily: 'Poppins'),
                  contentPadding: const EdgeInsets.all(12),
                  filled: true, fillColor: const Color(0xFFF5F8FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5)),
                ),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: OutlinedButton(
                  onPressed: Get.back,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', color: Colors.black54, fontWeight: FontWeight.w600)),
                )),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(
                  onPressed: () { Get.back(); editReview(review['id'], ratingEdit.value, textCtrl.text); },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0), elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Simpan', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w600)),
                )),
              ]),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void confirmDelete(int reviewId) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: const Text('Hapus Ulasan?',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 15)),
      content: const Text('Ulasan kamu akan dihapus permanen.',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
      actions: [
        TextButton(onPressed: Get.back,
            child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey))),
        TextButton(
          onPressed: () { Get.back(); deleteReview(reviewId); },
          child: const Text('Hapus',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.red, fontWeight: FontWeight.w700)),
        ),
      ],
    ));
  }

  // ── REPLIES ──────────────────────────────────────────

  Future<void> toggleReplies(int reviewId) async {
    final isOpen = expandedReplies[reviewId] ?? false;
    if (!isOpen && repliesMap[reviewId] == null) await loadReplies(reviewId);
    expandedReplies[reviewId] = !isOpen;
    expandedReplies.refresh();
  }

  Future<void> loadReplies(int reviewId) async {
    loadingReplies[reviewId] = true;
    loadingReplies.refresh();
    try {
      repliesMap[reviewId] = await _service.getReplies(reviewId);
      repliesMap.refresh();
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      loadingReplies[reviewId] = false;
      loadingReplies.refresh();
    }
  }

  Future<void> submitReply(int reviewId, String text) async {
    if (text.trim().isEmpty) return;
    final target = replyingTo[reviewId];
    final finalText = target != null
        ? '@${target['nama']}: ${target['reply']}\n${text.trim()}'
        : text.trim();
    print('[REVIEW CTRL] submitReply reviewId=$reviewId text=$finalText');
    try {
      await _service.postReply(reviewId, finalText);
      replyingTo[reviewId] = null;
      replyingTo.refresh();
      await loadReplies(reviewId);
    } catch (e) {
      print('[REVIEW CTRL] reply error: $e');
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void setReplyingTo(int reviewId, String nama, String replyText) {
    // Ambil hanya teks asli, buang quote chain sebelumnya
    String cleanText = replyText;
    final newlineIdx = replyText.indexOf('\n');
    if (newlineIdx != -1 && replyText.startsWith('@')) {
      cleanText = replyText.substring(newlineIdx + 1);
    }
    replyingTo[reviewId] = {'nama': nama, 'reply': cleanText};
    replyingTo.refresh();
    if (!(expandedReplies[reviewId] ?? false)) {
      expandedReplies[reviewId] = true;
      expandedReplies.refresh();
    }
  }

  void cancelReplyingTo(int reviewId) {
    replyingTo[reviewId] = null;
    replyingTo.refresh();
  }

  Future<void> reportReview(int reviewId, String reason, String description) async {
    try {
      await _service.reportReview(reviewId, reason, description);
      Get.snackbar('Terkirim', 'Laporan berhasil dikirim', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void showReportDialog(int reviewId) => _showReportSheet('Laporkan Ulasan',
      onSend: (reason, desc) => reportReview(reviewId, reason, desc));

  void showReportReplyDialog(int reviewId, int replyId) => _showReportSheet('Laporkan Balasan',
      onSend: (reason, desc) => reportReview(replyId, reason, desc));

  void _showReportSheet(String title, {required Function(String, String) onSend}) {
    final reasons = ['spam', 'kasar', 'tidak_relevan', 'lainnya'];
    final labels = ['Spam', 'Kasar/Tidak sopan', 'Tidak relevan', 'Lainnya'];
    final selected = reasons[0].obs;
    final descCtrl = TextEditingController();
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 15)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Column(
            children: List.generate(reasons.length, (i) => RadioListTile<String>(
              dense: true, contentPadding: EdgeInsets.zero,
              title: Text(labels[i], style: const TextStyle(fontSize: 13, fontFamily: 'Poppins')),
              value: reasons[i], groupValue: selected.value,
              onChanged: (v) => selected.value = v!,
              activeColor: const Color(0xFF1565C0),
            )),
          )),
          const SizedBox(height: 8),
          TextField(
            controller: descCtrl, maxLines: 2,
            style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
            decoration: InputDecoration(
              hintText: 'Keterangan tambahan (opsional)',
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400], fontFamily: 'Poppins'),
              contentPadding: const EdgeInsets.all(10), isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: Get.back,
            child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey))),
        ElevatedButton(
          onPressed: () { Get.back(); onSend(selected.value, descCtrl.text); },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: const Text('Kirim Laporan',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ],
    ));
  }

  Future<void> editReplyAction(int reviewId, int replyId, String text) async {
    try {
      await _service.putReply(replyId, text);
      await loadReplies(reviewId);
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteReplyAction(int reviewId, int replyId) async {
    try {
      await _service.deleteReply(replyId);
      final list = repliesMap[reviewId] ?? [];
      repliesMap[reviewId] = list.where((r) => r['id'] != replyId).toList();
      repliesMap.refresh();
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
