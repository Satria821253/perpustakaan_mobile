import 'package:ei_books/app/controllers/explore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreHeader extends StatelessWidget {
  final ExploreController ctrl;
  const ExploreHeader({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search_rounded, color: Colors.grey[400], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: ctrl.setSearch,
                      decoration: InputDecoration(
                        hintText: 'Cari judul, penulis...',
                        hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            fontFamily: 'Poppins'),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(() => GestureDetector(
            onTap: () => ctrl.openFilterSheet(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: ctrl.showFilter.value || ctrl.hasActiveFilter
                    ? const Color(0xFF1565C0)
                    : const Color(0xFFF4F6FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: ctrl.showFilter.value || ctrl.hasActiveFilter
                    ? Colors.white
                    : Colors.grey[600],
                size: 20,
              ),
            ),
          )),
        ],
      ),
    );
  }
}
