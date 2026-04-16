import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class PsBottomAction extends StatelessWidget {
  final int borrowingId;
  final bool hasPendingRequest;

  const PsBottomAction({
    super.key,
    required this.borrowingId,
    this.hasPendingRequest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: hasPendingRequest
                  ? () {
                      Get.snackbar(
                        'Menunggu Persetujuan',
                        'Permintaan perpanjangan masih dalam proses peninjauan.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFFFF3CD),
                        colorText: const Color(0xFFF57C00),
                        margin: const EdgeInsets.all(16),
                      );
                    }
                  : () {
                      Get.offNamed(Routes.detailPerpanjang, arguments: borrowingId);
                    },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                backgroundColor: hasPendingRequest ? Colors.grey : null,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: hasPendingRequest
                      ? null
                      : const LinearGradient(
                          colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                  color: hasPendingRequest ? Colors.grey[300] : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    hasPendingRequest ? 'Menunggu Persetujuan' : 'Lihat Detail Perpanjangan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: hasPendingRequest ? Colors.grey[600] : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Get.offAllNamed(Routes.home),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Kembali ke Home',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
