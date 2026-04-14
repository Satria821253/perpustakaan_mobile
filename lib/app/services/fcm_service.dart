import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/buku_saya_controller.dart';
import '../controllers/detail_buku_controller.dart';
import '../core/app_config.dart';
import '../widgets/overlays/transaction_overlays.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {}

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
      onDidReceiveNotificationResponse: (details) {
        // Handle tap pada local notification
        if (details.payload != null) {
          final data = Map<String, dynamic>.from(details.payload as Map? ?? {});
          _handleNotifTap(data);
        }
      },
    );

    // Foreground notification
    FirebaseMessaging.onMessage.listen((message) {
      final notif = message.notification;
      final data = message.data;
      final type = data['type'] ?? '';

      // Auto-refresh untuk notification tertentu
      _handleForegroundRefresh(type);

      if (notif == null) return;

      // Format body
      String body = notif.body ?? '';
      final newlineIdx = body.indexOf('\n');
      if (newlineIdx != -1) body = body.substring(newlineIdx + 1);
      if (body.length > 100) body = '${body.substring(0, 100)}...';

      // Show local notification dengan sound & vibration
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
            // Sound & Vibration
            playSound: true,
            enableVibration: true,
            // Style
            styleInformation: BigTextStyleInformation(
              body,
              contentTitle: notif.title,
            ),
            // Color & LED
            color: const Color(0xFF1565C0),
            ledColor: const Color(0xFF1565C0),
            ledOnMs: 1000,
            ledOffMs: 500,
          ),
        ),
        payload: jsonEncode(data), // Pass data sebagai JSON string
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
    } else {}

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
    final bookTitle = data['book_title'] ?? '';
    Future.delayed(const Duration(milliseconds: 500), () {
      switch (type) {
        // Peminjaman
        case 'borrowing_approved':
          _handleBorrowingApproved(borrowingId, bookTitle);
          break;
        case 'borrowing_denied':
          _handleBorrowingDenied(data);
          break;
        case 'borrowing_offline':
          _handleBorrowingOffline(borrowingId, data);
          break;

        // Perpanjangan
        case 'extension_approved':
          _handleExtensionApproved(borrowingId, data);
          break;
        case 'extension_denied':
          _handleExtensionDenied(borrowingId, data);
          break;

        // Pengembalian
        case 'return_success':
          _handleReturnSuccess(borrowingId, data);
          break;
        case 'return_denied':
          _handleReturnDenied(data);
          break;
        case 'return_offline':
          _handleReturnOffline(borrowingId, data);
          break;

        // Pembayaran
        case 'payment_success':
          _handlePaymentSuccess(data);
          break;
        case 'payment_failed':
          _handlePaymentFailed(data);
          break;
        case 'payment_offline_success':
          _handlePaymentOffline(data);
          break;

        // Koin
        case 'koin_earned':
          _handleKoinEarned(data);
          break;

        // Reservasi
        case 'reservation_created':
          _handleReservationCreated(borrowingId, data);
          break;
        case 'reservation_cancelled':
          _handleReservationCancelled(data);
          break;

        // Reminder & Alert
        case 'reminder_due_soon':
          _handleReminderDueSoon(borrowingId, bookTitle);
          break;
        case 'alert_overdue':
          _handleAlertOverdue(borrowingId, data);
          break;

        // Ulasan & Reply
        case 'review_created':
          _handleReviewCreated(bookId, data);
          break;
        case 'review_reply':
          _handleReviewReply(bookId, data);
          break;

        // Legacy support
        case 'reply':
          if (bookId != null) {
            Get.toNamed('/detail', arguments: bookId);
            Future.delayed(const Duration(milliseconds: 800), () {
              try {
                Get.find<DetailBukuController>(tag: 'detail_$bookId').setTab(1);
              } catch (_) {}
            });
          }
          break;

        default:
          print('Unknown notification type: $type');
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

  static void _handleForegroundRefresh(String type) {
    // Auto-refresh data saat dapat notifikasi tertentu
    switch (type) {
      case 'borrowing_approved':
      case 'borrowing_offline':
      case 'extension_approved':
      case 'extension_denied':
      case 'return_success':
      case 'return_offline':
      case 'payment_success':
      case 'payment_offline_success':
      case 'koin_earned':
      case 'reservation_created':
      case 'reservation_cancelled':
        _refreshBukuSaya();
        break;
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

  // ========== Notification Handlers ==========

  /// Peminjaman Disetujui
  static void _handleBorrowingApproved(int? borrowingId, String bookTitle) {
    if (borrowingId == null) return;

    PeminjamanOverlay.showApproved(
      message:
          'Peminjaman buku $bookTitle telah disetujui. Silakan ambil di perpustakaan.',
      onComplete: () {
        Get.toNamed('/detail-peminjaman', arguments: borrowingId);
      },
    );
  }

  /// Peminjaman Ditolak
  static void _handleBorrowingDenied(Map<String, dynamic> data) {
    final reason = data['reason'] ?? 'Peminjaman tidak dapat diproses';

    PeminjamanOverlay.showDenied(message: reason);
  }

  /// Perpanjangan Disetujui
  static void _handleExtensionApproved(
    int? borrowingId,
    Map<String, dynamic> data,
  ) {
    if (borrowingId == null) return;

    final durationDays = data['duration_days'] ?? '7';
    final bookTitle = data['book_title'] ?? 'buku';

    PerpanjanganOverlay.showApproved(
      message:
          'Perpanjangan $bookTitle sebanyak $durationDays hari telah disetujui.',
      onComplete: () {
        Get.toNamed('/detail-perpanjang', arguments: borrowingId);
      },
    );
  }

  /// Perpanjangan Ditolak
  static void _handleExtensionDenied(
    int? borrowingId,
    Map<String, dynamic> data,
  ) {
    if (borrowingId == null) return;

    final reason = data['reason'] ?? 'Perpanjangan tidak dapat diproses';

    PerpanjanganOverlay.showDenied(
      message: reason,
      onComplete: () {
        Get.toNamed('/detail-perpanjang', arguments: borrowingId);
      },
    );
  }

  /// Pengembalian Berhasil
  static void _handleReturnSuccess(
    int? borrowingId,
    Map<String, dynamic> data,
  ) {
    if (borrowingId == null) return;

    final bookTitle = data['book_title'] ?? 'buku';
    final koinEarned = data['koin_earned'] ?? '0';

    PengembalianOverlay.showSuccess(
      message:
          'Buku $bookTitle telah berhasil dikembalikan. Kamu mendapat $koinEarned koin!',
      onComplete: () {
        _refreshBukuSaya();
        Get.toNamed('/detail-pengembalian', arguments: borrowingId);
      },
    );
  }

  /// Pengembalian Ditolak
  static void _handleReturnDenied(Map<String, dynamic> data) {
    final reason = data['reason'] ?? 'Pengembalian tidak dapat diproses';

    PengembalianOverlay.showDenied(message: reason);
  }

  /// Pembayaran Berhasil
  static void _handlePaymentSuccess(Map<String, dynamic> data) {
    final amount = data['amount'] ?? '0';

    PembayaranOverlay.showSuccess(
      message: 'Pembayaran denda sebesar Rp $amount berhasil diproses.',
    );
  }

  /// Pembayaran Gagal
  static void _handlePaymentFailed(Map<String, dynamic> data) {
    final reason = data['reason'] ?? 'Pembayaran gagal diproses';

    PembayaranOverlay.showError(message: reason);
  }

  /// Reminder Jatuh Tempo
  static void _handleReminderDueSoon(int? borrowingId, String bookTitle) {
    if (borrowingId == null) return;

    Get.toNamed('/detail-peminjaman', arguments: borrowingId);
  }

  /// Alert Terlambat
  static void _handleAlertOverdue(int? borrowingId, Map<String, dynamic> data) {
    if (borrowingId == null) return;

    Get.toNamed('/detail-peminjaman', arguments: borrowingId);
  }

  // ========== NEW HANDLERS ==========

  /// Peminjaman Offline (oleh petugas)
  static void _handleBorrowingOffline(
    int? borrowingId,
    Map<String, dynamic> data,
  ) {
    if (borrowingId == null) return;

    final bookTitle = data['book_title'] ?? 'buku';

    PeminjamanOverlay.showApproved(
      message:
          'Peminjaman buku $bookTitle telah diproses oleh petugas perpustakaan.',
      onComplete: () {
        _refreshBukuSaya();
        Get.toNamed('/detail-peminjaman', arguments: borrowingId);
      },
    );
  }

  /// Pengembalian Offline (oleh petugas)
  static void _handleReturnOffline(
    int? borrowingId,
    Map<String, dynamic> data,
  ) {
    if (borrowingId == null) return;

    final bookTitle = data['book_title'] ?? 'buku';
    final koinEarned = data['koin_earned'] ?? '0';

    String message =
        'Buku $bookTitle telah dikembalikan oleh petugas perpustakaan.';
    if (int.tryParse(koinEarned) != null && int.parse(koinEarned) > 0) {
      message += ' Kamu mendapat $koinEarned koin!';
    }

    PengembalianOverlay.showSuccess(
      message: message,
      onComplete: () {
        _refreshBukuSaya();
        Get.toNamed('/detail-pengembalian', arguments: borrowingId);
      },
    );
  }

  /// Pembayaran Offline (di perpustakaan)
  static void _handlePaymentOffline(Map<String, dynamic> data) {
    final amount = data['amount'] ?? '0';
    final bookTitle = data['book_title'] ?? 'buku';

    PembayaranOverlay.showSuccess(
      message:
          'Pembayaran denda untuk buku $bookTitle sebesar Rp $amount telah diproses di perpustakaan.',
    );
    _refreshBukuSaya();
  }

  /// Koin Earned (dapat koin)
  static void _handleKoinEarned(Map<String, dynamic> data) {
    final koinAmount = data['amount'] ?? '0';
    final reason = data['reason'] ?? 'Selamat!';

    Get.snackbar(
      '🪙 Koin Diterima!',
      'Kamu mendapat $koinAmount koin. $reason',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFFFD700).withValues(alpha: 0.9),
      colorText: Colors.black87,
      icon: const Icon(
        Icons.monetization_on,
        color: Color(0xFFFF6F00),
        size: 28,
      ),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  /// Reservasi Dibuat
  static void _handleReservationCreated(
    int? borrowingId,
    Map<String, dynamic> data,
  ) {
    final bookTitle = data['book_title'] ?? 'buku';

    Get.snackbar(
      '✅ Reservasi Berhasil',
      'Reservasi untuk buku $bookTitle telah dibuat. Kami akan memberitahu saat buku tersedia.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF4CAF50).withValues(alpha: 0.9),
      colorText: Colors.white,
      icon: const Icon(Icons.bookmark_added, color: Colors.white, size: 24),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
    _refreshBukuSaya();
  }

  /// Reservasi Dibatalkan
  static void _handleReservationCancelled(Map<String, dynamic> data) {
    final bookTitle = data['book_title'] ?? 'buku';
    final reason = data['reason'] ?? 'Reservasi dibatalkan';

    Get.snackbar(
      '❌ Reservasi Dibatalkan',
      'Reservasi untuk buku $bookTitle dibatalkan. $reason',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFFF5252).withValues(alpha: 0.9),
      colorText: Colors.white,
      icon: const Icon(Icons.cancel, color: Colors.white, size: 24),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
    _refreshBukuSaya();
  }

  /// Ulasan Baru pada Buku
  static void _handleReviewCreated(int? bookId, Map<String, dynamic> data) {
    if (bookId == null) return;

    final userName = data['user_name'] ?? 'Seseorang';
    final bookTitle = data['book_title'] ?? 'buku';

    Get.toNamed('/detail', arguments: bookId);
    Future.delayed(const Duration(milliseconds: 800), () {
      try {
        Get.find<DetailBukuController>(tag: 'detail_$bookId').setTab(1);
      } catch (_) {}
    });
  }

  /// Reply pada Ulasan
  static void _handleReviewReply(int? bookId, Map<String, dynamic> data) {
    if (bookId == null) return;

    final replierName = data['replier_name'] ?? 'Seseorang';
    final bookTitle = data['book_title'] ?? 'buku';

    Get.toNamed('/detail', arguments: bookId);
    Future.delayed(const Duration(milliseconds: 800), () {
      try {
        Get.find<DetailBukuController>(tag: 'detail_$bookId').setTab(1);
      } catch (_) {}
    });
  }
}
