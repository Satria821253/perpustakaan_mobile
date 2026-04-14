import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/borrowing_detail_model.dart';
import '../services/borrowing_service.dart';
import '../widgets/overlays/animation_overlay.dart';

class DetailPeminjamanController extends GetxController {
  final int borrowingId;
  DetailPeminjamanController({required this.borrowingId});

  final _service = BorrowingService();
  final isLoading = true.obs;
  final detail = Rxn<BorrowingDetailModel>();
  final hasShownAnimation = false.obs; // Track apakah animasi sudah ditampilkan

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    fetchDetail();
  }

  void _startPolling() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!isClosed && detail.value?.status == 'pending') {
        fetchDetail();
        _startPolling();
      }
    });
  }

  Future<void> fetchDetail() async {
    isLoading(true);
    try {
      final oldStatus = detail.value?.status;
      detail.value = await _service.getBorrowingDetail(borrowingId);
      final newStatus = detail.value?.status;

      if (!hasShownAnimation.value && oldStatus == 'pending' && newStatus != null && newStatus != 'pending') {
        hasShownAnimation(true);
        if (newStatus == 'approved' || newStatus == 'dipinjam') {
          AnimationOverlay.showApproved(
            title: 'Peminjaman Disetujui!',
            message: 'Peminjaman disetujui! Silakan ambil buku di perpustakaan.',
          );
        } else if (newStatus == 'rejected' || newStatus == 'ditolak') {
          AnimationOverlay.showDenied(
            title: 'Peminjaman Ditolak',
            message: 'Maaf, peminjaman Anda tidak dapat diproses.',
          );
        }
      }

      // Mulai polling hanya jika status masih pending
      if (newStatus == 'pending') _startPolling();
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
  bool get dendaDibayar => detail.value?.dendaDibayar ?? false;
  bool get terlambatBelumBayar => terlambat && !dendaDibayar;
  bool get bisaPerpanjang =>
      !sudahDikembalikan &&
      !terlambatBelumBayar &&
      (detail.value?.jumlahPerpanjangan ?? 0) < 3;

  String get statusLabel {
    if (terlambat && dendaDibayar) return 'Denda Lunas';
    if (terlambat) return 'Terlambat';
    if (sudahDikembalikan) return 'Dikembalikan';
    final hari = detail.value?.hariTersisa ?? 0;
    if (hari <= 3) return 'Segera Jatuh Tempo';
    return 'Dipinjam';
  }

  Color get statusColor {
    if (terlambat && dendaDibayar) return const Color(0xFF2E7D32);
    if (terlambat) return const Color(0xFFD32F2F);
    if (sudahDikembalikan) return const Color(0xFF2E7D32);
    final hari = detail.value?.hariTersisa ?? 0;
    if (hari <= 3) return const Color(0xFFF57C00);
    return const Color(0xFF1565C0);
  }
}
