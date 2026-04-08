import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/detail_peminjaman_controller.dart';
import '../../../routes/app_pages.dart';

class DpBottomActions extends StatelessWidget {
  final DetailPeminjamanController ctrl;
  const DpBottomActions({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
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
          if (ctrl.bisaPerpanjang) ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    Get.toNamed(Routes.perpanjang, arguments: ctrl.borrowingId),
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
          if (!ctrl.bisaPerpanjang) ...[
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
            flex: ctrl.bisaPerpanjang ? 1 : 2,
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
  }
}
