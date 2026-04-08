import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/buku_saya_controller.dart';
import '../controllers/detail_buku_controller.dart';
import '../core/app_config.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
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


    // Setup local notifications channel
    await _localNotif
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    await _localNotif.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    // Foreground notification
    FirebaseMessaging.onMessage.listen((message) {
      final notif = message.notification;
      final data = message.data;
      final type = data['type'] ?? '';

      // Handle buku_dikembalikan — refresh BukuSayaController
      if (type == 'buku_dikembalikan') {
        _refreshBukuSaya();
        return;
      }

      if (notif == null) return;
      String body = notif.body ?? '';
      final newlineIdx = body.indexOf('\n');
      if (newlineIdx != -1) body = body.substring(newlineIdx + 1);
      if (body.length > 100) body = '${body.substring(0, 100)}...';
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
    });

    // App dibuka dari notifikasi (terminated)
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotifTap(message.data);
      }
    });

    // App dibuka dari notifikasi (background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotifTap(message.data);
    });

    // Simpan token ke SharedPreferences
    final token = await _fcm.getToken();
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
    } else {
    }

    // Refresh token
    _fcm.onTokenRefresh.listen((token) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      await _uploadToken(token);
    });
  }

  static void _handleNotifTap(Map<String, dynamic> data) {
    final type = data['type'];
    final bookId = int.tryParse(data['book_id'] ?? '');
    final borrowingId = int.tryParse(data['borrowing_id'] ?? '');

    Future.delayed(const Duration(milliseconds: 500), () {
      if (type == 'reply' && bookId != null) {
        Get.toNamed('/detail', arguments: bookId);
        Future.delayed(const Duration(milliseconds: 800), () {
          try {
            Get.find<DetailBukuController>(tag: 'detail_$bookId').setTab(1);
          } catch (_) {}
        });
      } else if ((type == 'perpanjang_approved' || type == 'perpanjang_rejected') &&
          borrowingId != null) {
        Get.toNamed('/detail-peminjaman', arguments: borrowingId);
      } else if (type == 'buku_dikembalikan') {
        _refreshBukuSaya();
        _keRiwayat();
      }
    });
  }

  static void _refreshBukuSaya() {
    try {
      if (Get.isRegistered<BukuSayaController>()) {
        Get.find<BukuSayaController>().fetchAll();
      }
    } catch (_) {}
  }

  static void _keRiwayat() {
    Get.offAllNamed('/home');
    Future.delayed(const Duration(milliseconds: 600), () {
      try {
        if (Get.isRegistered<BukuSayaController>()) {
          Get.find<BukuSayaController>().selectedTab(2); // tab Selesai
        }
      } catch (_) {}
    });
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
        return;
      }
      final client = GetConnect();
      client.httpClient.baseUrl = AppConfig.baseUrl;
      await client.put(
        '/api/users/fcm-token',
        {'fcm_token': token},
        headers: {'Authorization': 'Bearer $authToken'},
      );
    } catch (_) {}
  }
}
