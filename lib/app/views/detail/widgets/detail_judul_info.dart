import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/detail_buku_controller.dart';
import '../../../controllers/home_controller.dart';

class DetailJudulInfo extends StatelessWidget {
  final DetailBukuController ctrl;
  const DetailJudulInfo({super.key, required this.ctrl});

  String _formatNum(int val) {
    if (val >= 1000000) return '${(val / 1000000).toStringAsFixed(1)}jt';
    if (val >= 1000) return '${(val / 1000).toStringAsFixed(0)}rb';
    return '$val';
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF1565C0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final buku = ctrl.buku.value!;
    final tersedia = buku.tersedia;
    final homeCtrl = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    final categories = homeCtrl?.categories ?? [];
    final genres = homeCtrl?.genres ?? [];

    // Lookup kategori
    final catData = categories.firstWhereOrNull((c) => c['name'] == buku.kategori);
    final catColor = catData != null ? _parseColor(catData['color'] ?? '#1565C0') : const Color(0xFF1565C0);

    // Lookup genre
    final genreNames = buku.genre.split(',').map((g) => g.trim()).where((g) => g.isNotEmpty).toList();
    final genreDataList = genreNames.map((name) {
      return genres.firstWhereOrNull((g) =>
          (g['name'] as String).toLowerCase() == name.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul
        Text(buku.judul,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800,
                color: Colors.black87, fontFamily: 'Poppins')),
        const SizedBox(height: 8),

        // Penulis + dipinjam
        Row(
          children: [
            const Icon(Icons.person_outline, color: Color(0xFF1565C0), size: 16),
            const SizedBox(width: 4),
            Text(buku.pengarang,
                style: const TextStyle(
                    color: Color(0xFF1565C0), fontSize: 14,
                    fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
            const Spacer(),
            Text('${_formatNum(buku.totalDipinjam)} Dipinjam',
                style: const TextStyle(fontSize: 12, color: Colors.black54, fontFamily: 'Poppins')),
          ],
        ),
        const SizedBox(height: 10),

        // Rating + status
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18),
            const SizedBox(width: 4),
            Text('${buku.rating} (${_formatNum(buku.totalRating)})',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
            const SizedBox(width: 10),

            // Badge tersedia / tidak tersedia
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: tersedia ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                tersedia ? 'Tersedia' : 'Tidak Tersedia',
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'Poppins',
                    color: tersedia ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F)),
              ),
            ),

            const Spacer(),
            const Icon(Icons.description_outlined, size: 14, color: Colors.black38),
            const SizedBox(width: 3),
            Text('${buku.jumlahHalaman} hal · ${buku.format}',
                style: const TextStyle(fontSize: 11, color: Colors.black45, fontFamily: 'Poppins')),
          ],
        ),
        const SizedBox(height: 12),

        // Kategori chip
        if (buku.kategori.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: catColor.withValues(alpha: 0.3)),
            ),
            child: Text(buku.kategori,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                    color: catColor, fontFamily: 'Poppins')),
          ),

        // Genre chips
        Wrap(
          spacing: 8, runSpacing: 8,
          children: genreDataList.map((g) {
            final label = g != null ? g['name'] as String : '';
            final color = g != null ? _parseColor(g['color'] ?? '#1565C0') : const Color(0xFF1565C0);
            if (label.isEmpty) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                      color: color, fontFamily: 'Poppins')),
            );
          }).toList(),
        ),
      ],
    );
  }
}
