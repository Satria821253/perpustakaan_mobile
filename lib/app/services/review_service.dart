import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://192.168.1.19:5000';
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((request) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      if (token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';
      return request;
    });
  }

  static const _base = 'http://192.168.1.19:5000';

  Map<String, dynamic> _fixPhoto(Map<String, dynamic> item) {
    final raw = item['photo_profile'] as String? ?? '';
    if (raw.isEmpty || raw.startsWith('http')) return item;
    return {...item, 'photo_profile': '$_base$raw'};
  }

  Future<Map<String, dynamic>> getStats(int bookId) async {
    print('[REVIEW] GET /api/reviews/book/$bookId/stats');
    final res = await get('/api/reviews/book/$bookId/stats');
    print('[REVIEW] stats ${res.statusCode} → ${res.body}');
    if (res.statusCode == 200) return res.body as Map<String, dynamic>;
    throw Exception('Gagal memuat statistik ulasan (${res.statusCode})');
  }

  Future<List<Map<String, dynamic>>> getReviews(int bookId) async {
    print('[REVIEW] GET /api/reviews/book/$bookId');
    final res = await get('/api/reviews/book/$bookId');
    print('[REVIEW] reviews ${res.statusCode} → ${res.body}');
    if (res.statusCode == 200) {
      final list = List<Map<String, dynamic>>.from(res.body['reviews'] ?? []);
      return list.map((r) => _fixPhoto(r)).toList();
    }
    throw Exception('Gagal memuat ulasan (${res.statusCode})');
  }

  Future<String> postReview(int bookId, int rating, String review) async {
    final body = {
      'book_id': bookId,
      'rating': rating,
      if (review.isNotEmpty) 'review': review,
    };
    print('[REVIEW] POST /api/reviews → $body');
    final res = await post('/api/reviews', body);
    print('[REVIEW] POST ${res.statusCode} → ${res.body}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return res.body['message'] ?? 'Review berhasil!';
    }
    throw Exception(res.body?['message'] ?? 'Gagal mengirim ulasan (${res.statusCode})');
  }

  Future<String> putReview(int reviewId, int rating, String review) async {
    final body = {
      'rating': rating,
      if (review.isNotEmpty) 'review': review,
    };
    print('[REVIEW] PUT /api/reviews/review/$reviewId → $body');
    final res = await put('/api/reviews/review/$reviewId', body);
    print('[REVIEW] PUT ${res.statusCode} → ${res.body}');
    if (res.statusCode == 200) return res.body['message'] ?? 'Ulasan diperbarui!';
    throw Exception(res.body?['message'] ?? 'Gagal memperbarui ulasan (${res.statusCode})');
  }

  Future<void> deleteReview(int reviewId) async {
    print('[REVIEW] DELETE /api/reviews/review/$reviewId');
    final res = await delete('/api/reviews/review/$reviewId');
    print('[REVIEW] DELETE ${res.statusCode} → ${res.body}');
    if (res.statusCode != 200) {
      throw Exception(res.body?['message'] ?? 'Gagal menghapus ulasan (${res.statusCode})');
    }
  }

  Future<void> reportReview(int reviewId, String reason, String description) async {
    print('[REVIEW] POST /api/reviews/review/$reviewId/report');
    final res = await post('/api/reviews/review/$reviewId/report', {
      'reason': reason,
      if (description.isNotEmpty) 'description': description,
    });
    print('[REVIEW] report ${res.statusCode} → ${res.body}');
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(res.body?['message'] ?? 'Gagal melaporkan ulasan (${res.statusCode})');
    }
  }

  Future<List<Map<String, dynamic>>> getReplies(int reviewId) async {
    print('[REPLY] GET /api/reviews/review/$reviewId/replies');
    final res = await get('/api/reviews/review/$reviewId/replies');
    print('[REPLY] ${res.statusCode} → ${res.body}');
    if (res.statusCode == 200) {
      final list = List<Map<String, dynamic>>.from(res.body['replies'] ?? []);
      return list.map((r) => _fixPhoto(r)).toList();
    }
    throw Exception('Gagal memuat balasan (${res.statusCode})');
  }

  Future<String> postReply(int reviewId, String reply) async {
    print('[REPLY] POST /api/reviews/review/$reviewId/replies → $reply');
    final res = await post('/api/reviews/review/$reviewId/replies', {'reply': reply});
    print('[REPLY] POST ${res.statusCode} → ${res.body}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return res.body['message'] ?? 'Balasan terkirim!';
    }
    throw Exception(res.body?['message'] ?? 'Gagal mengirim balasan (${res.statusCode})');
  }

  Future<String> putReply(int replyId, String reply) async {
    print('[REPLY] PUT /api/reviews/reply/$replyId → $reply');
    final res = await put('/api/reviews/reply/$replyId', {'reply': reply});
    print('[REPLY] PUT ${res.statusCode} → ${res.body}');
    if (res.statusCode == 200) return res.body['message'] ?? 'Balasan diperbarui!';
    throw Exception(res.body?['message'] ?? 'Gagal memperbarui balasan (${res.statusCode})');
  }

  Future<void> deleteReply(int replyId) async {
    print('[REPLY] DELETE /api/reviews/reply/$replyId');
    final res = await delete('/api/reviews/reply/$replyId');
    print('[REPLY] DELETE ${res.statusCode} → ${res.body}');
    if (res.statusCode != 200) {
      throw Exception(res.body?['message'] ?? 'Gagal menghapus balasan (${res.statusCode})');
    }
  }
}
