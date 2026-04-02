import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book_detail_model.dart';

class BookDetailService extends GetConnect {
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

  Future<BookDetailModel> getDetail(int bookId) async {
    final res = await get('/api/books/$bookId');
    print('[DETAIL] GET /api/books/$bookId → ${res.statusCode}');
    print('[DETAIL] Body: ${res.body}');
    if (res.statusCode == 200) {
      final data = res.body['book'] ?? res.body;
      return BookDetailModel.fromJson(data as Map<String, dynamic>);
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat detail buku');
  }

  Future<bool> checkFavorit(int bookId) async {
    final res = await get('/api/favorites/check/$bookId');
    if (res.statusCode == 200) return res.body['isFavorite'] == true;
    return false;
  }

  Future<void> addFavorit(int bookId) async {
    final res = await post('/api/favorites', {'book_id': bookId});
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(res.body?['message'] ?? 'Gagal menambah favorit');
    }
  }

  Future<void> removeFavorit(int bookId) async {
    final res = await delete('/api/favorites/$bookId');
    if (res.statusCode != 200) {
      throw Exception(res.body?['message'] ?? 'Gagal menghapus favorit');
    }
  }

  Future<Map<String, dynamic>> reserveBuku(int bookId) async {
    final res = await post('/api/borrowings/reserve-book', {'book_id': bookId});
    print('[DETAIL] POST /api/borrowings/reserve-book → ${res.statusCode}');
    print('[DETAIL] Body: ${res.body}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return res.body as Map<String, dynamic>;
    }
    throw Exception(res.body?['error'] ?? res.body?['message'] ?? 'Gagal reservasi buku');
  }
}
