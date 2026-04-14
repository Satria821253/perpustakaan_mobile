import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_config.dart';

class NotificationService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConfig.baseUrl;
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((req) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      if (token.isNotEmpty) req.headers['Authorization'] = 'Bearer $token';
      return req;
    });
  }

  /// GET /api/notifications/unread-count
  Future<int> getUnreadCount() async {
    final res = await get('/api/notifications/unread-count');
    if (res.statusCode == 200) {
      return res.body['count'] ?? 0;
    }
    return 0;
  }

  /// GET /api/notifications
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final res = await get('/api/notifications');
    if (res.statusCode == 200) {
      final List raw = res.body['data'] ?? res.body['notifications'] ?? [];
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat notifikasi');
  }

  /// PUT /api/notifications/:id/read
  Future<void> markRead(int id) async {
    await put('/api/notifications/$id/read', {});
  }

  /// PUT /api/notifications/mark-all-read
  Future<void> markAllRead() async {
    await put('/api/notifications/mark-all-read', {});
  }
}
