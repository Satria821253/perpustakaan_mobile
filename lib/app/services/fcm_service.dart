import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/detail_buku_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  print('[FCM] ═══════════════════════════════');
  print('[FCM] BACKGROUND MESSAGE DITERIMA');
  print('[FCM] Message ID : ${message.messageId}');
  print('[FCM] Title      : ${message.notification?.title}');
  print('[FCM] Body       : ${message.notification?.body}');
  print('[FCM] Data       : ${message.data}');
  print('[FCM] ═══════════════════════════════');
}

class FcmService {
  static final _fcm = FirebaseMessaging.instance;
  static final _localNotif = FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationChannel(
    'ei_books_channel',
    'EI Books Notifikasi',
    description: 'Notifikasi ulasan dan balasan',
    importance: Importance.high,
  );

  static Future<void> init() async {
    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // Request permission
    final settings = await _fcm.requestPermission(alert: true, badge: true, sound: true);
    print('[FCM] Permission status: ${settings.authorizationStatus}');

    // Setup local notifications channel
    await _localNotif
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _localNotif.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    // Foreground notification
    FirebaseMessaging.onMessage.listen((message) {
      print('[FCM] ═══════════════════════════════');
      print('[FCM] FOREGROUND MESSAGE DITERIMA');
      print('[FCM] Message ID : ${message.messageId}');
      print('[FCM] Title      : ${message.notification?.title}');
      print('[FCM] Body       : ${message.notification?.body}');
      print('[FCM] Data       : ${message.data}');
      print('[FCM] ═══════════════════════════════');
      final notif = message.notification;
      if (notif == null) {
        print('[FCM] Tidak ada notification payload, skip local notif');
        return;
      }
      // Potong body kalau ada quote chain (@nama: ...\n)
      String body = notif.body ?? '';
      final newlineIdx = body.indexOf('\n');
      if (newlineIdx != -1) body = body.substring(newlineIdx + 1);
      if (body.length > 100) body = '${body.substring(0, 100)}...';
      print('[FCM] Menampilkan local notification...');
      _localNotif.show(
        notif.hashCode,
        notif.title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
      print('[FCM] Local notification ditampilkan');
    });

    // App dibuka dari notifikasi (terminated)
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('[FCM] App dibuka dari TERMINATED via notifikasi');
        print('[FCM] Title: ${message.notification?.title}');
        print('[FCM] Data : ${message.data}');
        _handleNotifTap(message.data);
      }
    });

    // App dibuka dari notifikasi (background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('[FCM] App dibuka dari BACKGROUND via notifikasi');
      print('[FCM] Title: ${message.notification?.title}');
      print('[FCM] Data : ${message.data}');
      _handleNotifTap(message.data);
    });

    // Simpan token ke SharedPreferences
    final token = await _fcm.getToken();
    if (token != null) {
      print('[FCM] ═══════════════════════════════');
      print('[FCM] TOKEN BERHASIL DIDAPAT');
      print('[FCM] Token: $token');
      print('[FCM] ═══════════════════════════════');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
    } else {
      print('[FCM] GAGAL mendapat token - token null');
    }

    // Refresh token
    _fcm.onTokenRefresh.listen((token) async {
      print('[FCM] Token refreshed: $token');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      await _uploadToken(token);
    });
  }

  static void _handleNotifTap(Map<String, dynamic> data) {
    final type = data['type'];
    final bookId = int.tryParse(data['book_id'] ?? '');
    if (type == 'reply' && bookId != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.toNamed('/detail', arguments: bookId);
        Future.delayed(const Duration(milliseconds: 800), () {
          try {
            Get.find<DetailBukuController>(tag: 'detail_$bookId').setTab(1);
          } catch (_) {}
        });
      });
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  static Future<void> uploadTokenIfLoggedIn() async {
    String? token = await getToken();
    // Jika cache kosong, ambil langsung dari Firebase
    token ??= await _fcm.getToken();
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      await _uploadToken(token);
    }
  }

  static Future<void> _uploadToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token') ?? '';
      if (authToken.isEmpty) {
        print('[FCM] Skip upload token - user belum login');
        return;
      }
      print('[FCM] Mengupload FCM token ke server...');
      final client = GetConnect();
      client.httpClient.baseUrl = 'http://192.168.1.19:5000';
      final res = await client.put(
        '/api/users/fcm-token',
        {'fcm_token': token},
        headers: {'Authorization': 'Bearer $authToken'},
      );
      print('[FCM] Upload token → status: ${res.statusCode} body: ${res.body}');
    } catch (e) {
      print('[FCM] Upload token error: $e');
    }
  }
}
