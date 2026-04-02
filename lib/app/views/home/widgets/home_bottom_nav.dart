import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';

class HomeBottomNav extends StatelessWidget {
  final HomeController ctrl;
  const HomeBottomNav({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.explore_outlined, 'label': 'Explore'},
      {'icon': Icons.menu_book_outlined, 'label': 'Buku Saya'},
      {'icon': Icons.history_outlined, 'label': 'Riwayat'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (i) {
                  final active = ctrl.currentNavIndex.value == i;
                  return GestureDetector(
                    onTap: () => ctrl.setNavIndex(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFF1565C0).withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            items[i]['icon'] as IconData,
                            color: active
                                ? const Color(0xFF1565C0)
                                : Colors.grey[500],
                            size: 24,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            items[i]['label'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: active
                                  ? const Color(0xFF1565C0)
                                  : Colors.grey[500],
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              )),
        ),
      ),
    );
  }
}
