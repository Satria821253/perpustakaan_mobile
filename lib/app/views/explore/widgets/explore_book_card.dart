import 'package:ei_books/app/models/book_model.dart';
import 'package:ei_books/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreBookCard extends StatelessWidget {
  final BookModel buku;
  const ExploreBookCard({super.key, required this.buku});

  String _formatDipinjam(int val) {
    if (val >= 1000000) return '${(val / 1000000).toStringAsFixed(1)}jt';
    if (val >= 1000) return '${(val / 1000).toStringAsFixed(0)}rb';
    return '$val';
  }

  @override
  Widget build(BuildContext context) {
    final tersedia = buku.stok > 0;

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.detail, arguments: buku.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Cover image
                  buku.coverImage != null
                      ? Image.network(buku.coverImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder())
                      : _placeholder(),

                  // Overlay habis
                  if (!tersedia)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: Text('Habis',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins')),
                      ),
                    ),

                  // Badge populer
                  if (buku.totalDipinjam > 0 &&
                      buku.rating >= 4.0 &&
                      buku.totalRating >= 3)
                    Positioned(
                      top: 6, left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6F00),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_fire_department,
                                color: Colors.white, size: 9),
                            SizedBox(width: 2),
                            Text('Populer',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                    ),

                  // Bookmark pojok kanan atas
                  Positioned(
                    top: 6, right: 6,
                    child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bookmark_border,
                          color: Colors.white, size: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(buku.judul,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  fontFamily: 'Poppins'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),

          const SizedBox(height: 2),

          Text(buku.pengarang,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                  fontFamily: 'Poppins'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.star_rounded,
                  color: Color(0xFFFFB300), size: 12),
              const SizedBox(width: 2),
              Text('${buku.rating}',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontFamily: 'Poppins')),
              Text(' · ${_formatDipinjam(buku.totalDipinjam)}',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                      fontFamily: 'Poppins')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFF1A1A2E),
        child: const Center(
            child: Icon(Icons.menu_book, color: Colors.white10, size: 32)),
      );
}
