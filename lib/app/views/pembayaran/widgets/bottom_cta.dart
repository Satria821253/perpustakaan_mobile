import 'package:ei_books/app/controllers/pembayaran_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BottomCTA extends StatelessWidget {
  final PembayaranController ctrl;
  const BottomCTA({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bisa = ctrl.bisaKonfirmasi;
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 16, offset: const Offset(0, -4))],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: bisa && !ctrl.isLoading.value ? ctrl.konfirmasi : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: bisa ? const Color(0xFF1565C0) : Colors.grey[300],
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            child: ctrl.isLoading.value
                ? const SizedBox(width: 22, height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Text('Konfirmasi'),
          ),
        ),
      );
    });
  }
}
