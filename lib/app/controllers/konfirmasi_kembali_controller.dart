import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/borrowing_detail_model.dart';
import '../services/borrowing_service.dart';

class KonfirmasiKembaliController extends GetxController {
  final int borrowingId;
  KonfirmasiKembaliController({required this.borrowingId});

  final _service = BorrowingService();
  final isLoading = true.obs;
  final isProses = false.obs;
  final metodePembayaran = 'koin'.obs;
  final detail = Rxn<BorrowingDetailModel>();

  // Warning dari generate return code
  final hasWarning = false.obs;
  final warningMessage = ''.obs;
  final warningFineAmount = 0.obs;
  final warningDaysLate = 0.obs;

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
      Get.snackbar(
        'Error',
        'Gagal memuat data peminjaman',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  bool get terlambat => detail.value?.terlambat ?? false;
  bool get adaDenda =>
      (detail.value?.adaDenda ?? false) &&
      !(detail.value?.dendaDibayar ?? false);
  int get hariTerlambat => detail.value?.hariTerlambat ?? 0;
  int get denda => detail.value?.denda ?? 0;
  int get saldoKoin => detail.value?.saldoKoin ?? 0;
  bool get koinCukup => detail.value?.koinCukup ?? false;

  void setMetode(String m) => metodePembayaran(m);

  bool canPayWithKoin() {
    // Koin hanya bisa untuk denda keterlambatan, bukan untuk denda kerusakan
    // Jika ada warning tentang denda, periksa apakah sudah dibayar
    if (hasWarning.value && warningFineAmount.value > 0) {
      return false; // Ada denda yang harus dibayar, tidak bisa koin
    }
    return true;
  }

  Future<void> prosesKonfirmasi() async {
    isProses(true);
    hasWarning(false);
    warningMessage('');
    warningFineAmount(0);
    warningDaysLate(0);

    try {
      // Generate return code dan terima warning jika ada
      debugPrint(
        '[KonfirmasiKembali] Generate return code untuk borrowingId: $borrowingId',
      );
      final res = await _service.generateReturnCode(borrowingId);
      debugPrint('[KonfirmasiKembali] Response: $res');

      // Cek apakah ada warning dari response
      final warning = res['warning'] as Map<String, dynamic>?;
      if (warning != null) {
        hasWarning(true);
        warningMessage(warning['info'] ?? 'Ada denda yang perlu dibayar');
        warningFineAmount(warning['fine_amount'] as int? ?? 0);
        warningDaysLate(warning['days_late'] as int? ?? 0);

        debugPrint('[KonfirmasiKembali] Warning: $warning');

        // Jika ada denda belum dibayar, arahkan ke pembayaran
        if (warning['has_unpaid_fine'] == true) {
          final fineAmount = warningFineAmount.value;
          final paymentOptions =
              warning['payment_options'] as List<String>? ?? [];
          final canUseKoin = paymentOptions.contains('koin');

          // Tampilkan info denda dan arahkan ke pembayaran
          if (canUseKoin) {
            // Bisa pilih koin atau pembayaran lain
            Get.snackbar(
              'Denda Keterlambatan',
              'Anda memiliki denda Rp ${_formatRupiah(fineAmount)} untuk $warningDaysLate hari terlambat.\nPilih metode pembayaran di langkah berikutnya.',
              backgroundColor: Colors.orange[100],
              colorText: Colors.orange[900],
              duration: const Duration(seconds: 4),
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            // Tidak bisa koin, harus Bayar Denda
            Get.snackbar(
              'Denda Keterlambatan',
              'Anda memiliki denda Rp ${_formatRupiah(fineAmount)} untuk $warningDaysLate hari terlambat.\nSilakan Bayar Denda terlebih dahulu.',
              backgroundColor: Colors.red[100],
              colorText: Colors.red[900],
              duration: const Duration(seconds: 4),
              snackPosition: SnackPosition.BOTTOM,
            );
            isProses(false);
            // Arahkan ke halaman pembayaran
            Get.toNamed('/pembayaran', arguments: borrowingId);
            return;
          }
        }
      }

      final kode =
          res['kode'] ?? res['return_code'] ?? res['code']?.toString() ?? '-';
      Get.offNamed(
        '/kode-kembali',
        arguments: {
          'borrowingId': borrowingId,
          'kode': kode,
          'judulBuku': detail.value?.bookJudul ?? '-',
          'tanggalKembali': detail.value?.tanggalKembali ?? '-',
          'hasWarning': hasWarning.value,
          'warningMessage': warningMessage.value,
          'fineAmount': warningFineAmount.value,
        },
      );
    } catch (e, stack) {
      debugPrint('[KonfirmasiKembali] Error: $e');
      debugPrint('[KonfirmasiKembali] Stack: $stack');
      final errMsg = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar(
        'Gagal',
        errMsg.isNotEmpty ? errMsg : 'Terjadi kesalahan, coba lagi',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProses(false);
    }
  }

  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
