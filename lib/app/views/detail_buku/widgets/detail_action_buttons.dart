import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/detail_buku_controller.dart';

class DetailActionButtons extends StatelessWidget {
  final DetailBukuController ctrl;
  const DetailActionButtons({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tersedia = ctrl.tersedia;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            // Chat
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.chat_bubble_outline_rounded,
                  color: Colors.grey[600], size: 22),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: OutlinedButton.icon(
                onPressed: ctrl.bukaPdf,
                icon: const Icon(Icons.menu_book_rounded, size: 16),
                label: const Text('Baca Preview'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1565C0),
                  side: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins'),
                ),
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: tersedia ? ctrl.pinjamBuku : null,
                icon: Icon(
                  tersedia ? Icons.bookmark_add_rounded : Icons.block_rounded,
                  size: 16,
                ),
                label: Text(tersedia ? 'Pinjam Sekarang' : 'Tidak Tersedia'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      tersedia ? const Color(0xFF1565C0) : Colors.grey[400],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins'),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
