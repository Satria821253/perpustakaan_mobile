import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_config.dart';

class ProfileService extends GetConnect {
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

  Future<Map<String, dynamic>> getProfileComplete() async {
    final res = await get('/api/auth/profile-complete');
    if (res.statusCode == 200) return res.body;
    throw Exception('Gagal memuat profile');
  }

  Future<Map<String, dynamic>> getBorrowings({
    String status = 'dipinjam',
    int limit = 5,
  }) async {
    final res = await get(
      '/api/borrowings/borrowings?status=$status&page=1&limit=$limit',
    );
    if (res.statusCode == 200) return res.body;
    throw Exception('Gagal memuat peminjaman');
  }

  Future<Map<String, dynamic>> getChallengeProgress() async {
    final res = await get('/api/challenges/my-progress');
    if (res.statusCode == 200) return res.body;
    throw Exception('Gagal memuat challenge');
  }

  Future<void> updateProfile({
    required String nama,
    required String noTelepon,
  }) async {
    final res = await put('/api/auth/update-profile', {
      'nama': nama,
      'no_telepon': noTelepon,
    });
    if (res.statusCode != 200) {
      throw Exception(res.body['message'] ?? 'Gagal update profile');
    }
  }

  Future<String> uploadPhoto(List<int> bytes, String filename) async {
    final form = FormData({
      'photo': MultipartFile(
        bytes,
        filename: filename,
        contentType: 'image/jpeg',
      ),
    });
    final res = await post('/api/auth/upload-photo', form);
    if (res.statusCode == 200) return res.body['photoUrl'] ?? '';
    throw Exception('Gagal upload foto');
  }

  Future<void> requestOtp() async {
    final res = await post('/api/auth/request-otp-change-password', {});
    if (res.statusCode != 200) {
      throw Exception(res.body['message'] ?? 'Gagal kirim OTP');
    }
  }

  Future<void> changePasswordWithOtp({
    required String otp,
    required String newPassword,
  }) async {
    final res = await put('/api/auth/change-password', {
      'otp': otp,
      'newPassword': newPassword,
    });
    if (res.statusCode != 200) {
      throw Exception(res.body['message'] ?? 'Gagal ganti password');
    }
  }
}
