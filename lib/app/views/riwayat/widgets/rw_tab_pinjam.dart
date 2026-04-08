import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/riwayat_controller.dart';
import 'rw_card_pinjam.dart';
import 'rw_shared_widgets.dart';

class RwTabPinjam extends StatelessWidget {
  final RiwayatController ctrl;
  const RwTabPinjam({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) => Obx(() {
        if (ctrl.isLoadingPinjam.value) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)));
        }
        if (ctrl.listPinjam.isEmpty) {
          return const RwEmpty(
              icon: Icons.menu_book_rounded,
              label: 'Belum ada peminjaman aktif');
        }
        return RefreshIndicator(
          onRefresh: ctrl.fetchPinjam,
          color: const Color(0xFF1565C0),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.listPinjam.length,
            itemBuilder: (_, i) => RwCardPinjam(item: ctrl.listPinjam[i]),
          ),
        );
      });
}
