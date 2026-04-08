import 'package:flutter/material.dart';
import '../../../models/borrowing_detail_model.dart';
import 'dp_helpers.dart';

class DpDendaCard extends StatelessWidget {
  final BorrowingDetailModel d;
  const DpDendaCard({super.key, required this.d});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
                color: const Color(0xFFD32F2F).withValues(alpha: 0.1),
                shape: BoxShape.circle),
            child: const Icon(Icons.monetization_on_outlined, color: Color(0xFFD32F2F), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Denda Keterlambatan',
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
                Text('Rp ${dpFmt(d.denda)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFFD32F2F))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: d.dendaDibayar ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: d.dendaDibayar ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F)),
            ),
            child: Text(
              d.dendaDibayar ? 'Lunas' : 'Belum Bayar',
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: d.dendaDibayar ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F)),
            ),
          ),
        ],
      ),
    );
  }
}
