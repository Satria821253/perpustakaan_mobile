import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/konfirmasi_kembali_controller.dart';

class KkBottomCta extends StatelessWidget {
  final KonfirmasiKembaliController ctrl;
  const KkBottomCta({super.key, required this.ctrl});

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
      child: Obx(() => SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed:
                  ctrl.isProses.value ? null : ctrl.prosesKonfirmasi,
              icon: ctrl.isProses.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.assignment_return_rounded, size: 18),
              label: Text(
                  ctrl.isProses.value ? 'Memproses...' : 'Proses Pengembalian'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ctrl.terlambat
                    ? const Color(0xFFD32F2F)
                    : const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          )),
    );
  }
}
