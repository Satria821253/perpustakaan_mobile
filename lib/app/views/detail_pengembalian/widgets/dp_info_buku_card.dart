import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../models/borrowing_detail_model.dart';
import 'dp_helpers.dart';

class DpInfoBukuCard extends StatelessWidget {
  final BorrowingDetailModel d;
  const DpInfoBukuCard({super.key, required this.d});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;
    final categories = homeCtrl?.categories ?? [];
    final genres = homeCtrl?.genres ?? [];

    final catData = categories.firstWhereOrNull(
      (c) => c['name'] == d.categoryName,
    );
    final catColor = catData != null
        ? dpParseColor(catData['color'] ?? '#2E7D32')
        : const Color(0xFF2E7D32);

    final genreList =
        d.genre
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
      decoration: dpCardDecor(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: d.coverImage != null
                ? Image.network(
                    d.coverImage!,
                    width: 90,
                    height: 124,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.bookJudul,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  d.author,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
                      d.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '  (${d.totalRating} ulasan)',
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (d.categoryName != null && d.categoryName!.isNotEmpty)
                      AppChip(label: d.categoryName!, color: catColor),
                    ...List.generate(genreList.length, (i) {
                      final g = genreDataList[i];
                      final color = g != null
                          ? dpParseColor(g['color'] ?? '#2E7D32')
                          : const Color(0xFF2E7D32);
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
