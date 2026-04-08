import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/riwayat_controller.dart';
import 'rw_card_perpanjang.dart';
import 'rw_shared_widgets.dart';

class RwTabPerpanjang extends StatelessWidget {
  final RiwayatController ctrl;
  const RwTabPerpanjang({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) => Obx(() {
        if (ctrl.isLoadingPerpanjang.value) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)));
        }
        if (ctrl.listPerpanjang.isEmpty) {
          return const RwEmpty(
              icon: Icons.event_repeat_rounded,
              label: 'Belum ada riwayat perpanjangan');
        }
        return RefreshIndicator(
          onRefresh: ctrl.fetchPerpanjang,
          color: const Color(0xFF1565C0),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.listPerpanjang.length,
            itemBuilder: (_, i) =>
                RwCardPerpanjang(item: ctrl.listPerpanjang[i]),
          ),
        );
      });
}
