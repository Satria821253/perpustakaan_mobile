import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/detail_peminjaman_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/perpanjangan_helper.dart';

class DpBottomActions extends StatelessWidget {
  final DetailPeminjamanController ctrl;
  const DpBottomActions({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final detail = ctrl.detail.value;
      final sudahMaxPerpanjangan = detail != null && detail.jumlahPerpanjangan >= 3;

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 16,
                offset: const Offset(0, -4))
          ],
        ),
        child: Row(
          children: [
            if (ctrl.bisaPerpanjang && !sudahMaxPerpanjangan) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _handlePerpanjang(ctrl),
                  icon: const Icon(Icons.event_repeat_rounded, size: 16),
                  label: const Text('Perpanjang'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1565C0),
                    side: const BorderSide(color: Color(0xFF1565C0)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            if (!ctrl.bisaPerpanjang || sudahMaxPerpanjangan) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Get.toNamed(Routes.detailPerpanjang,
                      arguments: ctrl.borrowingId),
                  icon: const Icon(Icons.history_rounded, size: 16),
                  label: const Text('Riwayat Perpanjang'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1565C0),
                    side: const BorderSide(color: Color(0xFF1565C0)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: (ctrl.bisaPerpanjang && !sudahMaxPerpanjangan) ? 1 : 2,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed(
                    Routes.konfirmasiKembali,
                    arguments: ctrl.borrowingId),
                icon: const Icon(Icons.assignment_return_rounded, size: 16),
                label: const Text('Kembalikan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ctrl.terlambat
                      ? const Color(0xFFD32F2F)
                      : const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _handlePerpanjang(DetailPeminjamanController ctrl) {
    final detail = ctrl.detail.value;
    if (detail == null) return;

    print('🔍 DEBUG Detail Peminjaman - Tombol Perpanjang diklik');
    print('   - Borrowing ID: ${ctrl.borrowingId}');
    print('   - Judul Buku: ${detail.bookJudul}');
    print('   - Jumlah Perpanjangan: ${detail.jumlahPerpanjangan} / 3');
    print('   - Sudah Dikembalikan: ${detail.sudahDikembalikan}');
    print('');

    // Cek apakah bisa perpanjang (akan tampilkan dialog jika tidak bisa)
    if (!PerpanjanganHelper.canExtend(
      jumlahPerpanjangan: detail.jumlahPerpanjangan,
      borrowingId: ctrl.borrowingId,
    )) {
      print('   ❌ Tidak bisa perpanjang (sudah max 3x)');
      print('');
      return;
    }

    // Cek apakah sudah dikembalikan
    if (detail.sudahDikembalikan) {
      print('   ❌ Tidak bisa perpanjang (sudah dikembalikan)');
      print('');
      Get.snackbar(
        'Tidak Bisa Perpanjang',
        'Buku sudah dikembalikan',
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[900],
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Lanjut ke halaman perpanjang
    print('   ✅ Bisa perpanjang, navigasi ke halaman perpanjang');
    print('');
    Get.toNamed(Routes.perpanjang, arguments: ctrl.borrowingId);
  }
}
