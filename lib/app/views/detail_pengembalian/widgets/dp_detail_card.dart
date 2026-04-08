import 'package:flutter/material.dart';
import '../../../models/borrowing_detail_model.dart';
import 'dp_helpers.dart';

class DpDetailCard extends StatelessWidget {
  final BorrowingDetailModel d;
  const DpDetailCard({super.key, required this.d});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: dpCardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dpSectionTitle('Informasi Pengembalian'),
          const SizedBox(height: 14),
          DpInfoRow(label: 'Peminjam', value: d.userNama),
          DpInfoRow(label: 'No. Anggota', value: d.nomorAnggota),
          DpInfoRow(label: 'Tanggal Pinjam', value: d.tanggalPinjamFormatted),
          DpInfoRow(label: 'Tanggal Kembali', value: d.tanggalKembaliFormatted),
          DpInfoRow(label: 'Tanggal Dikembalikan', value: d.tanggalDikembalikan ?? '-'),
          DpInfoRow(label: 'Durasi', value: '${d.durasiPinjam} hari'),
          DpInfoRow(label: 'Kondisi Buku', value: d.kondisiBuku),
          DpInfoRow(label: 'Kanal', value: d.kanal, isLast: true),
        ],
      ),
    );
  }
}
