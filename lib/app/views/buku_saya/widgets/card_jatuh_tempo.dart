import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/my_book_model.dart';
import '../../../routes/app_pages.dart';
import 'buku_saya_widgets.dart';
import '../../../widgets/perpanjangan_helper.dart';

class CardJatuhTempo extends StatelessWidget {
  final MyBookModel buku;
  const CardJatuhTempo({super.key, required this.buku});

  @override
  Widget build(BuildContext context) {
    final terlambat = buku.hariTersisa < 0;
    final bannerColor = terlambat
        ? const Color(0xFFD32F2F)
        : const Color(0xFFF57C00);
    final bgColor = terlambat
        ? const Color(0xFFFFEBEE)
        : const Color(0xFFFFF8E1);
    final borderColor = terlambat
        ? const Color(0xFFEF9A9A)
        : const Color(0xFFFFCC02);

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.detailPeminjaman, arguments: buku.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: bannerColor.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    terlambat
                        ? Icons.error_rounded
                        : Icons.warning_amber_rounded,
                    color: bannerColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      terlambat
                          ? 'Terlambat ${buku.hariTersisa.abs()} hari'
                          : 'Sisa ${buku.hariTersisa} hari lagi sebelum jatuh tempo',
                      style: TextStyle(
                        color: bannerColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Get.toNamed(Routes.detail, arguments: buku.bookId),
                        child: Stack(
                          children: [
                            CoverWidget(
                              cover: buku.coverImage,
                              width: 80,
                              height: 110,
                            ),
                            if (buku.totalDipinjam > 0 &&
                                buku.rating >= 4.0 &&
                                buku.totalRating >= 3)
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
                                    size: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              buku.bookJudul,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFD600),
                                  size: 13,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${buku.rating.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  '  (${buku.totalRating} ulasan)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[400],
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: terlambat
                                    ? 0.0
                                    : (buku.hariTersisa / buku.durasiPinjam)
                                          .clamp(0.0, 1.0),
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  bannerColor,
                                ),
                                minHeight: 6,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              terlambat
                                  ? 'Melewati batas ${buku.hariTersisa.abs()} hari'
                                  : 'Sisa ${buku.hariTersisa} dari ${buku.durasiPinjam} hari',
                              style: TextStyle(
                                fontSize: 10,
                                color: bannerColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.event_outlined,
                                  size: 13,
                                  color: Colors.black45,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Jatuh Tempo: ${buku.tanggalKembali}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            if (buku.denda > 0) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFEF9A9A),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.monetization_on_outlined,
                                      size: 13,
                                      color: Color(0xFFD32F2F),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Denda: Rp ${formatRupiah(buku.denda)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFD32F2F),
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (!terlambat)
                        Expanded(
                          child: OutlineBtn(
                            icon: Icons.calendar_month_outlined,
                            label: 'Perpanjang',
                            onTap: buku.jumlahPerpanjangan >= 3
                                ? null
                                : () => _handlePerpanjang(buku),
                          ),
                        ),
                      if (!terlambat) const SizedBox(width: 10),
                      Expanded(
                        child: FilledBtn(
                          icon: Icons.qr_code_rounded,
                          label: terlambat ? 'Bayar Denda' : 'Kembalikan',
                          color: bannerColor,
                          onTap: () {
                            if (terlambat &&
                                buku.denda > 0 &&
                                !buku.dendaDibayar) {
                              Get.toNamed(
                                Routes.pembayaran,
                                arguments: buku.id,
                              );
                            } else {
                              Get.toNamed(
                                Routes.konfirmasiKembali,
                                arguments: buku.id,
                              );
                            }
                          },
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
}

  void _handlePerpanjang(MyBookModel buku) {
    print('🔍 DEBUG Buku Saya - Tombol Perpanjang diklik (Jatuh Tempo)');
    print('   - Borrowing ID: ${buku.id}');
    print('   - Judul Buku: ${buku.bookJudul}');
    print('   - Jumlah Perpanjangan: ${buku.jumlahPerpanjangan} / 3');
    print('');

    // Cek apakah bisa perpanjang (akan tampilkan dialog jika tidak bisa)
    if (!PerpanjanganHelper.canExtend(
      jumlahPerpanjangan: buku.jumlahPerpanjangan,
      borrowingId: buku.id,
    )) {
      print('   ❌ Tidak bisa perpanjang (sudah max 3x)');
      print('');
      return;
    }

    // Lanjut ke halaman perpanjang
    print('   ✅ Bisa perpanjang, navigasi ke halaman perpanjang');
    print('');
    Get.toNamed(Routes.perpanjang, arguments: buku.id);
  }

class CardSelesai extends StatelessWidget {
  final MyBookModel buku;
  const CardSelesai({super.key, required this.buku});

  @override
  Widget build(BuildContext context) {
    final adaDenda = buku.denda > 0;

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.detailPeminjaman, arguments: buku.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFC8E6C9).withValues(alpha: 0.8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF2E7D32),
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Dikembalikan',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Get.toNamed(Routes.detail, arguments: buku.bookId),
                        child: CoverWidget(
                          cover: buku.coverImage,
                          width: 80,
                          height: 110,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              buku.bookJudul,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFD600),
                                  size: 13,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${buku.rating.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  '  (${buku.totalRating} ulasan)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[400],
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 13,
                                  color: Colors.black38,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Dikembalikan: ${buku.tanggalKembali}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.monetization_on_outlined,
                                  size: 13,
                                  color: Colors.black38,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Denda: Rp ${formatRupiah(buku.denda)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: adaDenda
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: adaDenda
                                        ? const Color(0xFFD32F2F)
                                        : Colors.black54,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlineBtn(
                          icon: Icons.info_outline_rounded,
                          label: 'Cek Detail',
                          onTap: () => Get.toNamed(
                            Routes.detailPeminjaman,
                            arguments: buku.id,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledBtn(
                          icon: Icons.bookmark_add_outlined,
                          label: 'Pinjam Lagi',
                          onTap: () => Get.toNamed(
                            Routes.detail,
                            arguments: buku.bookId,
                          ),
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
}
