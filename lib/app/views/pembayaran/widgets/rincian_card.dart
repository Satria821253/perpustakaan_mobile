import 'package:ei_books/app/controllers/pembayaran_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'shared_widgets.dart';

class RincianCard extends StatelessWidget {
  final PembayaranController ctrl;
  const RincianCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final b = ctrl.buku.value;
      final hari = b['hari_terlambat'] as int? ?? 0;
      final perHari = b['denda_per_hari'] as int? ?? 0;
      final total = b['total_denda'] as int? ?? 0;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rincian Tagihan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black87)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Denda Keterlambatan',
                        style: TextStyle(fontSize: 13, color: Colors.black54)),
                    const SizedBox(height: 2),
                    Text('$hari hari × Rp ${formatRupiah(perHari)}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                  ],
                ),
                Text('Rp ${formatRupiah(total)}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFD32F2F))),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFF0F0F0)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pembayaran',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black87)),
                Text('Rp ${formatRupiah(total)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFFD32F2F))),
              ],
            ),
          ],
        ),
      );
    });
  }
}
