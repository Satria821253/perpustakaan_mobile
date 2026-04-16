import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/buku_saya_controller.dart';
import '../controllers/detail_buku_controller.dart';
import '../core/app_config.dart';

// ─────────────────────────────────────────────────────────────
// Background handler — harus top-level function
// ─────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // Firebase sudah diinit oleh FlutterFire sebelum handler ini dipanggil.
  // Tidak perlu melakukan apa-apa di sini karena notifikasi system
  // sudah otomatis ditampilkan oleh Firebase saat app terminated/background.
}

// ─────────────────────────────────────────────────────────────
// Konstanta timing — satu tempat, mudah di-tune
// ─────────────────────────────────────────────────────────────
class _Timing {
  // Delay set tab setelah navigasi ke halaman detail
  static const navToTab = Duration(milliseconds: 600);
  // Delay foreground auto-action (beri waktu UI settle)
  static const foregroundAction = Duration(milliseconds: 500);
}


// ─────────────────────────────────────────────────────────────
// FcmService
// ─────────────────────────────────────────────────────────────
class FcmService {
  static final _fcm = FirebaseMessaging.instance;
  static final _localNotif = FlutterLocalNotificationsPlugin();

  static const _channelId = 'ei_books_channel';
  static const _channel = AndroidNotificationChannel(
    _channelId,
    'EI Books Notifikasi',
    description: 'Notifikasi peminjaman, pengembalian, dan ulasan buku',
    importance: Importance.high,
    enableVibration: true,
    playSound: true,
    ledColor: Color(0xFF1565C0),
  );

