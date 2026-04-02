import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/detail_buku_controller.dart';

class DetailAppBar extends StatelessWidget {
  final DetailBukuController ctrl;
  const DetailAppBar({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            _CircleBtn(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Obx(() {
              final populer = ctrl.buku.value?.isPopuler ?? false;
              if (!populer) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6F00),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('Populer',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins')),
                  ],
                ),
              );
            }),
            const Spacer(),
            Obx(() => _CircleBtn(
              onTap: ctrl.toggleFavorit,
              child: Icon(
                ctrl.isFavorit.value ? Icons.bookmark : Icons.bookmark_border,
                color: ctrl.isFavorit.value ? const Color(0xFF1565C0) : Colors.white,
                size: 20,
              ),
            )),
            const SizedBox(width: 8),
            _CircleBtn(
              onTap: () {},
              child: const Icon(Icons.share_outlined, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _CircleBtn({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
