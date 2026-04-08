import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_config.dart';
import '../models/book_model.dart';

class BookService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConfig.baseUrl;
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((request) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      if (token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';
      return request;
    });
  }

  Future<List<BookModel>> getBooks({
    String sort = 'newest',
    int limit = 10,
    String? kategori,
    String? genre,
    String? search,
  }) async {
    final query = {
      'sort': sort,
      'limit': '$limit',
      if (kategori != null) 'kategori': kategori,
      if (genre != null) 'genre': genre,
      if (search != null) 'search': search,
    };
    final res = await get('/api/books', query: query);
    if (res.statusCode == 200) {
      final List list = res.body['books'] ?? [];
      return list.map((e) => BookModel.fromJson(e)).toList();
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat buku (${res.statusCode})');
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final res = await get('/api/categories?active_only=true');
    if (res.statusCode == 200) {
      return (res.body['data'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception('Gagal memuat kategori');
  }

  Future<List<Map<String, dynamic>>> getGenres() async {
    final res = await get('/api/genres?active_only=true');
    if (res.statusCode == 200) {
      return (res.body['data'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception('Gagal memuat genre');
  }
}
