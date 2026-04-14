import 'package:ei_books/app/controllers/pembayaran_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'shared_widgets.dart';

class BukuCard extends StatelessWidget {
  final PembayaranController ctrl;
  const BukuCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final b = ctrl.buku.value;
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: cardDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: b['cover'] != null
                  ? Image.network(
                      b['cover'] as String,
                      width: 64, height: 84,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b['judul'] as String? ?? 'Loading...',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87)),
                  const SizedBox(height: 3),
                  Text(b['penulis'] as String? ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(b['status'] as String? ?? 'Terlambat',
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFD32F2F))),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Jatuh Tempo', style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                Text(b['jatuh_tempo'] as String? ?? '-',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFD32F2F))),
                const SizedBox(height: 8),
                Text('Denda', style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                Text('Rp ${formatRupiah(b['total_denda'] as int? ?? 0)}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFD32F2F))),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _placeholder() => Container(
    width: 64, height: 84,
    color: const Color(0xFF1A1A2E),
    child: const Center(child: Icon(Icons.menu_book, color: Colors.white24, size: 26)),
  );
}
