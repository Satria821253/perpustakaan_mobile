import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/kode_pengembalian_controller.dart';
import '../../../controllers/buku_saya_controller.dart';

class KpBottomAction extends StatelessWidget {
  final KodePengembalianController ctrl;
  const KpBottomAction({super.key, required this.ctrl});

  void _selesai() {
    ctrl.selesai(); // offAllNamed('/home')
    Future.delayed(const Duration(milliseconds: 400), () {
      try {
        if (Get.isRegistered<BukuSayaController>()) {
          Get.find<BukuSayaController>().selectedTab(2); // tab Selesai
        }
      } catch (_) {}
    });
  }

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
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: _selesai,
          icon: const Icon(Icons.home_rounded, size: 18),
          label: const Text('Kembali ke Beranda'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
