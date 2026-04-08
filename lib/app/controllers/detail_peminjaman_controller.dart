import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/borrowing_detail_model.dart';
import '../services/borrowing_service.dart';

class DetailPeminjamanController extends GetxController {
  final int borrowingId;
  DetailPeminjamanController({required this.borrowingId});

  final _service = BorrowingService();
  final isLoading = true.obs;
  final detail = Rxn<BorrowingDetailModel>();

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading(true);
    try {
      detail.value = await _service.getBorrowingDetail(borrowingId);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail peminjaman',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  String get status => detail.value?.status ?? '';
  bool get terlambat => detail.value?.terlambat ?? false;
  bool get sudahDikembalikan => detail.value?.sudahDikembalikan ?? false;
  bool get adaDenda => detail.value?.adaDenda ?? false;
  bool get bisaPerpanjang =>
      !sudahDikembalikan && (detail.value?.jumlahPerpanjangan ?? 0) < 3;

  String get statusLabel {
    if (terlambat) return 'Terlambat';
    if (sudahDikembalikan) return 'Dikembalikan';
    final hari = detail.value?.hariTersisa ?? 0;
    if (hari <= 3) return 'Segera Jatuh Tempo';
    return 'Dipinjam';
  }

  Color get statusColor {
    if (terlambat) return const Color(0xFFD32F2F);
    if (sudahDikembalikan) return const Color(0xFF2E7D32);
    final hari = detail.value?.hariTersisa ?? 0;
    if (hari <= 3) return const Color(0xFFF57C00);
    return const Color(0xFF1565C0);
  }
}
