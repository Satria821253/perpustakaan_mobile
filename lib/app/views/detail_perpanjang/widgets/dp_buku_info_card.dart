import 'package:flutter/material.dart';
import '../../../models/borrowing_detail_model.dart';
import '../../../widgets/app_shared_widgets.dart';

class DpxBukuInfoCard extends StatelessWidget {
  final BorrowingDetailModel d;
  const DpxBukuInfoCard({super.key, required this.d});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: appCardDecor(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: d.coverImage != null
                ? Image.network(d.coverImage!,
                    width: 80, height: 110, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder())
                : _placeholder(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.bookJudul,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        fontFamily: 'Poppins'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(d.pengarang,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontFamily: 'Poppins')),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFFFD600), size: 14),
                  const SizedBox(width: 3),
                  Text(d.rating.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins')),
                  Text('  (${d.totalRating} ulasan)',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[400],
                          fontFamily: 'Poppins')),
                ]),
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 8),
                _infoRow(Icons.calendar_today_outlined,
                    'Jatuh Tempo: ${d.tanggalKembaliFormatted}'),
                const SizedBox(height: 4),
                _infoRow(Icons.event_repeat_rounded,
                    '${d.jumlahPerpanjangan}x perpanjangan dari maks 3x'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Row(children: [
        Icon(icon, size: 13, color: Colors.black45),
        const SizedBox(width: 5),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontFamily: 'Poppins')),
        ),
      ]);

  Widget _placeholder() => Container(
        width: 80,
        height: 110,
        color: const Color(0xFF1A1A2E),
        child: const Center(
            child: Icon(Icons.menu_book, color: Colors.white24, size: 28)),
      );
}
