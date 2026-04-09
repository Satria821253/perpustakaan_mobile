import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/borrowing_detail_model.dart';
import '../models/extension_request_model.dart';
import '../services/borrowing_service.dart';
import '../widgets/overlays/transaction_overlays.dart';

class DetailPerpanjangController extends GetxController {
  final int borrowingId;
  DetailPerpanjangController({required this.borrowingId});

  final _service = BorrowingService();
  final isLoading = true.obs;
  final detail = Rxn<BorrowingDetailModel>();
  final requests = <ExtensionRequestModel>[].obs;
  final isPolling = false.obs;
  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    fetchAll();
    _startPolling();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  void _startPolling() {
    // Cek apakah ada request yang pending
    if (requests.any((r) => r.status == 'pending')) {
      isPolling(true);
      // Polling setiap 10 detik untuk cek status perpanjangan
      _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
        _checkStatusSilent();
      });
    }
  }

  Future<void> _checkStatusSilent() async {
    try {
      final results = await Future.wait([
        _service.getBorrowingDetail(borrowingId),
        _service.getExtensionRequests(borrowingId),
      ]);
      
      final oldRequests = requests.toList();
      detail.value = results[0] as BorrowingDetailModel;
      final newRequests = (results[1] as List<Map<String, dynamic>>)
          .map((e) => ExtensionRequestModel.fromJson(e))
          .toList();
      
      // Check if there's a new status change
      if (oldRequests.isNotEmpty && newRequests.isNotEmpty) {
        final latestRequest = newRequests.first;
        final oldLatest = oldRequests.first;
        
        // Show animation if status changed from pending to approved/rejected
        if (oldLatest.status == 'pending' && latestRequest.status != 'pending') {
          _pollingTimer?.cancel(); // Stop polling setelah ada hasil
          isPolling(false);
          
          if (latestRequest.status == 'approved') {
            PerpanjanganOverlay.showApproved(
              message: 'Perpanjangan ${latestRequest.durasiHari} hari telah disetujui.',
            );
          } else if (latestRequest.status == 'rejected') {
            PerpanjanganOverlay.showDenied(
              message: latestRequest.catatanPetugas ?? 'Perpanjangan tidak dapat diproses.',
            );
          }
        }
      }
      
      requests.value = newRequests;
    } catch (e) {
      // Silent fail untuk polling
    }
  }

  Future<void> fetchAll() async {
    isLoading(true);
    try {
      final results = await Future.wait([
        _service.getBorrowingDetail(borrowingId),
        _service.getExtensionRequests(borrowingId),
      ]);
      
      detail.value = results[0] as BorrowingDetailModel;
      requests.value = (results[1] as List<Map<String, dynamic>>)
          .map((e) => ExtensionRequestModel.fromJson(e))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'approved': return const Color(0xFF2E7D32);
      case 'rejected': return const Color(0xFFD32F2F);
      default: return const Color(0xFFF57C00);
    }
  }

  String statusLabel(String status) {
    switch (status) {
      case 'approved': return 'Disetujui';
      case 'rejected': return 'Ditolak';
      default: return 'Menunggu';
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case 'approved': return Icons.check_circle_rounded;
      case 'rejected': return Icons.cancel_rounded;
      default: return Icons.hourglass_top_rounded;
    }
  }
}
