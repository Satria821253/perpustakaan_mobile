import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/borrowing_detail_model.dart';
import '../models/extension_request_model.dart';
import '../services/borrowing_service.dart';

class PerpanjangController extends GetxController {
  final int borrowingId;
  PerpanjangController({required this.borrowingId});

  final _service = BorrowingService();
  final isLoading = true.obs;
  final isKirim = false.obs;
  final durasiHari = 7.obs;
  final alasan = ''.obs;
  final detail = Rxn<BorrowingDetailModel>();
  final riwayat = <ExtensionRequestModel>[].obs;

  static const pilihanDurasi = [7, 14, 21];
  static int slotUntuk(int hari) => hari ~/ 7;

  static const _bulan = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];

  int get sisaSlot => 3 - (detail.value?.jumlahPerpanjangan ?? 0);
  bool slotCukup(int hari) => slotUntuk(hari) <= sisaSlot;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading(true);
    try {
      final results = await Future.wait([
        _service.getBorrowingDetail(borrowingId),
        _service.getExtensionRequests(borrowingId),
      ]);
      detail.value = results[0] as BorrowingDetailModel;
      riwayat.value = (results[1] as List<Map<String, dynamic>>)
          .map((e) => ExtensionRequestModel.fromJson(e))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data peminjaman',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  String get tanggalBaruSetelahPerpanjang {
    final raw = detail.value?.tanggalKembali ?? DateTime.now().toIso8601String();
    try {
      final base = DateTime.parse(raw);
      final baru = base.add(Duration(days: durasiHari.value));
      return '${baru.day} ${_bulan[baru.month - 1]} ${baru.year}';
    } catch (_) {
      return '-';
    }
  }

  void setDurasi(int d) => durasiHari(d);
  void setAlasan(String a) => alasan(a);

  Future<void> kirimRequest() async {
    if (alasan.value.trim().isEmpty) {
      Get.snackbar('Perhatian', 'Mohon isi alasan perpanjangan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900]);
      return;
    }
    if (!slotCukup(durasiHari.value)) {
      Get.snackbar('Perhatian', 'Sisa slot perpanjangan tidak cukup',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900]);
      return;
    }
    isKirim(true);
    try {
      await _service.requestExtension(
          borrowingId, durasiHari.value, alasan.value.trim());
      await Get.dialog(
        PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.hourglass_top_rounded,
                      color: Color(0xFF1565C0), size: 36),
                ),
                const SizedBox(height: 16),
                const Text('Permintaan Terkirim!',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800,
                        color: Colors.black87, fontFamily: 'Poppins')),
                const SizedBox(height: 8),
                const Text(
                  'Permintaan perpanjangan kamu sedang menunggu persetujuan petugas perpustakaan. Kamu akan mendapat notifikasi setelah diproses.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13, color: Colors.black54,
                      height: 1.5, fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // tutup dialog
                      Get.back(); // kembali ke halaman sebelumnya
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: const Text('Oke, Mengerti',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins')),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isKirim(false);
    }
  }
}
