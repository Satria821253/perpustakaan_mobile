import 'package:ei_books/app/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = NotificationController.to;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ctrl.fetchNotifications(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: Obx(
          () => Text(
            ctrl.isSelectionMode.value
                ? '${ctrl.selectedIds.length} dipilih'
                : 'Notifikasi',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        elevation: 0,
        leading: Obx(
          () => ctrl.isSelectionMode.value
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: ctrl.toggleSelectionMode,
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
        ),
        actions: [
          Obx(() {
            if (ctrl.isSelectionMode.value) {
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.select_all),
                    onPressed: ctrl.selectAll,
                    tooltip: 'Pilih semua',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: ctrl.selectedIds.isNotEmpty
                        ? () => _showDeleteConfirmation(context, ctrl)
                        : null,
                    tooltip: 'Hapus yang dipilih',
                  ),
                ],
              );
            }
            return Row(
              children: [
                if (ctrl.notifications.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.checklist),
                    onPressed: ctrl.toggleSelectionMode,
                    tooltip: 'Pilih',
                  ),
                if (ctrl.notifications.any((n) => n['is_read'] == false))
                  TextButton(
                    onPressed: ctrl.markAllRead,
                    child: const Text(
                      'Tandai semua dibaca',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1565C0)),
          );
        }
        if (ctrl.notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 56,
                  color: Colors.black12,
                ),
                SizedBox(height: 12),
                Text(
                  'Belum ada notifikasi',
                  style: TextStyle(
                    color: Colors.black38,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                ),
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
            separatorBuilder: (context, value) =>
                const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (_, i) {
              final notif = ctrl.notifications[i];
              return Obx(
                () => _NotifItem(
                  data: notif,
                  isSelected: ctrl.selectedIds.contains(notif['id']),
                  isSelectionMode: ctrl.isSelectionMode.value,
                  onTap: () {
                    final id = notif['id'] as int?;
                    if (id == null) return;

                    if (ctrl.isSelectionMode.value) {
                      ctrl.toggleSelection(id);
                    } else {
                      ctrl.markRead(id);
                      Get.toNamed('/notification-detail', arguments: id);
                    }
                  },
                  onLongPress: () {
                    if (!ctrl.isSelectionMode.value) {
                      ctrl.toggleSelectionMode();
                      ctrl.toggleSelection(notif['id'] as int);
                    }
                  },
                  onCheckboxChanged: (value) {
                    ctrl.toggleSelection(notif['id'] as int);
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    NotificationController ctrl,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Hapus Notifikasi',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${ctrl.selectedIds.length} notifikasi yang dipilih?',
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ctrl.deleteSelected();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _NotifItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onLongPress;
  final ValueChanged<bool?>? onCheckboxChanged;

  const _NotifItem({
    required this.data,
    required this.onTap,
    this.isSelected = false,
    this.isSelectionMode = false,
    required this.onLongPress,
    this.onCheckboxChanged,
  });

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
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      if (diff.inDays < 7) return '${diff.inDays} hari lalu';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRead = data['is_read'] == true || data['is_read'] == 1;
    final type = data['type'] as String?;
    final color = _color(type);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        color: isRead ? Colors.white : const Color(0xFFF0F4FF),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSelectionMode)
              Checkbox(
                value: isSelected,
                onChanged: onCheckboxChanged,
                activeColor: const Color(0xFF1565C0),
              ),
            Container(
              width: 40,
              height: 40,
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
                  Text(
                    data['title'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: isRead ? FontWeight.w400 : FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    data['message'] ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontFamily: 'Poppins',
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(data['created_at'] ?? ''),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black38,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            if (!isRead && !isSelectionMode)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFF1565C0),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
