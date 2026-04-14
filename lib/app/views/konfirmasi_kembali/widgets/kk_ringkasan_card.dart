import 'package:ei_books/app/controllers/konfirmasi_kembali_controller.dart';
import 'package:ei_books/app/views/konfirmasi_kembali/widgets/kk_helpers.dart';
import 'package:flutter/material.dart';
import '../../../models/borrowing_detail_model.dart';


class KkRingkasanCard extends StatelessWidget {
  final KonfirmasiKembaliController ctrl;
  final BorrowingDetailModel d;
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
          KkInfoRow(label: 'No. Anggota', value: d.nomorAnggota),
          KkInfoRow(label: 'Tanggal Pinjam', value: d.tanggalPinjam),
          KkInfoRow(label: 'Jatuh Tempo', value: d.tanggalKembali),
          KkInfoRow(label: 'Durasi Pinjam', value: '${d.durasiPinjam} hari'),
          KkInfoRow(
            label: ctrl.terlambat ? 'Keterlambatan' : 'Sisa Waktu',
            value: ctrl.terlambat
                ? '${ctrl.hariTerlambat} hari terlambat'
                : '${d.hariTersisa} hari',
            valueColor: ctrl.terlambat
                ? const Color(0xFFD32F2F)
                : const Color(0xFF2E7D32),
          ),
          KkInfoRow(
            label: 'Perpanjangan',
            value: '${d.jumlahPerpanjangan}x',
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
