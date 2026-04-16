import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/novel_controller.dart';

class NovelFilterBar extends StatelessWidget {
  const NovelFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NovelController>();

    return Container(
      color: Colors.white,
      child: Obx(() {
        if (ctrl.filters.isEmpty) {
          return const SizedBox(height: 50);
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: List.generate(ctrl.filters.length, (i) {
              final isSelected = ctrl.selectedFilter.value == i;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => ctrl.setFilter(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1565C0)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1565C0)
                            : const Color(0xFFE0E0E0),
                      ),
                    ),
                    child: Text(
                      ctrl.filters[i],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
