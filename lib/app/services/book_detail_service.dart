import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_config.dart';
import '../models/book_detail_model.dart';

class BookDetailService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConfig.baseUrl;
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 30); // parallel translate ~8-10s
    httpClient.addRequestModifier<dynamic>((request) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      if (token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';
      return request;
    });
  }

  Future<BookDetailModel> getDetail(int bookId) async {
    final res = await get('/api/books/$bookId');
    if (res.statusCode == 200) {
      final data = res.body['book'] ?? res.body;
      return BookDetailModel.fromJson(data as Map<String, dynamic>);
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat detail buku');
  }

  Future<List<Map<String, dynamic>>> getBukuSerupa(int bookId) async {
    try {
      final res = await get('/api/books/$bookId/related');
      print('[SERUPA] status: ${res.statusCode}');
      print('[SERUPA] body: ${res.body}');
      if (res.statusCode == 200) {
        final List raw = res.body['books'] ?? res.body['data'] ?? res.body['related'] ?? [];
        return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return [];
    } catch (e) {
      print('[SERUPA] error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getPreview(int bookId, String type, {String lang = 'id'}) async {
    final res = await get('/api/books/$bookId/preview?type=$type&lang=$lang');
    print('[SERVICE] getPreview status: ${res.statusCode}');
    print('[SERVICE] getPreview body: ${res.body}');
    if (res.statusCode == 200 && res.body != null) {
      return res.body as Map<String, dynamic>;
    }
    if (res.statusCode == null) {
      throw Exception('Terjemahan timeout. Koneksi lambat atau server sibuk, coba lagi.');
    }
    throw Exception(res.body?['message'] ?? 'Preview tidak tersedia');
  }
}
