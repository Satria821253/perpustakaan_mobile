import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/kategori_row.dart';
import 'widgets/banner_slider.dart';
import 'widgets/buku_terbaru_section.dart';
import 'widgets/buku_populer_section.dart';
import 'widgets/home_bottom_nav.dart';
import '../profile/profile_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final pages = [
          _HomeBody(ctrl: ctrl),
          const _PlaceholderPage(label: 'Explore'),
          const _PlaceholderPage(label: 'Buku Saya'),
          const _PlaceholderPage(label: 'Riwayat'),
          const ProfilePage(),
        ];
        return pages[ctrl.currentNavIndex.value];
      }),
      bottomNavigationBar: HomeBottomNav(ctrl: ctrl),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final HomeController ctrl;
  const _HomeBody({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFF1565C0),
      backgroundColor: Colors.white,
      strokeWidth: 2.5,
      displacement: MediaQuery.of(context).padding.top + 120,
      onRefresh: () async {
        await Future.wait([
          ctrl.fetchBukuTerbaru(),
          ctrl.fetchBukuPopuler(),
          if (Get.isRegistered<ProfileController>()) ProfileController.to.fetchAll(),
        ]);
      },
      child: Stack(
        children: [
          const HomeAppBar(),
          Positioned(
            top: MediaQuery.of(context).padding.top + 210,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: KategoriRow(),
                      ),
                      const SizedBox(height: 20),
                      BannerSlider(ctrl: ctrl),
                      const SizedBox(height: 20),
                      BukuTerbaruSection(ctrl: ctrl),
                      const SizedBox(height: 24),
                      BukuPopulerSection(ctrl: ctrl),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String label;
  const _PlaceholderPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 20, fontFamily: 'Poppins')),
      ),
    );
  }
}
