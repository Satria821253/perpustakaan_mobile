import 'package:ei_books/app/views/konfirmasi_kembali/widgets/kk_helpers.dart';
import 'package:flutter/material.dart';
import '../../../controllers/konfirmasi_kembali_controller.dart';

class KkRingkasanCard extends StatelessWidget {
  final KonfirmasiKembaliController ctrl;
  final Map<String, dynamic> d;
  const KkRingkasanCard({super.key, required this.ctrl, required this.d});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kkCardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kkSectionTitle('Ringkasan Peminjaman'),
          const SizedBox(height: 14),
          KkInfoRow(label: 'No. Anggota', value: d['nomor_anggota'] as String? ?? '-'),
          KkInfoRow(label: 'Tanggal Pinjam', value: d['tanggal_pinjam'] as String? ?? '-'),
          KkInfoRow(label: 'Jatuh Tempo', value: d['tanggal_kembali'] as String? ?? '-'),
          KkInfoRow(label: 'Durasi Pinjam', value: '${d['durasi_pinjam'] ?? '-'} hari'),
          KkInfoRow(
            label: ctrl.terlambat ? 'Keterlambatan' : 'Sisa Waktu',
            value: ctrl.terlambat
                ? '${ctrl.hariTerlambat} hari terlambat'
                : '${d['hari_tersisa'] ?? 0} hari',
            valueColor: ctrl.terlambat
                ? const Color(0xFFD32F2F)
                : const Color(0xFF2E7D32),
          ),
          KkInfoRow(
            label: 'Perpanjangan',
            value: '${d['jumlah_perpanjangan'] ?? 0}x',
            isLast: !ctrl.adaDenda,
          ),
          if (ctrl.adaDenda)
            KkInfoRow(
              label: 'Total Denda',
              value: 'Rp ${kkFmt(ctrl.denda)}',
              valueColor: const Color(0xFFD32F2F),
              isLast: true,
            ),
        ],
      ),
    );
  }
}
