import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/riwayat_controller.dart';
import 'rw_shared_widgets.dart';

class RwTabTransaksi extends StatelessWidget {
  final RiwayatController ctrl;
  const RwTabTransaksi({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) => Obx(() {
        if (ctrl.isLoadingTransaksi.value) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD32F2F)));
        }
        if (ctrl.listTransaksi.isEmpty) {
          return const RwEmpty(
              icon: Icons.receipt_long_rounded,
              label: 'Belum ada riwayat transaksi');
        }
        return RefreshIndicator(
          onRefresh: ctrl.fetchTransaksi,
          color: const Color(0xFFD32F2F),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.listTransaksi.length,
            itemBuilder: (_, i) => _TransaksiCard(item: ctrl.listTransaksi[i]),
          ),
        );
      });
}

class _TransaksiCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _TransaksiCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final metode = item['payment_method'] as String? ?? '-';
    final judul = item['book_title'] ?? item['book_judul'] ?? '-';
    final tanggal = item['created_at'] ?? item['tanggal'] ?? '-';
    final amount = item['amount'] as int? ?? 0;
    final status = item['status'] as String? ?? 'success';
    final isSuccess = status == 'success' || status == 'paid' || status == 'lunas';

    final metodeLabel = _metodeLabel(metode);
    final metodeIcon = _metodeIcon(metode);
    final metodeColor = _metodeColor(metode);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: rwCardDecor(),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: metodeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(metodeIcon, color: metodeColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bayar Denda — $metodeLabel',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87)),
                const SizedBox(height: 2),
                Text(judul,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                RwInfoRow(
                    icon: Icons.access_time_rounded, text: tanggal),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Rp ${rwFmt(amount)}',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFD32F2F))),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isSuccess
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isSuccess ? 'Lunas' : 'Gagal',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSuccess
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFD32F2F)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _metodeLabel(String m) {
    switch (m) {
      case 'koin': return 'Koin';
      case 'kasir': return 'Kasir';
      case 'qris':
      case 'qr': return 'QR Code';
      case 'gopay': return 'GoPay';
      case 'ovo': return 'OVO';
      case 'dana': return 'DANA';
      case 'shopeepay': return 'ShopeePay';
      default: return m;
    }
  }

  IconData _metodeIcon(String m) {
    switch (m) {
      case 'koin': return Icons.monetization_on_outlined;
      case 'kasir': return Icons.store_outlined;
      case 'qris':
      case 'qr': return Icons.qr_code_2_rounded;
      default: return Icons.account_balance_wallet_outlined;
    }
  }

  Color _metodeColor(String m) {
    switch (m) {
      case 'koin': return const Color(0xFFFFB300);
      case 'kasir': return const Color(0xFFF57C00);
      case 'qris':
      case 'qr': return const Color(0xFF2E7D32);
      default: return const Color(0xFF6A1B9A);
    }
  }
}
