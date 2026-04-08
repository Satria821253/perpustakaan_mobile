import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/book_detail_service.dart';

class BpLockedOverlay extends StatelessWidget {
  final int bookId;
  final int totalPages;
  final VoidCallback? onBack;

  const BpLockedOverlay({
    super.key,
    required this.bookId,
    this.totalPages = 0,
    this.onBack,
  });

  Future<void> _pinjam() async {
    try {
      final service = BookDetailService()..onInit();
      final buku = await service.getDetail(bookId);
      // offNamed replace preview di stack, sehingga back dari konfirmasi → detail
      Get.offNamed('/konfirmasi-reservasi', arguments: buku);
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Tidak dapat memuat data buku',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEEEE),
        colorText: const Color(0xFFE63946),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blur + dim
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(color: Colors.black.withValues(alpha: 0.45)),
        ),

        // Centered card
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lock icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEF0FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_rounded,
                        color: Color(0xFF4361EE), size: 32),
                  ),
                  const SizedBox(height: 14),

                  // Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEEE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Preview Berakhir',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE63946),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Lanjut Baca Ceritanya?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                          fontFamily: 'Poppins',
                          height: 1.5),
                      children: [
                        const TextSpan(text: 'Kamu sudah membaca '),
                        TextSpan(
                          text: '$totalPages halaman',
                          style: const TextStyle(
                            color: Color(0xFF4361EE),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                            text:
                                ' preview.\nPinjam buku ini untuk lanjut membaca.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pinjam button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _pinjam,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4361EE),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'Pinjam Sekarang',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tutup overlay
                  TextButton(
                    onPressed: onBack ?? () => Get.back(),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF888888),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
