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
    if (metode == 'ewallet' && ctrl.selectedEwallet.value.isEmpty) return const SizedBox.shrink();

    // Semua metode tetap harus tunjuk bukti ke petugas
    const buktiNote = 'Tetap tunjukkan bukti pembayaran kepada petugas perpustakaan setelah transaksi selesai.';

    String title = '';
    String desc = '';
    IconData icon = Icons.info_outline_rounded;
    Color color = const Color(0xFF1565C0);
    Color bgColor = const Color(0xFFEEF2FF);
    Color borderColor = const Color(0xFFBFCBFF);

    switch (metode) {
      case 'kasir':
        title = 'Bayar di Perpustakaan';
        desc = 'Tunjukkan bukti pembayaran di perpustakaan.\nBuka Senin–Sabtu pukul 08.00–16.00 WIB.';
        break;
      case 'ewallet':
        title = '${ctrl.labelMetodeTerpilih} — Sedang Dikembangkan';
        desc = 'Fitur pembayaran via e-wallet sedang dalam tahap pengembangan. $buktiNote';
        icon = Icons.construction_rounded;
        color = const Color(0xFFD97706);
        bgColor = const Color(0xFFFFFBEB);
        borderColor = const Color(0xFFFDE68A);
        break;
      case 'koin':
        title = 'Koin Aplikasi';
        desc = '${formatKoin(ctrl.totalDenda)} koin akan dipotong dari saldo Anda. $buktiNote';
        break;
      case 'qr':
        title = 'QR Code';
        desc = 'Kode QR akan muncul setelah konfirmasi. Scan di kasir atau mesin bayar. $buktiNote';
        break;
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 15, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700, color: color)),
                ),
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
