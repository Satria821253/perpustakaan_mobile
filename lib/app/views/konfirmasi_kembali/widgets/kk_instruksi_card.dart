import 'package:flutter/material.dart';
import 'kk_helpers.dart';

class KkInstruksiCard extends StatelessWidget {
  final int quantity;
  const KkInstruksiCard({super.key, this.quantity = 1});

  static const _steps = [
    'Tekan tombol "Proses Pengembalian" di bawah',
    'Kode pengembalian akan digenerate otomatis',
    'Tunjukkan kode kepada petugas perpustakaan',
    'Petugas akan memverifikasi dan memproses pengembalian',
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
                        const TextSpan(text: 'Pastikan mengembalikan '),
                        TextSpan(
                          text: 'semua $quantity stock buku',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const TextSpan(text: ' kepada petugas perpustakaan.'),
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
          padding: const EdgeInsets.all(16),
          decoration: kkCardDecor(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: Color(0xFF1565C0), size: 18),
                  const SizedBox(width: 8),
                  kkSectionTitle('Cara Pengembalian'),
                ],
              ),
              const SizedBox(height: 12),
              ...List.generate(
                _steps.length,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        margin: const EdgeInsets.only(top: 1),
                        decoration: const BoxDecoration(
                            color: Color(0xFF1565C0), shape: BoxShape.circle),
                        child: Center(
                          child: Text('${i + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(_steps[i],
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54, height: 1.4)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
