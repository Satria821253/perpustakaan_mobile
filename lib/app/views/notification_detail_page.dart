import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/notification_service.dart';

class NotificationDetailPage extends StatefulWidget {
  final int notificationId;
  const NotificationDetailPage({super.key, required this.notificationId});

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  final _service = NotificationService();
  final isLoading = true.obs;
  final data = Rxn<Map<String, dynamic>>();
  final errorMessage = ''.obs;

  @override
  void initState() {
    super.initState();
    _service.onInit();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      debugPrint(
        'Fetching notification detail for ID: ${widget.notificationId}',
      );
      data.value = await _service.getNotificationDetail(widget.notificationId);
      debugPrint('Detail fetched: ${data.value}');
      await _service.markRead(widget.notificationId);
    } catch (e) {
      debugPrint('Error fetching detail: $e');
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal memuat detail notifikasi: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  IconData _icon(String? type) {
    switch (type) {
      case 'denda':
      case 'damage_fine':
        return Icons.warning_amber_rounded;
      case 'reply':
      case 'review_reply':
        return Icons.reply_rounded;
      case 'review':
      case 'review_created':
        return Icons.star_rounded;
      case 'pinjam':
      case 'borrowing_approved':
      case 'borrowing_offline':
        return Icons.menu_book_rounded;
      case 'kembali':
      case 'return_success':
      case 'return_offline':
        return Icons.assignment_return_outlined;
      case 'perpanjang_approved':
      case 'extension_approved':
        return Icons.event_available_rounded;
      case 'perpanjang_rejected':
      case 'extension_denied':
        return Icons.event_busy_rounded;
      case 'return_damaged':
        return Icons.broken_image_outlined;
      case 'return_denied':
        return Icons.cancel_outlined;
      case 'payment_success':
      case 'payment_offline_success':
        return Icons.payments_outlined;
      case 'payment_failed':
        return Icons.payment_outlined;
      case 'reservation_created':
        return Icons.bookmark_outlined;
      case 'reservation_cancelled':
        return Icons.bookmark_remove_outlined;
      case 'koin_earned':
        return Icons.monetization_on_outlined;
      case 'reminder_due_soon':
        return Icons.schedule_outlined;
      case 'alert_overdue':
        return Icons.warning_outlined;
      case 'borrowing_denied':
        return Icons.block_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _color(String? type) {
    switch (type) {
      case 'denda':
      case 'damage_fine':
      case 'alert_overdue':
      case 'payment_failed':
      case 'borrowing_denied':
        return Colors.redAccent;
      case 'reply':
      case 'review_reply':
        return const Color(0xFF1565C0);
      case 'review':
      case 'review_created':
        return const Color(0xFFFFB300);
      case 'pinjam':
      case 'borrowing_approved':
      case 'borrowing_offline':
        return Colors.green;
      case 'kembali':
      case 'return_success':
      case 'return_offline':
        return Colors.orange;
      case 'perpanjang_approved':
      case 'extension_approved':
        return const Color(0xFF2E7D32);
      case 'perpanjang_rejected':
      case 'extension_denied':
        return const Color(0xFFD32F2F);
      case 'return_damaged':
        return Colors.orange.shade700;
      case 'return_denied':
        return const Color(0xFFD32F2F);
      case 'payment_success':
      case 'payment_offline_success':
        return const Color(0xFF2E7D32);
      case 'reservation_created':
        return const Color(0xFF1565C0);
      case 'reservation_cancelled':
        return Colors.orange;
      case 'koin_earned':
        return const Color(0xFFFFB300);
      case 'reminder_due_soon':
        return const Color(0xFFFF9800);
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final type = data.value?['type'] as String?;
    final color = _color(type);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text(
          'Detail Notifikasi',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1565C0)),
          );
        }

        if (data.value == null) {
          return const Center(
            child: Text(
              'Data tidak ditemukan',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.black54),
            ),
          );
        }

        final notif = data.value!;
        final notifType = notif['type'] as String?;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_icon(notifType), color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      notif['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _formatDate(notif['created_at'] ?? ''),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black38,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                notif['message'] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                  height: 1.6,
                ),
              ),
              if (notif['data'] != null) ...[
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Data Tambahan',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                ..._buildAdditionalData(notif['data']),
              ],
            ]
          ),
        );
      }),
    );
  }

  List<Widget> _buildAdditionalData(dynamic additionalData) {
    if (additionalData is! Map) return [];

    return additionalData.entries.map<Widget>((entry) {
      final value = entry.value?.toString() ?? '';
      if (value.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                _formatKey(entry.key.toString()),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _formatKey(String key) {
    final replacements = {
      'book_title': 'Buku',
      'borrowing_id': 'ID Peminjaman',
      'book_id': 'ID Buku',
      'koin_earned': 'Koin Earned',
      'fine_amount': 'Jumlah Denda',
      'reason': 'Alasan',
      'new_due_date': 'Tanggal Baru',
      'amount': 'Jumlah',
      'user_name': 'User',
      'replier_name': 'Pembalas',
    };
    return replacements[key] ?? key;
  }
}