  // ── Init ────────────────────────────────────────────────────
  static Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // Minta izin notifikasi (iOS / Android 13+)
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Buat channel Android
    await _localNotif
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // Init local notifications
    await _localNotif.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false, // sudah diminta di atas
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
      onDidReceiveNotificationResponse: _onLocalNotifTap,
    );

    // ── Foreground message ──────────────────────────────────
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // ── App dibuka dari notif (terminated) ─────────────────
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // Delay agar widget tree sudah siap
      await Future.delayed(const Duration(milliseconds: 300));
      _handleNotifTap(initialMessage.data);
    }

    // ── App dibuka dari notif (background) ─────────────────
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotifTap(message.data);
    });

    // ── FCM Token ──────────────────────────────────────────
    await _initToken();
  }

  // ── FCM Token management ────────────────────────────────────
  static Future<void> _initToken() async {
    final token = await _fcm.getToken();
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
    }

    _fcm.onTokenRefresh.listen((token) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      await _uploadToken(token);
    });
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  static Future<void> uploadTokenIfLoggedIn() async {
    String? token = await getToken();
    token ??= await _fcm.getToken();
    if (token == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
    await _uploadToken(token);
  }

  static Future<void> _uploadToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token') ?? '';
      if (authToken.isEmpty) return;

      final client = GetConnect();
      client.httpClient.baseUrl = AppConfig.baseUrl;
      await client.put(
        '/api/users/fcm-token',
        {'fcm_token': token},
        headers: {'Authorization': 'Bearer $authToken'},
      );
    } catch (_) {
      // Silent fail — token akan diupload saat login berikutnya
    }
  }

  // ── Foreground message handler ──────────────────────────────
  static void _onForegroundMessage(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] ?? '';

    // 1. Refresh data di background
    _handleForegroundRefresh(type);

    // 2. Tampilkan local notification (WhatsApp style)
    final notif = message.notification;
    if (notif == null) return;

    String body = notif.body ?? '';
    final newlineIdx = body.indexOf('\n');
    if (newlineIdx != -1) body = body.substring(newlineIdx + 1).trim();
    if (body.length > 120) body = '${body.substring(0, 120)}...';

    // Priority tinggi untuk muncul seperti WhatsApp
    _localNotif.show(
      notif.hashCode,
      notif.title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max, // Maksimum priority
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF1565C0),
          playSound: true,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([
            0,
            250,
            250,
            250,
          ]), // Getarlebih kuat
          ledColor: const Color(0xFF1565C0),
          ledOnMs: 1000,
          ledOffMs: 500,
          styleInformation: BigTextStyleInformation(
            body,
            contentTitle: notif.title,
            summaryText: 'EI Books',
          ),
          visibility: NotificationVisibility.public,
          category: AndroidNotificationCategory.message, // Biar dianggap pesan
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel:
              InterruptionLevel.timeSensitive, // Priority tinggi iOS
        ),
      ),
      payload: jsonEncode(data),
    );

    // 3. Tampilkan in-app overlay untuk aksi penting
    Future.delayed(_Timing.foregroundAction, () {
      _handleOverlayForForeground(type, data);
    });
  }

  /// Local notification di-tap saat app foreground/background
  static void _onLocalNotifTap(NotificationResponse details) {
    if (details.payload == null) return;
    try {
      final data = jsonDecode(details.payload!) as Map<String, dynamic>;
      _handleNotifTap(data);
    } catch (_) {}
  }

  // ── Foreground: overlay untuk aksi penting saja ─────────────
  static void _handleOverlayForForeground(
    String type,
    Map<String, dynamic> data,
  ) {
    // Tidak menampilkan overlay/snackbar in-app saat foreground
    // Hanya local notification saja yang ditampilkan
    // Semua handling dilakukan via local notification
  }

  // ── Handle tap notifikasi (dari system tray / terminated) ───
  static void _handleNotifTap(Map<String, dynamic> data) {
    final type = data['type'] ?? '';
    final bookId = int.tryParse(data['book_id'] ?? '');
    final borrowingId = int.tryParse(data['borrowing_id'] ?? '');

    switch (type) {
      // ── Peminjaman ────────────────────────────────────────
      case 'borrowing_approved':
      case 'borrowing_offline':
        if (borrowingId != null) {
          Get.offNamed('/detail-peminjaman', arguments: borrowingId);
        }
        break;

      case 'borrowing_denied':
        // Tidak ada halaman spesifik — ke buku saya
        Get.offNamed('/buku-saya');
        break;

      // ── Pengembalian ──────────────────────────────────────
      case 'return_success':
      case 'return_offline':
        if (borrowingId != null) {
          Get.offNamed('/detail-pengembalian', arguments: borrowingId);
        }
        break;

      case 'return_denied':
        if (borrowingId != null) {
          Get.offNamed('/detail-pengembalian', arguments: borrowingId);
        } else {
          Get.offNamed('/buku-saya');
        }
        break;

      // ── Perpanjangan ──────────────────────────────────────
      case 'extension_approved':
      case 'extension_denied':
        if (borrowingId != null) {
          Get.offNamed('/detail-perpanjang', arguments: borrowingId);
        }
        break;

      // ── Pembayaran ────────────────────────────────────────
      case 'payment_success':
      case 'payment_failed':
      case 'payment_offline_success':
        if (borrowingId != null) {
          Get.offNamed('/pembayaran', arguments: borrowingId);
        }
        break;

      // ── Koin ──────────────────────────────────────────────
      case 'koin_earned':
        // Navigasi ke halaman profil / riwayat koin
        Get.toNamed('/profil');
        break;

      // ── Reservasi ─────────────────────────────────────────
      case 'reservation_created':
        if (borrowingId != null) {
          Get.offNamed('/detail-peminjaman', arguments: borrowingId);
        } else {
          Get.offNamed('/buku-saya');
        }
        break;

      case 'reservation_cancelled':
        Get.offNamed('/buku-saya');
        break;

      // ── Reminder & Alert ──────────────────────────────────
      case 'reminder_due_soon':
      case 'alert_overdue':
        if (borrowingId != null) {
          Get.offNamed('/detail-peminjaman', arguments: borrowingId);
        }
        break;

      // ── Ulasan ────────────────────────────────────────────
      case 'review_created':
      case 'review_reply':
      case 'reply': // legacy
        if (bookId != null) {
          Get.toNamed('/detail', arguments: bookId);
          Future.delayed(_Timing.navToTab, () {
            try {
              Get.find<DetailBukuController>(tag: 'detail_$bookId').setTab(1);
            } catch (_) {}
          });
        }
        break;

      default:
        // Fallback — buka halaman utama
        Get.offAllNamed('/home');
        break;
    }
  }

  // ── Refresh data ────────────────────────────────────────────
  static void _refreshBukuSaya() {
    try {
      if (Get.isRegistered<BukuSayaController>()) {
        Get.find<BukuSayaController>().fetchAll();
      }
    } catch (_) {}
  }

  static void _handleForegroundRefresh(String type) {
    const refreshTypes = {
      'borrowing_approved',
      'borrowing_offline',
      'extension_approved',
      'extension_denied',
      'return_success',
      'return_offline',
      'payment_success',
      'payment_offline_success',
      'koin_earned',
      'reservation_created',
      'reservation_cancelled',
    };
    if (refreshTypes.contains(type)) _refreshBukuSaya();
  }
}
