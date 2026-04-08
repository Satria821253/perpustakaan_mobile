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
    try {
      await _service.postReply(reviewId, finalText);
      replyingTo[reviewId] = null;
      replyingTo.refresh();
      await loadReplies(reviewId);
    } catch (e) {
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
