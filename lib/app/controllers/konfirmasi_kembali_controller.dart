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
      Get.snackbar('Error', 'Gagal memuat data peminjaman',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  bool get terlambat => detail.value?.terlambat ?? false;
  bool get adaDenda => detail.value?.adaDenda ?? false;
  int get hariTerlambat => detail.value?.hariTerlambat ?? 0;
  int get denda => detail.value?.denda ?? 0;
  int get saldoKoin => detail.value?.saldoKoin ?? 0;
  bool get koinCukup => detail.value?.koinCukup ?? false;

  void setMetode(String m) => metodePembayaran(m);

  Future<void> prosesKonfirmasi() async {
    isProses(true);
    try {
      if (adaDenda && detail.value?.dendaDibayar != true) {
        await _service.bayarDendaSebelumKembali(
          borrowingId: borrowingId,
          metode: metodePembayaran.value,
        );
      }
      final res = await _service.generateReturnCode(borrowingId);
      final kode = res['kode'] ?? res['return_code'] ?? res['code']?.toString() ?? '-';
      Get.offNamed('/kode-kembali', arguments: {
        'borrowingId': borrowingId,
        'kode': kode,
        'judulBuku': detail.value?.bookJudul ?? '-',
        'tanggalKembali': detail.value?.tanggalKembali ?? '-',
      });
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi kesalahan, coba lagi',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isProses(false);
    }
  }
}
