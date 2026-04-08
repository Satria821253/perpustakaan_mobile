import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/perpanjang_controller.dart';

class PpTanggalBaru extends StatelessWidget {
  final PerpanjangController ctrl;
  const PpTanggalBaru({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.event_available_rounded,
                  color: Colors.white, size: 28),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Jatuh Tempo Baru',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(ctrl.tanggalBaruSetelahPerpanjang,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                ],
              ),
            ],
          ),
        ));
  }
}
