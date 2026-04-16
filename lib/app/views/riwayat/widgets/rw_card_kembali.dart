import 'package:ei_books/app/models/my_book_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'rw_shared_widgets.dart';

class RwCardKembali extends StatelessWidget {
  final MyBookModel item;
  const RwCardKembali({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/detail-pengembalian', arguments: item.id),
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
                        child: Text(
                          item.bookJudul,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const RwStatusBadge(
                        label: 'Dikembalikan',
                        color: Color(0xFF2E7D32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  RwGenreChips(kategori: item.kategori, genre: item.genre),
                  const SizedBox(height: 6),
                  RwInfoRow(
                    icon: Icons.calendar_today_rounded,
                    text: 'Pinjam: ${item.tanggalPinjam}',
                  ),
                  const SizedBox(height: 3),
                  RwInfoRow(
                    icon: Icons.assignment_return_rounded,
                    text: 'Dikembalikan: ${item.tanggalKembali}',
                    color: const Color(0xFF2E7D32),
                  ),
                  if (item.denda > 0) ...[
                    const SizedBox(height: 3),
                    RwInfoRow(
                      icon: Icons.monetization_on_outlined,
                      text:
                          'Denda: Rp ${rwFmt(item.denda)} ${item.dendaDibayar ? '(Lunas)' : '(Belum Bayar)'}',
                      color: item.dendaDibayar
                          ? Colors.grey[500]!
                          : const Color(0xFFD32F2F),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
