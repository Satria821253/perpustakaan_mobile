import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService extends GetConnect {
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

  Future<List<Map<String, dynamic>>> getFavorites({String? status, String? sort}) async {
    final params = <String, String>{};
    if (status != null) params['status'] = status;
    if (sort != null) params['sort'] = sort;

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    final url = query.isEmpty ? '/api/favorites' : '/api/favorites?$query';

    print('[FAVORITE SERVICE] GET $url');
    final res = await get(url);
    print('[FAVORITE SERVICE] Status: ${res.statusCode}');
    print('[FAVORITE SERVICE] Body: ${res.body}');

    if (res.statusCode == 200) {
      return (res.body['favorites'] as List).cast<Map<String, dynamic>>();
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat favorit');
  }

  Future<void> addFavorite(int bookId) async {
    final res = await post('/api/favorites', {'book_id': bookId});
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(res.body['message'] ?? 'Gagal menambah favorit');
    }
  }

  Future<void> removeFavorite(int bookId) async {
    final res = await delete('/api/favorites/$bookId');
    if (res.statusCode != 200) {
      throw Exception(res.body['message'] ?? 'Gagal menghapus favorit');
    }
  }

  Future<bool> checkFavorite(int bookId) async {
    final res = await get('/api/favorites/check/$bookId');
    if (res.statusCode == 200) return res.body['isFavorite'] == true;
    return false;
  }
}
