import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/riwayat_controller.dart';
import 'widgets/rw_app_bar.dart';
import 'widgets/rw_tab_bar.dart';
import 'widgets/rw_tab_pinjam.dart';
import 'widgets/rw_tab_kembali.dart';
import 'widgets/rw_tab_perpanjang.dart';

import 'widgets/rw_tab_transaksi.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  late RiwayatController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(RiwayatController());
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final initialTab = args?['initialTab'] as int? ?? 0;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DefaultTabController(
        length: 4,
        initialIndex: initialTab,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F6FB),
          appBar: const RwAppBar(),
          body: Column(
            children: [
              const RwTabBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    RwTabPinjam(ctrl: ctrl),
                    RwTabPerpanjang(ctrl: ctrl),
                    RwTabKembali(ctrl: ctrl),
                    RwTabTransaksi(ctrl: ctrl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
