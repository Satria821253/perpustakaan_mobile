import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/detail_buku_controller.dart';

class DetailBottomBar extends StatelessWidget {
  final DetailBukuController ctrl;
  const DetailBottomBar({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tersedia = ctrl.tersedia;
      final hasPreview = ctrl.buku.value?.previewPdf != null;
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4)),
          ],
        ),
        child: Row(
          children: [
            // Chat
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.chat_bubble_outline_rounded,
                  color: Colors.grey[600], size: 22),
            ),
            const SizedBox(width: 10),

            // Baca Preview — hanya tampil jika ada preview PDF
            if (hasPreview) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: ctrl.bukaPdf,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1565C0),
                    side: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text('Baca\nPreview',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700,
                          height: 1.3, fontFamily: 'Poppins')),
                ),
              ),
              const SizedBox(width: 10),
            ],

            // Pinjam
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: tersedia ? ctrl.pinjamBuku : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      tersedia ? const Color(0xFF1565C0) : Colors.grey[400],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text(
                  tersedia ? 'Pinjam\nSekarang' : 'Tidak\nTersedia',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      height: 1.3, fontFamily: 'Poppins'),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
