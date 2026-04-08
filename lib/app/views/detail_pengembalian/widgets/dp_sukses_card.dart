import 'package:flutter/material.dart';
import '../../../models/borrowing_detail_model.dart';

class DpSuksesCard extends StatelessWidget {
  final BorrowingDetailModel d;
  const DpSuksesCard({super.key, required this.d});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 52),
          const SizedBox(height: 10),
          const Text('Pengembalian Berhasil!',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
            'Dikembalikan: ${d.tanggalDikembalikan ?? d.tanggalKembaliFormatted}',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
          ),
          if (d.koinEarned > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.monetization_on_rounded, color: Color(0xFFFFD600), size: 18),
                  const SizedBox(width: 6),
                  Text('+${d.koinEarned} Koin Bonus Tepat Waktu!',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
