import 'package:ei_books/app/controllers/pembayaran_controller.dart';
import 'package:flutter/material.dart';
import 'shared_widgets.dart';

class InfoMetode extends StatelessWidget {
  final PembayaranController ctrl;
  const InfoMetode({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final metode = ctrl.selectedMetode.value;
    if (metode.isEmpty) return const SizedBox.shrink();

    String title = '';
    String desc = '';

    switch (metode) {
      case 'kasir':
        title = 'Bayar di Perpustakaan';
        desc = 'Tunjukkan Bukti Pembayaran di Perpustakaan.\nBuka Senin–Sabtu pukul 08.00–16.00 WIB.';
        break;
      case 'ewallet':
        if (ctrl.selectedEwallet.value.isEmpty) return const SizedBox.shrink();
        title = ctrl.labelMetodeTerpilih;
        desc = 'Anda akan diarahkan ke aplikasi ${ctrl.labelMetodeTerpilih} untuk menyelesaikan pembayaran.';
        break;
      case 'koin':
        title = 'Koin Aplikasi';
        desc = '${formatKoin(ctrl.totalDenda)} koin akan dipotong dari saldo koin Anda.';
        break;
      case 'qr':
        title = 'QR Code';
        desc = 'Kode QR akan muncul setelah konfirmasi. Scan di kasir atau mesin bayar terdekat.';
        break;
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFBFCBFF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 15, color: Color(0xFF1565C0)),
                const SizedBox(width: 6),
                Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1565C0))),
              ],
            ),
            const SizedBox(height: 4),
            Text(desc,
                style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
