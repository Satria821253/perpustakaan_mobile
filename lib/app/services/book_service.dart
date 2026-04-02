import 'package:get/get.dart';
import '../models/book_model.dart';

const _baseUrl = 'http://192.168.1.19:5000';

class BookService extends GetConnect {
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
    final url = '$_baseUrl/api/books';
    final res = await get(url, query: query);
    if (res.statusCode == 200) {
      final List list = res.body['books'] ?? [];
      return list.map((e) => BookModel.fromJson(e)).toList();
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat buku (${res.statusCode})');
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final res = await get('$_baseUrl/api/categories?active_only=true');
    if (res.statusCode == 200) {
      return (res.body['data'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception('Gagal memuat kategori');
  }

  Future<List<Map<String, dynamic>>> getGenres() async {
    final res = await get('$_baseUrl/api/genres?active_only=true');
    if (res.statusCode == 200) {
      return (res.body['data'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception('Gagal memuat genre');
  }
}
