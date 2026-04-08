import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/konfirmasi_reservasi_controller.dart';

class KrBottomAction extends StatelessWidget {
  final KonfirmasiReservasiController ctrl;
  const KrBottomAction({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, -3))
        ],
      ),
      child: Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ctrl.isLoading.value ? null : ctrl.konfirmasi,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: ctrl.isLoading.value
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5))
                  : const Text(
                      'Konfirmasi Pinjam',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins'),
                    ),
            ),
          )),
    );
  }
}
