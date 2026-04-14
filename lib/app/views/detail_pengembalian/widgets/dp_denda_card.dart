import 'package:flutter/material.dart';
import '../../../models/borrowing_detail_model.dart';
import 'dp_helpers.dart';

class DpDendaCard extends StatelessWidget {
  final BorrowingDetailModel d;
  const DpDendaCard({super.key, required this.d});

  @override
  Widget build(BuildContext context) {
    final lunas = d.dendaDibayar;
    final transaksi = d.timeline.where(
      (t) => t.activity == 'bayar_denda' || t.activity == 'denda',
    ).lastOrNull;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lunas ? const Color(0xFFF1F8E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: lunas ? const Color(0xFFA5D6A7) : const Color(0xFFFFCDD2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: (lunas ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F))
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  lunas ? Icons.check_circle_outline_rounded : Icons.monetization_on_outlined,
                  color: lunas ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lunas ? 'Denda Telah Dibayar' : 'Denda Keterlambatan',
                      style: TextStyle(
                        fontSize: 12,
                        color: lunas ? const Color(0xFF2E7D32) : Colors.black54,
                      ),
                    ),
                    Text(
                      'Rp ${dpFmt(d.denda)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: lunas ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: lunas ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: lunas ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                  ),
                ),
                child: Text(
                  lunas ? 'Lunas' : 'Belum Bayar',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: lunas ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                  ),
                ),
              ),
            ],
          ),
          if (lunas && transaksi != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFC8E6C9)),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.receipt_long_rounded, size: 13, color: Color(0xFF2E7D32)),
                SizedBox(width: 6),
                Text('Detail Transaksi',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32))),
              ],
            ),
            const SizedBox(height: 8),
            _InfoBaris(
              icon: Icons.info_outline_rounded,
              label: 'Keterangan',
              value: transaksi.description,
            ),
            const SizedBox(height: 4),
            _InfoBaris(
              icon: Icons.access_time_rounded,
              label: 'Waktu',
              value: transaksi.createdAt,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoBaris extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoBaris({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 12, color: Colors.grey[500]),
        const SizedBox(width: 5),
        Text('$label: ', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        Expanded(
          child: Text(value,
              style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ),
      ],
    );
  }
}
