import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends GetConnect {
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

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final res = await get('/api/notifications');
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(res.body['notifications'] ?? []);
    }
    throw Exception('Gagal memuat notifikasi');
  }

  Future<int> getUnreadCount() async {
    final res = await get('/api/notifications/unread-count');
    if (res.statusCode == 200) return res.body['count'] ?? 0;
    return 0;
  }

  Future<void> markRead(int id) async {
    await put('/api/notifications/$id/read', {});
  }

  Future<void> markAllRead() async {
    await put('/api/notifications/mark-all-read', {});
  }

  Future<void> uploadFcmToken(String token) async {
    await put('/api/users/fcm-token', {'fcm_token': token});
  }
}
