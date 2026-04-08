import 'package:ei_books/app/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = NotificationController.to;
    WidgetsBinding.instance.addPostFrameCallback((_) => ctrl.fetchNotifications());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text('Notifikasi',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 16)),
        elevation: 0,
        actions: [
          Obx(() {
            if (ctrl.notifications.any((n) => n['is_read'] == false)) {
              return TextButton(
                onPressed: ctrl.markAllRead,
                child: const Text('Tandai semua dibaca',
                    style: TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Poppins')),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)));
        }
        if (ctrl.notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications_off_outlined, size: 56, color: Colors.black12),
                SizedBox(height: 12),
                Text('Belum ada notifikasi',
                    style: TextStyle(color: Colors.black38, fontFamily: 'Poppins', fontSize: 14)),
              ],
            ),
          );
        }
        return RefreshIndicator(
          color: const Color(0xFF1565C0),
          onRefresh: ctrl.fetchNotifications,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: ctrl.notifications.length,
            separatorBuilder: (context, value) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (_, i) => _NotifItem(
              data: ctrl.notifications[i],
              onTap: () => ctrl.markRead(ctrl.notifications[i]['id']),
            ),
          ),
        );
      }),
    );
  }
}

class _NotifItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  const _NotifItem({required this.data, required this.onTap});

  IconData _icon(String? type) {
    switch (type) {
      case 'denda': return Icons.warning_amber_rounded;
      case 'reply': return Icons.reply_rounded;
      case 'review': return Icons.star_rounded;
      case 'pinjam': return Icons.menu_book_rounded;
      case 'kembali': return Icons.assignment_return_outlined;
      case 'perpanjang_approved': return Icons.event_available_rounded;
      case 'perpanjang_rejected': return Icons.event_busy_rounded;
      default: return Icons.notifications_outlined;
    }
  }

  Color _color(String? type) {
    switch (type) {
      case 'denda': return Colors.redAccent;
      case 'reply': return const Color(0xFF1565C0);
      case 'review': return const Color(0xFFFFB300);
      case 'pinjam': return Colors.green;
      case 'kembali': return Colors.orange;
      case 'perpanjang_approved': return const Color(0xFF2E7D32);
      case 'perpanjang_rejected': return const Color(0xFFD32F2F);
      default: return Colors.grey;
    }
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      if (diff.inDays < 7) return '${diff.inDays} hari lalu';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) { return ''; }
  }

  @override
  Widget build(BuildContext context) {
    final isRead = data['is_read'] == true || data['is_read'] == 1;
    final type = data['type'] as String?;
    final color = _color(type);

    return InkWell(
      onTap: isRead ? null : onTap,
      child: Container(
        color: isRead ? Colors.white : const Color(0xFFF0F4FF),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon(type), color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['title'] ?? '',
                      style: TextStyle(
                          fontSize: 13, fontFamily: 'Poppins',
                          fontWeight: isRead ? FontWeight.w400 : FontWeight.w700,
                          color: Colors.black87)),
                  const SizedBox(height: 3),
                  Text(data['message'] ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.black54,
                          fontFamily: 'Poppins', height: 1.4)),
                  const SizedBox(height: 4),
                  Text(_formatDate(data['created_at'] ?? ''),
                      style: const TextStyle(fontSize: 10, color: Colors.black38,
                          fontFamily: 'Poppins')),
                ],
              ),
            ),
            if (!isRead)
              Container(
                width: 8, height: 8, margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                    color: Color(0xFF1565C0), shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}
