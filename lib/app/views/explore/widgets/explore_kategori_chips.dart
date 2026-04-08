import 'package:ei_books/app/controllers/explore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreKategoriChips extends StatelessWidget {
  final ExploreController ctrl;
  const ExploreKategoriChips({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = ['Semua', ...ctrl.categories.map((c) => c['name'] as String)];
      final activeIdx = ctrl.selectedKategoriIdx.value;
      return Container(
        height: 52,
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: List.generate(items.length, (i) {
              final active = activeIdx == i;
              return GestureDetector(
                onTap: () => ctrl.setKategori(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFF1565C0) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? const Color(0xFF1565C0) : Colors.grey.shade300,
                    ),
                    boxShadow: active
                        ? [
                            BoxShadow(
                                color: const Color(0xFF1565C0).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3))
                          ]
                        : [],
                  ),
                  child: Text(
                    items[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                      color: active ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}
