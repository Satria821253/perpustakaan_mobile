import 'package:flutter/material.dart';
import '../../../controllers/kode_pengembalian_controller.dart';

// ── Info Buku Card ────────────────────────────────────

class KpInfoBukuCard extends StatelessWidget {
  final KodePengembalianController ctrl;
  const KpInfoBukuCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Informasi Buku',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87)),
          const SizedBox(height: 14),
          _KpInfoRow(label: 'Judul Buku', value: ctrl.judulBuku),
          _KpInfoRow(label: 'Jatuh Tempo', value: ctrl.tanggalKembali),
          _KpInfoRow(
              label: 'Tanggal Sekarang',
              value: DateTime.now().toString().substring(0, 10)),
          _KpInfoRow(
              label: 'Status',
              value: 'Menunggu Verifikasi Petugas',
              valueColor: const Color(0xFFF57C00),
              isLast: true),
        ],
      ),
    );
  }
}

// ── Langkah Card ─────────────────────────────────────

class KpLangkahCard extends StatelessWidget {
  const KpLangkahCard({super.key});

  static const _langkah = [
    {'step': '1', 'title': 'Datang ke perpustakaan', 'desc': 'Bawa buku yang akan dikembalikan'},
    {'step': '2', 'title': 'Tunjukkan kode', 'desc': 'Perlihatkan kode ini kepada petugas di loket'},
    {'step': '3', 'title': 'Serahkan buku', 'desc': 'Petugas akan memverifikasi pengembalian'},
    {'step': '4', 'title': 'Pengembalian selesai', 'desc': 'Koin reward akan ditambahkan jika tepat waktu'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Langkah Pengembalian',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87)),
          const SizedBox(height: 16),
          ...List.generate(_langkah.length, (i) {
            return _KpLangkahItem(
                data: _langkah[i], isLast: i == _langkah.length - 1);
          }),
        ],
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────

class _KpInfoRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  final bool isLast;
  const _KpInfoRow(
      {required this.label,
      required this.value,
      this.valueColor,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 13, color: Colors.grey[500])),
              Flexible(
                child: Text(value,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: valueColor ?? Colors.black87),
                    textAlign: TextAlign.right),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: Colors.grey[100]),
      ],
    );
  }
}

class _KpLangkahItem extends StatelessWidget {
  final Map<String, String> data;
  final bool isLast;
  const _KpLangkahItem({required this.data, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                      color: Color(0xFF1565C0), shape: BoxShape.circle),
                  child: Center(
                    child: Text(data['step']!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey[200],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['title']!,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                  const SizedBox(height: 2),
                  Text(data['desc']!,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[500], height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
