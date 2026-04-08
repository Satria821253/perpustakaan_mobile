import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../controllers/home_controller.dart';
import '../../../models/book_model.dart';

class BukuPopulerSection extends StatelessWidget {
  final HomeController ctrl;
  const BukuPopulerSection({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) => _BookSection(
        title: 'Buku Rating Tertinggi',
        books: ctrl.bukuPopuler,
        isLoading: ctrl.isLoadingPopuler,
        sortByRating: true,
      );
}

class _BookSection extends StatelessWidget {
  final String title;
  final RxList<BookModel> books;
  final RxBool isLoading;
  final bool sortByRating;
  const _BookSection({
    required this.title,
    required this.books,
    required this.isLoading,
    this.sortByRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Colors.black87)),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text('Lihat Semua',
                    style: TextStyle(
                        color: Color(0xFF1565C0),
                        fontSize: 12,
                        fontFamily: 'Poppins')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (isLoading.value) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator(),
            );
          }
          if (books.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text('Tidak ada buku',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)),
            );
          }
          final displayed = [...books];
          if (sortByRating) {
            displayed.sort((a, b) => b.rating.compareTo(a.rating));
          }
          final tampil = displayed.take(4).toList();
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 420,
            ),
            itemCount: tampil.length,
            itemBuilder: (_, i) => _BukuCard(buku: tampil[i]),
          );
        }),
      ],
    );
  }
}

class _BukuCard extends StatelessWidget {
  final BookModel buku;
  const _BukuCard({required this.buku});

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
            // Cover full di atas
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
                            buku.coverImage!.replaceFirst('localhost', '10.111.26.122'),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                  if (buku.totalDipinjam > 0 && buku.rating >= 4.0 && buku.totalRating >= 3)
                    Positioned(
                      top: 8,
                      left: 8,
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
            // Info putih di bawah, fixed height
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
                          color: Colors.black87,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(buku.pengarang,
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                          fontFamily: 'Poppins'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFD600), size: 11),
                      const SizedBox(width: 2),
                      Text('${buku.rating}',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                              fontFamily: 'Poppins')),
                      Text('  |  ',
                          style: TextStyle(color: Colors.grey[300], fontSize: 10)),
                      Expanded(
                        child: Text('${_formatDipinjam(buku.totalDipinjam)} dipinjam',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 9,
                                fontFamily: 'Poppins'),
                            overflow: TextOverflow.ellipsis),
                      ),
                      const FaIcon(FontAwesomeIcons.commentDots, color: Color(0xFF1565C0), size: 13),
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
        child: const Center(
          child: Icon(Icons.menu_book, color: Colors.white24, size: 52),
        ),
      );
}
