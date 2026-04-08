import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/borrowing_detail_model.dart';
import '../models/extension_request_model.dart';
import '../services/borrowing_service.dart';

class DetailPerpanjangController extends GetxController {
  final int borrowingId;
  DetailPerpanjangController({required this.borrowingId});

  final _service = BorrowingService();
  final isLoading = true.obs;
  final detail = Rxn<BorrowingDetailModel>();
  final requests = <ExtensionRequestModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    fetchAll();
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
