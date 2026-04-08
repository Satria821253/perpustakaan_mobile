import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/konfirmasi_reservasi_controller.dart';
import '../../../controllers/home_controller.dart';
import 'kr_helpers.dart';

class KrInfoBukuCard extends StatelessWidget {
  final KonfirmasiReservasiController ctrl;
  const KrInfoBukuCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final homeCtrl =
        Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    final categories = homeCtrl?.categories ?? [];
    final genres = homeCtrl?.genres ?? [];

    final kategori = ctrl.buku.kategori;
    final genre = ctrl.buku.genre;
    final b = ctrl.buku;

    final catData =
        categories.firstWhereOrNull((c) => c['name'] == kategori);
    final catColor = catData != null
        ? krParseColor(catData['color'] ?? '#1565C0')
        : const Color(0xFF1565C0);

    final genreList = genre
        .split(',')
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty)
        .toList();
    final genreDataList = genreList
        .map((name) => genres.firstWhereOrNull(
            (g) => (g['name'] as String).toLowerCase() == name.toLowerCase()))
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: krCardDecor(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: b.coverImage != null
                    ? Image.network(
                        b.coverImage!,
                        width: 90,
                        height: 124,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              if (b.isPopuler)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFF6F00),
                        borderRadius: BorderRadius.circular(4)),
                    child: const Icon(Icons.local_fire_department,
                        color: Colors.white, size: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        b.judul,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                            fontFamily: 'Poppins'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Stok: ${b.stok}',
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  b.pengarang,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFFFD600), size: 14),
                  const SizedBox(width: 3),
                  Text(b.rating.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700)),
                  Text('  (${b.totalRating} ulasan)',
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey[400])),
                ]),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (kategori.isNotEmpty)
                      KrChip(label: kategori, color: catColor),
                    ...List.generate(genreList.length, (i) {
                      final g = genreDataList[i];
                      final color = g != null
                          ? krParseColor(g['color'] ?? '#1565C0')
                          : const Color(0xFF1565C0);
                      return KrChip(label: genreList[i], color: color);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 90,
        height: 124,
        color: const Color(0xFF1A1A2E),
        child: const Center(
            child: Icon(Icons.menu_book, color: Colors.white24, size: 34)),
      );
}
