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
          // ── Cover ─────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: d.coverImage != null
                ? Image.network(
                    d.coverImage!,
                    width: 90,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _CoverPlaceholder(),
                  )
                : const _CoverPlaceholder(),
          ),
          const SizedBox(width: 14),

          // ── Info ──────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      d.bookJudul,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Peringatan jika sudah maks
                    if (d.jumlahPerpanjangan >= 3) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_rounded,
                              size: 11,
                              color: Color(0xFFC62828),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Kuota perpanjangan habis',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFC62828),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  d.author,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),

                // Rating
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFF9A825),
                      size: 14,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      d.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      '  (${d.totalRating} ulasan)',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 10),

                // Jatuh tempo
                _MetaRow(
                  icon: Icons.calendar_today_outlined,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        const TextSpan(text: 'Jatuh tempo: '),
                        TextSpan(
                          text: d.tanggalKembaliFormatted,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                // Sisa kuota perpanjangan
                _MetaRow(
                  icon: Icons.event_repeat_rounded,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        TextSpan(text: '${d.jumlahPerpanjangan}× perpanjangan'),
                        const TextSpan(text: ' dari maks 3×'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final Widget child;
  const _MetaRow({required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 12, color: Colors.black38),
        const SizedBox(width: 5),
        Expanded(child: child),
      ],
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 108,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(Icons.menu_book_rounded, color: Colors.white24, size: 28),
      ),
    );
  }
}
