import 'package:flutter/material.dart';

class BpMoreOptionsSheet extends StatelessWidget {
  const BpMoreOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      (Icons.bookmark_border_rounded, 'Tambah Penanda'),
      (Icons.share_rounded, 'Bagikan Buku'),
      (Icons.report_outlined, 'Laporkan Masalah'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          ...options.map((opt) => ListTile(
                leading: Icon(opt.$1, color: const Color(0xFF4361EE)),
                title: Text(opt.$2,
                    style: const TextStyle(fontFamily: 'Poppins')),
                onTap: () => Navigator.pop(context),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
