import 'package:flutter/material.dart';

class KategoriRow extends StatelessWidget {
  const KategoriRow({super.key});

  @override
  Widget build(BuildContext context) {
    final kategori = [
      {'icon': Icons.auto_stories, 'color': const Color(0xFF1565C0), 'label': 'Komik'},
      {'icon': Icons.menu_book, 'color': const Color(0xFF1565C0), 'label': 'Novel'},
      {'icon': Icons.article, 'color': const Color(0xFF1565C0), 'label': 'Cerpen'},
      {'icon': Icons.newspaper, 'color': const Color(0xFF1565C0), 'label': 'Majalah'},
    ];

    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: kategori.map((k) {
          final color = k['color'] as Color;
          return Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.3), width: 1.5),
                ),
                child: Icon(k['icon'] as IconData, color: color, size: 26),
              ),
              const SizedBox(height: 5),
              Text(k['label'] as String,
                  style: TextStyle(color: Colors.grey[600], fontSize: 11, fontFamily: 'Poppins')),
            ],
          );
        }).toList(),
      ),
    );
  }
}
