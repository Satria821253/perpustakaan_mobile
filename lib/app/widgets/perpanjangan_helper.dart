import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerpanjanganHelper {
  /// Cek apakah bisa perpanjang dan tampilkan error jika tidak bisa
  /// Return true jika bisa perpanjang, false jika tidak
  static bool canExtend({
    required int jumlahPerpanjangan,
    required int borrowingId,
    bool showDialog = true,
  }) {
    // Cek apakah sudah max perpanjangan (3x)
    if (jumlahPerpanjangan >= 3) {
      if (showDialog) {
        showMaxPerpanjanganDialog(borrowingId);
      }
      return false;
    }
    return true;
  }

  /// Tampilkan dialog max perpanjangan
  static void showMaxPerpanjanganDialog(int borrowingId) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.block_rounded,
                color: Color(0xFFD32F2F),
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Perpanjangan Maksimal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Kamu sudah melakukan perpanjangan sebanyak 3 kali (maksimal). Silakan kembalikan buku terlebih dahulu.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/konfirmasi-kembali', arguments: borrowingId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Kembalikan',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
  }
}
