import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/riwayat_controller.dart';
import 'rw_card_kembali.dart';
import 'rw_shared_widgets.dart';

class RwTabKembali extends StatelessWidget {
  final RiwayatController ctrl;
  const RwTabKembali({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) => Obx(() {
        if (ctrl.isLoadingKembali.value) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
        }
        if (ctrl.listKembali.isEmpty) {
          return const RwEmpty(
              icon: Icons.assignment_return_rounded,
              label: 'Belum ada riwayat pengembalian');
        }
        return RefreshIndicator(
          onRefresh: ctrl.fetchKembali,
          color: const Color(0xFF2E7D32),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.listKembali.length,
            itemBuilder: (_, i) => RwCardKembali(item: ctrl.listKembali[i]),
          ),
        );
      });
}
