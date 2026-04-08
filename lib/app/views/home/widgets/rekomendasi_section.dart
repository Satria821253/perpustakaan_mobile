import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../models/book_model.dart';
import '../../../routes/app_pages.dart';

class RekomendasiSection extends StatelessWidget {
  final HomeController ctrl;
  const RekomendasiSection({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoadingRekomendasi.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(child: CircularProgressIndicator(color: Color(0xFF1565C0))),
        );
      }
      if (ctrl.rekomendasi.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('Rekomendasi Untukmu',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: Colors.black87)),
                Spacer(),
                Text('Lihat Semua',
                    style: TextStyle(
                        color: Color(0xFF1565C0),
                        fontSize: 12,
                        fontFamily: 'Poppins')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 350,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: ctrl.rekomendasi.length,
              separatorBuilder: (context, value) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _RekomendasiCard(buku: ctrl.rekomendasi[i]),
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
        width: 190,
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
