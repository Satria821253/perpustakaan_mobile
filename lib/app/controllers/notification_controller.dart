import 'dart:async';
import 'package:get/get.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();

  final _service = NotificationService();

  final unreadCount = 0.obs;
  final notifications = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final selectedIds = <int>{}.obs;
  final isSelectionMode = false.obs;

  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    fetchUnreadCount();
    _startPolling();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchUnreadCount();
    });
  }

  Future<void> fetchUnreadCount() async {
    try {
      unreadCount.value = await _service.getUnreadCount();
    } catch (_) {}
  }

  Future<void> fetchNotifications() async {
    isLoading(true);
    try {
      notifications.value = await _service.getNotifications();
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> markRead(int id) async {
    try {
      await _service.markRead(id);
      final idx = notifications.indexWhere((n) => n['id'] == id);
      if (idx != -1) {
        notifications[idx] = {...notifications[idx], 'is_read': true};
        notifications.refresh();
      }
      await fetchUnreadCount();
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      await _service.markAllRead();
      notifications.value = notifications
          .map((n) => {...n, 'is_read': true})
          .toList();
      unreadCount.value = 0;
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void toggleSelection(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void toggleSelectionMode() {
    isSelectionMode.value = !isSelectionMode.value;
    if (!isSelectionMode.value) {
      selectedIds.clear();
    }
  }

  void selectAll() {
    selectedIds.clear();
    for (final notif in notifications) {
      final id = notif['id'] as int?;
      if (id != null) {
        selectedIds.add(id);
      }
    }
  }

  void deselectAll() {
    selectedIds.clear();
  }

  Future<void> deleteSelected() async {
    if (selectedIds.isEmpty) return;

    try {
      isLoading(true);
      await _service.deleteMultiple(selectedIds.toList());
      notifications.removeWhere((n) => selectedIds.contains(n['id']));
      selectedIds.clear();
      isSelectionMode.value = false;
      await fetchUnreadCount();
      Get.snackbar(
        'Berhasil',
        'Notifikasi berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteSingle(int id) async {
    try {
      await _service.deleteNotification(id);
      notifications.removeWhere((n) => n['id'] == id);
      await fetchUnreadCount();
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
