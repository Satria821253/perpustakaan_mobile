import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../models/borrowing_detail_model.dart';

class PsBukuCard extends StatelessWidget {
  final BorrowingDetailModel detail;
  const PsBukuCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;
    final categories = homeCtrl?.categories ?? [];
    final genres = homeCtrl?.genres ?? [];

    final cover = detail.coverImage;
    final rating = detail.rating;
    final totalRating = detail.totalRating;
    final isPopuler = detail.isPopuler;
    final kategori = detail.categoryName;
    final genre = detail.genre;

    final catData = categories.firstWhereOrNull((c) => c['name'] == kategori);
    final catColor = catData != null
        ? _appParseColor(catData['color'] ?? '#1565C0')
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 16,
                    color: Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Buku yang Diperpanjang',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Color(0xFF1A1D23),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
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
                              width: 80,
                              height: 110,
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
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.bookJudul,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            detail.author,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 8),
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
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              if (kategori != null && kategori.isNotEmpty)
                                _AppChip(label: kategori, color: catColor),
                              ...List.generate(genreList.length, (i) {
                                final g = genreDataList[i];
                                final color = g != null
                                    ? _appParseColor(g['color'] ?? '#1565C0')
                                    : const Color(0xFF1565C0);
                                return _AppChip(
                                  label: genreList[i],
                                  color: color,
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3CD),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFFFCC02)),
                          ),
                          child: const Text(
                            'Diajukan',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              color: Color(0xFFF57C00),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 80,
    height: 110,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Center(
      child: Icon(Icons.menu_book, color: Colors.white24, size: 30),
    ),
  );

  Color _appParseColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}

class _AppChip extends StatelessWidget {
  final String label;
  final Color color;
  const _AppChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color: color,
        ),
      ),
    );
  }
}
