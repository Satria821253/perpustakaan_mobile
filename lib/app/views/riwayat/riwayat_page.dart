import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/riwayat_controller.dart';
import 'widgets/rw_app_bar.dart';
import 'widgets/rw_tab_bar.dart';
import 'widgets/rw_tab_pinjam.dart';
import 'widgets/rw_tab_kembali.dart';
import 'widgets/rw_tab_perpanjang.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(RiwayatController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DefaultTabController(
        length: 3,
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
