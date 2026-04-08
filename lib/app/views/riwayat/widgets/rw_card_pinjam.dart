import 'package:ei_books/app/models/my_book_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'rw_shared_widgets.dart';

class RwCardPinjam extends StatelessWidget {
  final MyBookModel item;
  const RwCardPinjam({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final terlambat = item.status == 'terlambat';
    final segera = !terlambat && item.hariTersisa <= 3;
    final statusColor = terlambat
        ? const Color(0xFFD32F2F)
        : segera
            ? const Color(0xFFF57C00)
            : const Color(0xFF1565C0);
    final statusLabel = terlambat
        ? 'Terlambat'
        : segera
            ? 'Segera Jatuh Tempo'
            : 'Dipinjam';

    return GestureDetector(
      onTap: () => Get.toNamed('/detail-peminjaman', arguments: item.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: rwCardDecor(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RwCoverWithBadge(url: item.coverImage, isPopuler: item.isPopuler),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.bookJudul,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      RwStatusBadge(label: statusLabel, color: statusColor),
                    ],
                  ),
                  const SizedBox(height: 5),
                  RwGenreChips(kategori: item.kategori, genre: item.genre),
                  const SizedBox(height: 6),
                  RwInfoRow(
                      icon: Icons.calendar_today_rounded,
                      text: 'Pinjam: ${item.tanggalPinjam}'),
                  const SizedBox(height: 3),
                  RwInfoRow(
                      icon: Icons.event_rounded,
                      text: 'Kembali: ${item.tanggalKembali}',
                      color: terlambat
                          ? const Color(0xFFD32F2F)
                          : segera
                              ? const Color(0xFFF57C00)
                              : Colors.grey[600]!),
                  const SizedBox(height: 3),
                  RwInfoRow(
                      icon: Icons.hourglass_bottom_rounded,
                      text: terlambat
                          ? 'Denda: Rp ${rwFmt(item.denda)}'
                          : '${item.hariTersisa} hari tersisa',
                      color: statusColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
