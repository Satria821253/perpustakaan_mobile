import 'package:flutter/material.dart';
import '../../../models/my_book_model.dart';
import '../../../routes/app_pages.dart';
import 'package:get/get.dart';
import 'buku_saya_widgets.dart';
import '../../../widgets/perpanjangan_helper.dart';

class CardDipinjam extends StatelessWidget {
  final MyBookModel buku;
  const CardDipinjam({super.key, required this.buku});

  @override
  Widget build(BuildContext context) {
    final akanJatuhTempo = buku.hariTersisa <= 3 && buku.hariTersisa >= 0;
    final terlambatSudahBayar = buku.hariTersisa < 0 && buku.dendaDibayar;
    final bannerColor = terlambatSudahBayar
        ? const Color(0xFF2E7D32)
        : akanJatuhTempo
            ? const Color(0xFFF57C00)
            : const Color(0xFF1565C0);

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.detailPeminjaman, arguments: buku.id),
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: terlambatSudahBayar
              ? const Color(0xFFA5D6A7).withValues(alpha: 0.8)
              : akanJatuhTempo
                  ? const Color(0xFFFFCC02).withValues(alpha: 0.5)
                  : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (terlambatSudahBayar)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F8E9),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded, color: Color(0xFF2E7D32), size: 16),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text('Denda Lunas · Segera kembalikan dalam 24 jam atau denda akan bertambah lagi',
                        style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins')),
                  ),
                ],
              ),
            )
          else if (akanJatuhTempo)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8E1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.schedule_rounded, color: Color(0xFFF57C00), size: 16),
                  SizedBox(width: 6),
                  Text('Akan Jatuh Tempo',
                      style: TextStyle(
                          color: Color(0xFFF57C00),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins')),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.detail, arguments: buku.bookId),
                      child: Stack(
                        children: [
                          CoverWidget(cover: buku.coverImage, width: 80, height: 110),
                          if (buku.totalDipinjam > 0 && buku.rating >= 4.0 && buku.totalRating >= 3)
                            Positioned(
                              top: 6, left: 6,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6F00),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.local_fire_department, color: Colors.white, size: 10),
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(buku.bookJudul,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black87,
                                        fontFamily: 'Poppins'),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(children: [
                            const Icon(Icons.star, color: Color(0xFFFFD600), size: 13),
                            const SizedBox(width: 3),
                            Text('${buku.rating.toStringAsFixed(1)}',
                                style: TextStyle(fontSize: 11, color: Colors.grey[600], fontFamily: 'Poppins')),
                            Text('  (${buku.totalRating} ulasan)',
                                style: TextStyle(fontSize: 11, color: Colors.grey[400], fontFamily: 'Poppins')),
                          ]),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: buku.hariTersisa > 0
                                  ? (buku.hariTersisa / buku.durasiPinjam).clamp(0.0, 1.0)
                                  : 0.0,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                akanJatuhTempo ? const Color(0xFFF57C00) : const Color(0xFF1565C0),
                              ),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sisa ${buku.hariTersisa} dari ${buku.durasiPinjam} hari',
                            style: TextStyle(fontSize: 10, color: Colors.grey[400], fontFamily: 'Poppins'),
                          ),
                          if (buku.quantity > 1) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${buku.quantity} stock dipinjam',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1565C0),
                                    fontFamily: 'Poppins'),
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.black45),
                              const SizedBox(width: 4),
                              Text(
                                akanJatuhTempo
                                    ? 'Sisa ${buku.hariTersisa} Hari Lagi'
                                    : 'Jatuh Tempo: ${buku.tanggalKembali}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: akanJatuhTempo ? FontWeight.w700 : FontWeight.w400,
                                  color: akanJatuhTempo ? const Color(0xFFF57C00) : Colors.black54,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          if (akanJatuhTempo) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8E1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFFFCC02)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.warning_amber_rounded, size: 11, color: Color(0xFFF57C00)),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Segera kembalikan atau perpanjang',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFF57C00),
                                        fontFamily: 'Poppins',
                                      ),
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
                    Expanded(
                      child: OutlineBtn(
                        icon: Icons.calendar_month_outlined,
                        label: 'Perpanjang',
                        onTap: buku.jumlahPerpanjangan >= 3 ? null : () => _handlePerpanjang(buku),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledBtn(
                        icon: Icons.qr_code_rounded,
                        label: 'Kembalikan',
                        color: terlambatSudahBayar ? const Color(0xFF2E7D32) : const Color(0xFF1565C0),
                        onTap: () => Get.toNamed(Routes.konfirmasiKembali, arguments: buku.id),
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

  void _handlePerpanjang(MyBookModel buku) {
    print('🔍 DEBUG Buku Saya - Tombol Perpanjang diklik');
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
  }}
