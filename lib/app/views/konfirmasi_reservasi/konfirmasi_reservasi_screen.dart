import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/konfirmasi_reservasi_controller.dart';
import 'widgets/kr_info_buku_card.dart';
import 'widgets/kr_info_peminjaman_card.dart';
import 'widgets/kr_bottom_action.dart';
class KonfirmasiReservasiScreen extends StatelessWidget {
  const KonfirmasiReservasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<KonfirmasiReservasiController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text('Konfirmasi Peminjaman',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  KrInfoBukuCard(ctrl: ctrl),
                  const SizedBox(height: 16),
                  KrInfoPeminjamanCard(ctrl: ctrl),
                  const SizedBox(height: 16),
                  const KrCatatanCard(),
                ],
              ),
            ),
          ),
          KrBottomAction(ctrl: ctrl),
        ],
      ),
    );
  }
}
