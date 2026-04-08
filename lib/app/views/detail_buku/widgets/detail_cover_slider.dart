import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/detail_buku_controller.dart';

class DetailCoverSlider extends StatelessWidget {
  final DetailBukuController ctrl;
  const DetailCoverSlider({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final buku = ctrl.buku.value;
      return SizedBox(
        height: 320,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover
            buku?.coverImage != null
                ? Image.network(
                    buku!.coverImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => _placeholder(),
                  )
                : _placeholder(),

            // Overlay tidak tersedia
            if (buku != null && !buku.tersedia)
              Container(
                color: Colors.black.withValues(alpha: 0.55),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Tidak Tersedia',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),

            // Gradient bawah
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.white],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _placeholder() => Container(
        color: const Color(0xFF1A1A2E),
        child: const Center(
            child: Icon(Icons.menu_book, color: Colors.white10, size: 80)),
      );
}
