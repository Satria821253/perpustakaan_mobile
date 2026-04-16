import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';
import '../../../core/app_config.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/perpanjangan_helper.dart';

class ProfileBukuDipinjam extends StatelessWidget {
  final ProfileController ctrl;
  const ProfileBukuDipinjam({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.activeBorrowings.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Buku Sedang Dipinjam',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 350,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: ctrl.activeBorrowings.length,
                separatorBuilder: (context, value) => const SizedBox(width: 12),
                itemBuilder: (_, i) =>
                    _BukuItem(buku: ctrl.activeBorrowings[i]),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _BukuItem extends StatelessWidget {
  final Map<String, dynamic> buku;
  const _BukuItem({required this.buku});

  @override
  Widget build(BuildContext context) {
    final status = buku['status'] as String? ?? '';
    final terlambat = status == 'terlambat';
    final hariTersisa = (buku['hari_tersisa'] as num?)?.toInt() ?? 0;
    final rawCover = buku['cover_image'] as String?;
    final cover = rawCover
        ?.replaceFirst(RegExp(r'https?://localhost:\d+'), AppConfig.baseUrl)
        .replaceFirst(RegExp(r'https?://127\.0\.0\.1:\d+'), AppConfig.baseUrl);
    final judul = buku['book_judul'] as String? ?? '-';
    final bookId = buku['book_id'] as int? ?? 0;
    final rating = double.tryParse('${buku['rating']}') ?? 0.0;
    final totalDipinjam = (buku['book_total_dipinjam'] ?? 0) as int;
    final isPopuler = totalDipinjam >= 5 && rating >= 4.0;
    final borrowingId = buku['id'] as int? ?? 0;
    final jumlahPerpanjangan = (buku['jumlah_perpanjangan'] as num?)?.toInt() ?? 0;

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.detail, arguments: bookId),
      child: Container(
        width: 190,
        height: 350,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: terlambat ? const Color(0xFFFFCDD2) : Colors.grey.shade200,
          ),
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
                    child: cover != null && cover.isNotEmpty
                        ? Image.network(
                            cover,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stack) => _coverPlaceholder(),
                          )
                        : _coverPlaceholder(),
                  ),
                  if (isPopuler)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6F00),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.white,
                              size: 11,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Populer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: terlambat
                          ? const Color(0xFFFFEBEE)
                          : const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      terlambat ? '⚠ Terlambat' : '$hariTersisa hari lagi',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: terlambat
                            ? const Color(0xFFD32F2F)
                            : const Color(0xFF1565C0),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 26,
                    child: ElevatedButton(
                      onPressed: () => _handleAction(
                        terlambat: terlambat,
                        borrowingId: borrowingId,
                        jumlahPerpanjangan: jumlahPerpanjangan,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: terlambat
                            ? const Color(0xFFD32F2F)
                            : const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        terlambat ? 'Kembalikan' : 'Perpanjang',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
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
    );
  }

  Widget _coverPlaceholder() => Container(
    color: const Color(0xFF1A1A2E),
    child: const Center(
      child: Icon(Icons.menu_book, color: Colors.white24, size: 40),
    ),
  );

  void _handleAction({
    required bool terlambat,
    required int borrowingId,
    required int jumlahPerpanjangan,
  }) {
    print('🔍 DEBUG Profile - Tombol diklik');
    print('   - Terlambat: $terlambat');
    print('   - Borrowing ID: $borrowingId');
    print('   - Jumlah Perpanjangan: $jumlahPerpanjangan / 3');
    print('   - Data Buku Lengkap: $buku');
    print('');

    if (terlambat) {
      print('   ➡️ Navigasi ke Kembalikan');
      Get.toNamed(Routes.konfirmasiKembali, arguments: borrowingId);
      return;
    }

    // Cek apakah bisa perpanjang
    print('   🔍 Cek apakah bisa perpanjang...');
    if (!PerpanjanganHelper.canExtend(
      jumlahPerpanjangan: jumlahPerpanjangan,
      borrowingId: borrowingId,
    )) {
      return;
    }

    print('   ✅ Bisa perpanjang, navigasi ke halaman perpanjang');
    print('');
    Get.toNamed(Routes.perpanjang, arguments: borrowingId);
  }
}
