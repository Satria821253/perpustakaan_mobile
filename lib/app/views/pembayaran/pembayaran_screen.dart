import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/pembayaran_controller.dart';
import 'widgets/header_widget.dart';
import 'widgets/buku_card.dart';
import 'widgets/rincian_card.dart';
import 'widgets/metode_widgets.dart';
import 'widgets/info_metode.dart';
import 'widgets/bottom_cta.dart';

class PembayaranScreen extends StatelessWidget {
  final int borrowingId;
  const PembayaranScreen({super.key, required this.borrowingId});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(PembayaranController(borrowingId: borrowingId));

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Obx(() {
        // Loading state
        if (ctrl.isLoadingData.value) {
          return Column(
            children: [
              const HeaderWidget(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Memuat data pembayaran...',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        // Main content
        return Column(
          children: [
            const HeaderWidget(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BukuCard(ctrl: ctrl),
                    const SizedBox(height: 12),
                    RincianCard(ctrl: ctrl),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'PILIH METODE PEMBAYARAN',
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: Colors.black45, letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    MetodeKasir(ctrl: ctrl),
                    const SizedBox(height: 8),
                    MetodeEwallet(ctrl: ctrl),
                    const SizedBox(height: 8),
                    MetodeKoin(ctrl: ctrl),
                    const SizedBox(height: 8),
                    MetodeQR(ctrl: ctrl),
                    const SizedBox(height: 12),
                    Obx(() {
                      // Access observable to trigger rebuild
                      final _ = ctrl.selectedMetode.value;
                      return InfoMetode(ctrl: ctrl);
                    }),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            BottomCTA(ctrl: ctrl),
          ],
        );
      }),
    );
  }
}
