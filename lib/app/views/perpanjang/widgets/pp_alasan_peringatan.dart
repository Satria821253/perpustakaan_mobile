import 'package:flutter/material.dart';
import '../../../controllers/perpanjang_controller.dart';
import 'pp_helpers.dart';

// ── Alasan Field ─────────────────────────────────────

class PpAlasanField extends StatelessWidget {
  final PerpanjangController ctrl;
  const PpAlasanField({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ppDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Alasan Perpanjangan',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          TextField(
            onChanged: ctrl.setAlasan,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Contoh: Belum selesai membaca...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFF1565C0), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Peringatan Card ───────────────────────────────────

class PpPeringatan extends StatelessWidget {
  final int quantity;
  const PpPeringatan({super.key, this.quantity = 1});

  static const _ketentuan = [
    'Perpanjangan maksimal 3 kali per buku (total 21 hari)',
    '7 hari = 1x slot, 14 hari = 2x slot, 21 hari = 3x slot',
    'Permintaan perpanjangan perlu disetujui admin',
    'Tidak bisa perpanjang jika ada denda belum dibayar',
    'Perpanjangan tidak tersedia jika buku dipesan orang lain',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (quantity > 1) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF90CAF9)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Color(0xFF1565C0), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        const TextSpan(text: 'Semua '),
                        TextSpan(
                          text: '$quantity stock buku',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const TextSpan(text: ' akan diperpanjang bersamaan dengan durasi yang sama.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFE082)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [
                Icon(Icons.info_outline_rounded,
                    color: Color(0xFFF57C00), size: 16),
                SizedBox(width: 8),
                Text('Ketentuan Perpanjangan',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF57C00))),
              ]),
              const SizedBox(height: 8),
              ..._ketentuan.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(
                                color: Colors.black54, fontSize: 13)),
                        Expanded(
                          child: Text(t,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54)),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
