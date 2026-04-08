import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/perpanjang_controller.dart';
import 'widgets/pp_info_buku_card.dart';
import 'widgets/pp_pilih_durasi.dart';
import 'widgets/pp_tanggal_baru.dart';
import 'widgets/pp_alasan_peringatan.dart';

class PerpanjangScreen extends StatelessWidget {
  final int borrowingId;
  const PerpanjangScreen({super.key, required this.borrowingId});

  @override
  Widget build(BuildContext context) {
    Get.delete<PerpanjangController>(tag: 'perpanjang_$borrowingId', force: true);
    final ctrl = Get.put(
      PerpanjangController(borrowingId: borrowingId),
      tag: 'perpanjang_$borrowingId',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text('Perpanjang Peminjaman',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)));
        }
        if (ctrl.detail.value == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                const Text('Gagal memuat data'),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: ctrl.fetchDetail,
                    child: const Text('Coba Lagi')),
              ],
            ),
          );
        }
        final d = ctrl.detail.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PpInfoBukuCard(ctrl: ctrl, d: d),
              const SizedBox(height: 14),
              PpPilihDurasi(ctrl: ctrl),
              const SizedBox(height: 14),
              PpTanggalBaru(ctrl: ctrl),
              const SizedBox(height: 14),
              PpAlasanField(ctrl: ctrl),
              const SizedBox(height: 14),
              const PpPeringatan(),
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        color: Colors.white,
        child: Obx(() => SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: ctrl.isKirim.value ? null : ctrl.kirimRequest,
                icon: ctrl.isKirim.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(
                    ctrl.isKirim.value ? 'Mengirim...' : 'Kirim Permintaan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            )),
      ),
    );
  }
}
