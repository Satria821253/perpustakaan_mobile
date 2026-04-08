import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_config.dart';

class PreferenceService extends GetConnect {
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

  Future<Map<String, dynamic>> getOptions() async {
    final res = await get('/api/users/preferences/options');
    if (res.statusCode == 200) return res.body as Map<String, dynamic>;
    throw Exception('Gagal memuat pilihan preferensi');
  }

  Future<Map<String, dynamic>> getPreferences() async {
    final res = await get('/api/users/preferences');
    if (res.statusCode == 200) return res.body as Map<String, dynamic>;
    throw Exception('Gagal memuat preferensi');
  }

  Future<void> savePreferences({
    required List<String> kategori,
    required List<String> genre,
    required List<String> pengarang,
  }) async {
    final res = await post('/api/users/preferences', {
      'kategori': kategori,
      'genre': genre,
      'pengarang': pengarang,
    });
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(res.body?['message'] ?? 'Gagal menyimpan preferensi');
    }
  }

  Future<List<Map<String, dynamic>>> getRecommendations() async {
    final res = await get('/api/books/recommendations/for-you');
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(res.body['books'] ?? []);
    }
    return [];
  }

  /// Tandai onboarding sudah selesai (meski skip)
  Future<void> markOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
  }

  /// Cek apakah onboarding sudah pernah dilakukan
  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_done') ?? false;
  }

  /// Cek apakah user sudah punya preferensi
  Future<bool> hasPreferences() async {
    try {
      final data = await getPreferences();
      final kat = List.from(data['kategori'] ?? []);
      final gen = List.from(data['genre'] ?? []);
      final pen = List.from(data['pengarang'] ?? []);
      return kat.isNotEmpty || gen.isNotEmpty || pen.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Get auth token from SharedPreferences
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }
}
