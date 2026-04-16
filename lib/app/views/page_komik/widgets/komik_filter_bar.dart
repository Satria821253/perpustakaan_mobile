import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/komik_controller.dart';

class KomikFilterBar extends StatelessWidget {
  const KomikFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<KomikController>();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(ctrl.filters.length, (i) {
              final active = i == ctrl.selectedFilter.value;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => ctrl.setFilter(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFF3D6BF5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ctrl.filters[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: active ? Colors.white : const Color(0xFF888888),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
