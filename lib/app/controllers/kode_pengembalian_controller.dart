import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/borrowing_service.dart';

class KodePengembalianController extends GetxController {
  final String kode;
  final String judulBuku;
  final String tanggalKembali;
  final int borrowingId;

  KodePengembalianController({
    required this.kode,
    required this.judulBuku,
    required this.tanggalKembali,
    required this.borrowingId,
  });

  final _service = BorrowingService();

  final sudahDisalin = false.obs;
  final sisaDetik = 86400.obs;
  final isCekLoading = false.obs;
  final sudahDikonfirmasi = false.obs;
  Timer? _timer;
  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    _mulaiTimer();
    _mulaiPolling();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _pollingTimer?.cancel();
    super.onClose();
  }

  void _mulaiPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!sudahDikonfirmasi.value) _cekStatusSilent();
    });
  }

  Future<void> _cekStatusSilent() async {
    try {
      final status = await _service.checkBorrowingStatus(borrowingId);
      if (status == 'dikembalikan') {
        _pollingTimer?.cancel();
        _timer?.cancel();
        sudahDikonfirmasi(true);
        _tampilDialogKonfirmasi();
      }
    } catch (_) {}
  }

  void _mulaiTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (sisaDetik.value > 0) {
        sisaDetik.value--;
      } else {
        _timer?.cancel();
        Get.offAllNamed('/buku-saya');
      }
    });
  }

  String get timerLabel {
    final h = sisaDetik.value ~/ 3600;
    final m = (sisaDetik.value % 3600) ~/ 60;
    final s = sisaDetik.value % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get timerProgress => sisaDetik.value / 86400;
  bool get hampirExpired => sisaDetik.value < 3600;

  Future<void> cekStatus() async {
    isCekLoading(true);
    try {
      final status = await _service.checkBorrowingStatus(borrowingId);
      if (status == 'dikembalikan') {
        _pollingTimer?.cancel();
        _timer?.cancel();
        sudahDikonfirmasi(true);
        _tampilDialogKonfirmasi();
      } else {
        Get.snackbar(
          'Belum Dikonfirmasi',
          'Kode belum diproses petugas, coba beberapa saat lagi',
          backgroundColor: const Color(0xFFF57C00),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (_) {
      Get.snackbar('Error', 'Gagal cek status',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isCekLoading(false);
    }
  }

  void _tampilDialogKonfirmasi() {
    Future.delayed(const Duration(seconds: 2), () {
      Get.toNamed('/detail-pengembalian', arguments: borrowingId);
    });
  }

  void salinKode() {
    Clipboard.setData(ClipboardData(text: kode));
    sudahDisalin(true);
    Future.delayed(const Duration(seconds: 2), () => sudahDisalin(false));
    Get.snackbar(
      'Disalin!',
      'Kode pengembalian berhasil disalin',
      backgroundColor: const Color(0xFF1565C0),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  void selesai() {
    _timer?.cancel();
    Get.offAllNamed('/home');
  }
}
