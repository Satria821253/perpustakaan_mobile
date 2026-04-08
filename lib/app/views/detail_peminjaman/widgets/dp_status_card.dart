import 'package:flutter/material.dart';
import '../../../controllers/detail_peminjaman_controller.dart';
import '../../../models/borrowing_detail_model.dart';

class DpStatusCard extends StatelessWidget {
  final DetailPeminjamanController ctrl;
  final BorrowingDetailModel d;
  const DpStatusCard({super.key, required this.ctrl, required this.d});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ctrl.statusColor, ctrl.statusColor.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: Icon(
              ctrl.terlambat
                  ? Icons.error_outline_rounded
                  : ctrl.sudahDikembalikan
                      ? Icons.check_circle_outline_rounded
                      : Icons.schedule_rounded,
              color: Colors.white, size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ctrl.terlambat
                      ? 'Terlambat ${d.hariTerlambat} Hari'
                      : ctrl.sudahDikembalikan
                          ? 'Sudah Dikembalikan'
                          : 'Sisa ${d.hariTersisa} Hari Lagi',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  ctrl.terlambat
                      ? 'Segera kembalikan untuk menghindari denda lebih besar'
                      : ctrl.sudahDikembalikan
                          ? 'Terima kasih telah mengembalikan tepat waktu'
                          : 'Jatuh tempo: ${d.tanggalKembaliFormatted}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
