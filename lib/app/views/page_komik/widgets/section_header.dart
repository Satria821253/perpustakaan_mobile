import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text(
            'Lihat semua',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF3D6BF5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
