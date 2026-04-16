import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          dpSectionTitle('Informasi Peminjaman'),
          const SizedBox(height: 14),
          DpDetailRow(label: 'Peminjam', value: d.userNama),
          DpDetailRow(label: 'No. Anggota', value: d.nomorAnggota),
          DpDetailRow(label: 'Jumlah Stock Yang Dipinjam', value: '${d.quantity} buku'),
          DpDetailRow(label: 'Kode Peminjaman', value: 'BRW-${d.id}'),
          DpDetailRow(label: 'Tanggal Pinjam', value: d.tanggalPinjamFormatted),
          DpDetailRow(label: 'Jatuh Tempo', value: d.tanggalKembaliFormatted),
          DpDetailRow(label: 'Durasi', value: '${d.durasiPinjam} hari'),
          DpDetailRow(label: 'Perpanjangan', value: '${d.jumlahPerpanjangan}x dari maks 3x'),
          DpDetailRow(label: 'Kanal', value: d.kanal, isLast: true),
          if (d.jumlahPerpanjangan > 0) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Get.toNamed('/detail-perpanjang', arguments: d.id),
                icon: const Icon(Icons.event_repeat_rounded, size: 15),
                label: const Text('Lihat Detail Perpanjangan'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1565C0),
                  side: const BorderSide(color: Color(0xFF1565C0)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  textStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
