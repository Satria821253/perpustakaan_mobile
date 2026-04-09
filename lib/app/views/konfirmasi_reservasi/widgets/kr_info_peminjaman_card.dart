import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/konfirmasi_reservasi_controller.dart';
import 'kr_helpers.dart';

class KrInfoPeminjamanCard extends StatelessWidget {
  final KonfirmasiReservasiController ctrl;
  const KrInfoPeminjamanCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: krCardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Informasi Peminjaman',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  fontFamily: 'Poppins')),
          const SizedBox(height: 14),
          const KrRow(label: 'Jenis', value: 'Peminjaman Online'),
          const KrRow(label: 'Durasi', value: '14 hari'),
          const KrRow(
              label: 'Alur',
              value: 'Reservasi → Ambil di perpustakaan'),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          // Info kode reservasi aktif
          Obx(() {
            final activeRes = ctrl.activeReservations.value;
            final maxRes = KonfirmasiReservasiController.maxReservasiAktif;
            if (activeRes > 0) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: activeRes >= maxRes
                          ? const Color(0xFFFFEEEE)
                          : const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          activeRes >= maxRes
                              ? Icons.block_rounded
                              : Icons.qr_code_2_rounded,
                          size: 18,
                          color: activeRes >= maxRes
                              ? const Color(0xFFE63946)
                              : const Color(0xFFF57C00),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kode Reservasi Aktif',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: activeRes >= maxRes
                                      ? const Color(0xFFE63946)
                                      : const Color(0xFFF57C00),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                activeRes >= maxRes
                                    ? 'Anda sudah mencapai batas maksimal'
                                    : 'Anda memiliki $activeRes kode yang belum diambil',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: activeRes >= maxRes
                                      ? const Color(0xFFE63946)
                                      : const Color(0xFFF57C00),
                                  fontFamily: 'Poppins',
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: activeRes >= maxRes
                                ? const Color(0xFFE63946)
                                : const Color(0xFFF57C00),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$activeRes/$maxRes',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 12),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
          // Info kuota pinjaman
          Obx(() {
            final sisa = ctrl.sisaKuota;
            final max = KonfirmasiReservasiController.maxPinjamanPerAnggota;
            final aktif = ctrl.activeBorrowings.value;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sisa > 0
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEEEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    sisa > 0
                        ? Icons.library_books_rounded
                        : Icons.block_rounded,
                    size: 18,
                    color: sisa > 0
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFE63946),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kuota Pinjaman',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: sisa > 0
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFE63946),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Dipinjam: $aktif dari $max • Sisa: $sisa buku',
                          style: TextStyle(
                            fontSize: 11,
                            color: sisa > 0
                                ? const Color(0xFF388E3C)
                                : const Color(0xFFE63946),
                            fontFamily: 'Poppins',
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: sisa > 0
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFE63946),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$aktif/$max',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Jumlah Stock',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontFamily: 'Poppins')),
                  ),
                  _QtyBtn(
                    icon: Icons.remove,
                    onTap: ctrl.quantity.value > 1 ? ctrl.decrement : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${ctrl.quantity.value}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                  _QtyBtn(
                    icon: Icons.add,
                    onTap: ctrl.quantity.value < ctrl.maxQuantity
                        ? ctrl.increment
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Maks. ${ctrl.maxQuantity} stock (stok tersedia: ${ctrl.buku.stok})',
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[400],
                    fontFamily: 'Poppins'),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF1565C0) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: 18, color: enabled ? Colors.white : Colors.grey[400]),
      ),
    );
  }
}

class KrCatatanCard extends StatelessWidget {
  const KrCatatanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFFF57C00), size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Perhatian',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF57C00),
                        fontFamily: 'Poppins')),
                SizedBox(height: 4),
                Text(
                  'Setelah reservasi berhasil, kamu akan mendapat kode BRW. '
                  'Tunjukkan kode tersebut ke petugas perpustakaan untuk mengambil buku.',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.5,
                      fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
