import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/extension_request_model.dart';
import '../../../routes/app_pages.dart';
import 'rw_shared_widgets.dart';

class RwCardPerpanjang extends StatelessWidget {
  final ExtensionRequestModel item;
  const RwCardPerpanjang({super.key, required this.item});

  Color get _color {
    switch (item.status) {
      case 'approved':
        return const Color(0xFF2E7D32);
      case 'rejected':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFFF57C00);
    }
  }

  String get _label {
    switch (item.status) {
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(Routes.detailPerpanjang, arguments: item.borrowingId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: rwCardDecor(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover buku
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: item.coverImage != null
                      ? Image.network(
                          item.coverImage!,
                          width: 60,
                          height: 82,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
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
                              item.bookJudul.isNotEmpty
                                  ? item.bookJudul
                                  : 'Peminjaman #${item.borrowingId}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          RwStatusBadge(label: _label, color: _color),
                        ],
                      ),
                      const SizedBox(height: 6),
                      RwInfoRow(
                        icon: Icons.event_repeat_rounded,
                        text: 'Perpanjang ${item.durasiHari} hari',
                      ),
                      const SizedBox(height: 3),
                      RwInfoRow(
                        icon: Icons.access_time_rounded,
                        text: 'Diajukan: ${item.tanggalRequest}',
                        color: Colors.grey[400],
                      ),
                      if (item.tanggalKembaliBaru != null) ...[
                        const SizedBox(height: 3),
                        RwInfoRow(
                          icon: Icons.calendar_today_rounded,
                          text: 'Jatuh tempo baru: ${item.tanggalKembaliBaru}',
                          color: const Color(0xFF2E7D32),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            // Alasan & Pesan di bawah divider
            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 8),
            RwInfoRow(
              icon: Icons.notes_rounded,
              text: 'Alasan: ${item.alasan}',
            ),
            if (item.catatanPetugas != null &&
                item.catatanPetugas!.isNotEmpty) ...[
              const SizedBox(height: 4),
              RwInfoRow(
                icon: Icons.message_outlined,
                text: 'Pesan: ${item.catatanPetugas}',
                color: _color,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 60,
    height: 82,
    color: const Color(0xFF1A1A2E),
    child: const Center(
      child: Icon(Icons.menu_book, color: Colors.white24, size: 24),
    ),
  );
}
