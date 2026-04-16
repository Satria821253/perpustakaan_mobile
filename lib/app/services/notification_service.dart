import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_config.dart';

class NotificationService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConfig.baseUrl;
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 30);
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
    debugPrint('Unread count response: ${res.statusCode} - ${res.body}');
    if (res.statusCode == 200) {
      return res.body['count'] ?? 0;
    }
    return 0;
  }

  /// GET /api/notifications
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final res = await get('/api/notifications');
    debugPrint('Notifications response: ${res.statusCode}');
    if (res.statusCode == 200) {
      final List raw = res.body['notifications'] ?? res.body['data'] ?? [];
      final result = raw
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      debugPrint('Notifications count: ${result.length}');
      return result;
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat notifikasi');
  }

  /// PUT /api/notifications/:id/read
  Future<void> markRead(int id) async {
    final res = await put('/api/notifications/$id/read', {});
    debugPrint('Mark read response: ${res.statusCode}');
  }

  /// PUT /api/notifications/mark-all-read
  Future<void> markAllRead() async {
    final res = await put('/api/notifications/mark-all-read', {});
    debugPrint('Mark all read response: ${res.statusCode}');
  }

  /// GET /api/notifications/:id
  Future<Map<String, dynamic>> getNotificationDetail(int id) async {
    final res = await get('/api/notifications/$id');
    debugPrint('Detail response: ${res.statusCode} - ${res.body}');
    if (res.statusCode == 200) {
      return Map<String, dynamic>.from(
        res.body['notification'] ?? res.body['data'] ?? res.body,
      );
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat detail notifikasi');
  }

  /// DELETE /api/notifications/:id
  Future<void> deleteNotification(int id) async {
    final res = await delete('/api/notifications/$id');
    debugPrint('Delete response: ${res.statusCode}');
  }

  /// POST /api/notifications/delete-multiple
  Future<void> deleteMultiple(List<int> ids) async {
    final res = await post('/api/notifications/delete-multiple', {'ids': ids});
    debugPrint('Delete multiple response: ${res.statusCode}');
  }
}
