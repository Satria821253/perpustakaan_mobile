import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/app_config.dart';
import '../../../routes/app_pages.dart';

class FavoriteItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  const FavoriteItem({super.key, required this.item, required this.onRemove});

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF1565C0);
    }
  }

  @override
  Widget build(BuildContext context) {
    const baseUrl = AppConfig.baseUrl;
    final judul = item['judul'] as String? ?? '-';
    final pengarang = item['pengarang'] as String? ?? '-';
    final stok = item['stok'] ?? 0;
    final tersedia = item['status'] == 'tersedia';
    final rating = double.tryParse('${item['rating']}') ?? 0.0;
    final totalRating = item['total_rating'] ?? 0;
    final totalDipinjam = item['total_dipinjam'] ?? 0;
    final isPopuler = totalDipinjam > 0 && rating >= 4.0 && totalRating >= 3;
    final rawCover = item['cover_image'] as String? ?? '';
    final cover = rawCover.isNotEmpty
        ? rawCover
              .replaceFirst(RegExp(r'https?://localhost:\d+'), baseUrl)
              .replaceFirst(RegExp(r'https?://127\.0\.0\.1:\d+'), baseUrl)
        : '';
    final categoryId = item['category_id'];
    final genreStr = item['genre'] as String? ?? '';

    // Lookup dari HomeController
    final homeCtrl = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;
    final categories = homeCtrl?.categories ?? [];
    final genres = homeCtrl?.genres ?? [];

    final catData = categories.firstWhereOrNull((c) => c['id'] == categoryId);
    final catName = catData?['name'] as String? ?? '';
    final catColor = catData != null
        ? _parseColor(catData['color'] ?? '#1565C0')
        : const Color(0xFF1565C0);

    // Genre bisa multiple, ambil semua yang match
    final genreNames = genreStr
        .split(',')
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty)
        .toList();
    final genreDataList = genreNames
        .map((name) {
          return genres.firstWhereOrNull(
            (g) => (g['name'] as String).toLowerCase() == name.toLowerCase(),
          );
        })
        .whereType<Map<String, dynamic>>()
        .toList();

    return GestureDetector(
      onTap: () =>
          Get.toNamed(Routes.detail, arguments: item['book_id'] as int),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 80,
                height: 110,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    cover.isNotEmpty
                        ? Image.network(
                            cover,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) => _placeholder(),
                          )
                        : _placeholder(),
                    if (isPopuler)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6F00),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                color: Colors.white,
                                size: 9,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Populer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          judul,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: tersedia
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tersedia ? 'Tersedia' : 'Dipinjam',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: tersedia
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFD32F2F),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    pengarang,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Kategori
                  if (catName.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: catColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        catName,
                        style: TextStyle(
                          fontSize: 9,
                          color: catColor,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  // Genre chips
                  if (genreDataList.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: genreDataList.map((g) {
                        final color = _parseColor(g['color'] ?? '#1565C0');
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: color.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            g['name'],
                            style: TextStyle(
                              fontSize: 9,
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB300),
                        size: 13,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${double.tryParse('${item['rating']}')?.toStringAsFixed(1) ?? '0.0'}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 1,
                        height: 12,
                        color: Colors.grey[300],
                      ),
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Stok: $stok',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onRemove,
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFFE84B1A),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: Colors.grey[200],
    child: const Center(
      child: Icon(Icons.menu_book, color: Colors.black26, size: 32),
    ),
  );
}
