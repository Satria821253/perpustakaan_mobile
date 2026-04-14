import 'package:flutter/material.dart';
import '../../../controllers/detail_peminjaman_controller.dart';
import '../../../models/borrowing_detail_model.dart';

class DpStatusCard extends StatelessWidget {
  final DetailPeminjamanController ctrl;
  final BorrowingDetailModel d;
  const DpStatusCard({super.key, required this.ctrl, required this.d});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                  ctrl.terlambat && ctrl.dendaDibayar
                      ? Icons.check_circle_outline_rounded
                      : ctrl.terlambat
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
                      ctrl.terlambat && ctrl.dendaDibayar
                          ? 'Denda Lunas · Siap Dikembalikan atau Diperpanjang'
                          : ctrl.terlambat
                              ? 'Terlambat ${d.hariTerlambat} Hari'
                              : ctrl.sudahDikembalikan
                                  ? 'Sudah Dikembalikan'
                                  : 'Sisa ${d.hariTersisa} Hari Lagi',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ctrl.terlambat && ctrl.dendaDibayar
                          ? 'Denda ${d.hariTerlambat} hari telah dibayar. Kembalikan atau perpanjang buku.'
                          : ctrl.terlambat
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
        ),
        // Warning untuk terlambat sudah bayar
        if (ctrl.terlambat && ctrl.dendaDibayar) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFCC02)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFF57C00), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 12, color: Colors.black87, fontFamily: 'Poppins'),
                      children: [
                        TextSpan(
                          text: 'Perhatian! ',
                          style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFF57C00)),
                        ),
                        TextSpan(
                          text: 'Segera kembalikan buku dalam 24 jam. Jika tidak, denda akan bertambah lagi setiap hari.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        // Warning untuk akan jatuh tempo
        if (!ctrl.terlambat && !ctrl.sudahDikembalikan && d.hariTersisa <= 3 && d.hariTersisa > 0) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFCC02)),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule_rounded, color: Color(0xFFF57C00), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Buku akan jatuh tempo dalam ${d.hariTersisa} hari. Segera kembalikan atau perpanjang untuk menghindari denda.',
                    style: const TextStyle(fontSize: 12, color: Colors.black87, fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
