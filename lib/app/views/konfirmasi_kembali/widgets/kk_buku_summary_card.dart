import 'package:ei_books/app/views/konfirmasi_kembali/widgets/kk_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/konfirmasi_kembali_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../models/borrowing_detail_model.dart';

class KkBukuSummaryCard extends StatelessWidget {
  final KonfirmasiKembaliController ctrl;
  final BorrowingDetailModel d;
  const KkBukuSummaryCard({super.key, required this.ctrl, required this.d});

  @override
  Widget build(BuildContext context) {
    final cover = d.coverImage;
    final rating = d.rating;
    final totalRating = d.totalRating;
    final isPopuler = d.isPopuler;
    final kategori = d.categoryName;
    final genre = d.genre;
    final homeCtrl = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;
    final categories = homeCtrl?.categories ?? [];
    final genres = homeCtrl?.genres ?? [];

    final catData = categories.firstWhereOrNull((c) => c['name'] == kategori);
    final catColor = catData != null
        ? appParseColor(catData['color'] ?? '#1565C0')
        : const Color(0xFF1565C0);

    final genreList =
        genre
            ?.split(',')
            .map((g) => g.trim())
            .where((g) => g.isNotEmpty)
            .toList() ??
        [];
    final genreDataList = genreList
        .map(
          (name) => genres.firstWhereOrNull(
            (g) => (g['name'] as String).toLowerCase() == name.toLowerCase(),
          ),
        )
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kkCardDecor(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: cover != null
                    ? Image.network(
                        cover,
                        width: 90,
                        height: 124,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              if (isPopuler)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6F00),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul + status sejajar
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        d.bookJudul,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ctrl.terlambat
                            ? const Color(0xFFFFEBEE)
                            : const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ctrl.terlambat ? '⚠ ${ctrl.hariTerlambat}h' : '✓ Tepat',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: ctrl.terlambat
                              ? const Color(0xFFD32F2F)
                              : const Color(0xFF1565C0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  d.author,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 8),
                // Rating
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFD600),
                      size: 14,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '  ($totalRating ulasan)',
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Kategori & Genre chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (kategori != null && kategori.isNotEmpty)
                      AppChip(label: kategori, color: catColor),
                    ...List.generate(genreList.length, (i) {
                      final g = genreDataList[i];
                      final color = g != null
                          ? appParseColor(g['color'] ?? '#1565C0')
                          : const Color(0xFF1565C0);
                      return AppChip(label: genreList[i], color: color);
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
      child: Icon(Icons.menu_book, color: Colors.white24, size: 34),
    ),
  );
}
