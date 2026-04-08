import 'package:ei_books/app/controllers/explore_controller.dart';
import 'package:ei_books/app/models/book_model.dart';
import 'package:ei_books/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'explore_book_card.dart';

class ExploreGrid extends StatelessWidget {
  final ExploreController ctrl;
  const ExploreGrid({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasRekomSection = ctrl.allRekomendasi.isNotEmpty;
      final isLoadingRekom = ctrl.isLoadingRekomendasi.value;
      final isLoadingBooks = ctrl.isLoading.value;
      final books = ctrl.books;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Rekomendasi
          if (isLoadingRekom)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator(color: Color(0xFF1565C0))),
            )
          else if (hasRekomSection) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Text('Rekomendasi Untukmu',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Colors.black87)),
            ),
            if (ctrl.rekomendasi.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Icon(Icons.search_off_rounded, size: 32, color: Colors.grey[300]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Belum ada rekomendasi untuk kategori ini',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                              fontFamily: 'Poppins')),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: 270,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  itemCount: ctrl.rekomendasi.length,
                  separatorBuilder: (context, value) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => _RekomendasiCard(buku: ctrl.rekomendasi[i]),
                ),
              ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Text('Semua Buku',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Colors.black87)),
            ),
          ],

          // Grid buku
          if (isLoadingBooks)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator(color: Color(0xFF1565C0))),
            )
          else if (books.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    Text('Buku tidak ditemukan',
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 15,
                            fontFamily: 'Poppins')),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const crossAxisCount = 3;
                  const spacing = 12.0;
                  final cardWidth = (constraints.maxWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;
                  final cardHeight = cardWidth * (4 / 3) + 62;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: 14,
                      mainAxisExtent: cardHeight,
                    ),
                    itemCount: books.length,
                    itemBuilder: (_, i) => ExploreBookCard(buku: books[i]),
                  );
                },
              ),
            ),
        ],
      );
    });
  }
}

class _RekomendasiCard extends StatelessWidget {
  final BookModel buku;
  const _RekomendasiCard({required this.buku});

  String _formatDipinjam(int val) {
    if (val >= 1000000) return '${(val / 1000000).toStringAsFixed(1)}jt';
    if (val >= 1000) return '${(val / 1000).toStringAsFixed(0)}rb';
    return '$val';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.detail, arguments: buku.id),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: buku.coverImage != null
                        ? Image.network(
                            buku.coverImage!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                  if (buku.totalDipinjam > 0 && buku.rating >= 4.0 && buku.totalRating >= 3)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6F00),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_fire_department, color: Colors.white, size: 11),
                            SizedBox(width: 3),
                            Text('Populer',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(buku.judul,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(buku.pengarang,
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey[500], fontFamily: 'Poppins'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFD600), size: 11),
                      const SizedBox(width: 2),
                      Text('${buku.rating}',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                              fontFamily: 'Poppins')),
                      Text('  |  ',
                          style: TextStyle(color: Colors.grey[300], fontSize: 10)),
                      Expanded(
                        child: Text('${_formatDipinjam(buku.totalDipinjam)} dipinjam',
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[500],
                                fontFamily: 'Poppins'),
                            overflow: TextOverflow.ellipsis),
                      ),
                      const FaIcon(FontAwesomeIcons.commentDots,
                          color: Color(0xFF1565C0), size: 13),
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
        color: const Color(0xFF1A1A2E),
        child: const Center(child: Icon(Icons.menu_book, color: Colors.white24, size: 40)),
      );
}
