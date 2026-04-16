import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KomikTopBar extends StatelessWidget {
  const KomikTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3D6BF5),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Komik',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 22),
            onPressed: () {
              Get.toNamed('/explore');
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
