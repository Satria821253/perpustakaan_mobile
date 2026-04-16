import 'package:ei_books/app/views/page_komik/page_komik.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class KategoriRow extends StatelessWidget {
  const KategoriRow({super.key});

  @override
  Widget build(BuildContext context) {
    final kategori = [
      {
        'icon': Icons.auto_stories,
        'color': const Color(0xFF1565C0),
        'label': 'Komik',
      },
      {
        'icon': Icons.menu_book,
        'color': const Color(0xFF1565C0),
        'label': 'Novel',
      },
      {
        'icon': Icons.article,
        'color': const Color(0xFF1565C0),
        'label': 'Cerpen',
      },
      {
        'icon': Icons.newspaper,
        'color': const Color(0xFF1565C0),
        'label': 'Majalah',
      },
    ];

    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: kategori.asMap().entries.map((entry) {
          final k = entry.value;
          final color = k['color'] as Color;
          final label = k['label'] as String;
          return GestureDetector(
            onTap: () {
              if (label == 'Komik') {
                Get.to(() => const KomikPage());
              }
            },
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(k['icon'] as IconData, color: color, size: 26),
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
