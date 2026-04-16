import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/majalah_controller.dart';

class MajalahFilterBar extends StatelessWidget {
  const MajalahFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MajalahController>();
    return Container(
      height: 50,
      color: Colors.white,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: ctrl.filters.length,
          itemBuilder: (context, i) {
            final active = ctrl.selectedFilter.value == i;
            return GestureDetector(
              onTap: () => ctrl.setFilter(i),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFF00838F) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    ctrl.filters[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      color: active ? Colors.white : Colors.black54,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
