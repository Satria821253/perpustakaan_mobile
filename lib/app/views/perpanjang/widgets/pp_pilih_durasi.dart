import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/perpanjang_controller.dart';
import 'pp_helpers.dart';

class PpPilihDurasi extends StatelessWidget {
  final PerpanjangController ctrl;
  const PpPilihDurasi({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ppDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pilih Durasi Perpanjangan',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Obx(() {
            final sisaSlot = ctrl.sisaSlot;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sisa slot: $sisaSlot dari 3',
                    style: TextStyle(
                        fontSize: 12,
                        color: sisaSlot > 0 ? Colors.grey[500] : const Color(0xFFD32F2F),
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(
                  children: PerpanjangController.pilihanDurasi.map((d) {
                    final active = ctrl.durasiHari.value == d;
                    final slot = PerpanjangController.slotUntuk(d);
                    final bisa = ctrl.slotCukup(d);
                    return Expanded(
                      child: GestureDetector(
                        onTap: bisa ? () => ctrl.setDurasi(d) : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !bisa
                                ? Colors.grey[200]
                                : active
                                    ? const Color(0xFF1565C0)
                                    : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: active && bisa
                                    ? const Color(0xFF1565C0)
                                    : Colors.transparent),
                          ),
                          child: Column(
                            children: [
                              Text('$d',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: !bisa
                                          ? Colors.grey[400]
                                          : active
                                              ? Colors.white
                                              : Colors.black87)),
                              Text('hari',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: !bisa
                                          ? Colors.grey[400]
                                          : active
                                              ? Colors.white70
                                              : Colors.grey[500])),
                              const SizedBox(height: 2),
                              Text('$slot slot',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: !bisa
                                          ? Colors.grey[400]
                                          : active
                                              ? Colors.white60
                                              : Colors.grey[400])),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Info box durasi yang dipilih
                Builder(builder: (_) {
                  final dipilih = ctrl.durasiHari.value;
                  final slotDipakai = PerpanjangController.slotUntuk(dipilih);
                  final sisaSetelah = ctrl.sisaSlot - slotDipakai;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            color: Color(0xFF1565C0), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                              children: [
                                TextSpan(
                                  text: '$dipilih hari ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1565C0)),
                                ),
                                TextSpan(
                                    text: 'menggunakan '),
                                TextSpan(
                                  text: '$slotDipakai slot',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87),
                                ),
                                TextSpan(
                                    text: ' — sisa slot setelah ini: '),
                                TextSpan(
                                  text: '$sisaSetelah dari 3',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: sisaSetelah == 0
                                          ? const Color(0xFFD32F2F)
                                          : const Color(0xFF2E7D32)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }
}
