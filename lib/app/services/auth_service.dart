import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_config.dart';

class AuthService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConfig.baseUrl;
    httpClient.timeout = const Duration(seconds: 15);
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((request) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      if (token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';
      return request;
    });
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nama,
    required String noTelepon,
  }) async {
    final res = await post('/api/auth/register', {
      'email': email,
      'password': password,
      'nama': nama,
      'no_telepon': noTelepon,
    });
    if (res.statusCode == 201) return res.body;
    if (res.statusCode == 400) throw Exception(res.body['message'] ?? 'Validasi error atau email sudah terdaftar');
    throw Exception('Server error ($res.statusCode), coba lagi');
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String fcmToken = '',
  }) async {
    final res = await post('/api/auth/login', {
      'email': email,
      'password': password,
      'fcmToken': fcmToken,
    });
    if (res.statusCode == null) throw Exception('Tidak dapat terhubung ke server. Pastikan HP dan komputer satu jaringan WiFi.');
    if (res.statusCode == 200) return res.body;
    if (res.statusCode == 400) throw Exception('Email atau password tidak diisi');
    if (res.statusCode == 401) throw Exception('Email atau password salah');
    if (res.statusCode == 403) throw Exception('Akun tidak aktif atau bukan role anggota');
    throw Exception('Server error ($res.statusCode), coba lagi');
  }

  Future<Map<String, dynamic>> getProfile() async {
    final res = await get('/api/auth/me');
    if (res.statusCode == 200) return res.body;
    throw Exception('Gagal memuat profile');
  }

  Future<void> updateProfile({required String nama, required String noTelepon}) async {
    final res = await put('/api/auth/update-profile', {
      'nama': nama,
      'no_telepon': noTelepon,
    });
    if (res.statusCode != 200) throw Exception(res.body['message'] ?? 'Gagal update profile');
  }

  Future<void> changePassword({required String oldPassword, required String newPassword}) async {
    final res = await put('/api/auth/change-password', {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
    if (res.statusCode != 200) throw Exception(res.body['message'] ?? 'Gagal ganti password');
  }

  Future<Map<String, dynamic>> getChallengeProgress() async {
    final res = await get('/api/challenges/my-progress');
    if (res.statusCode == 200) return res.body;
    throw Exception('Gagal memuat challenge');
  }
}
