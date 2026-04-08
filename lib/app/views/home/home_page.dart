import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/profile_controller.dart';
import '../explore/explore_page.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/kategori_row.dart';
import 'widgets/banner_slider.dart';
import 'widgets/buku_terbaru_section.dart';
import 'widgets/buku_populer_section.dart';
import 'widgets/rekomendasi_section.dart';
import 'widgets/home_bottom_nav.dart';
import '../buku_saya/buku_saya_page.dart';
import '../profile/profile_page.dart';
import '../riwayat/riwayat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Obx(() => IndexedStack(
        index: ctrl.currentNavIndex.value,
        children: [
          _HomeBody(ctrl: ctrl),
          const ExplorePage(),
          const BukuSayaPage(),
          const RiwayatPage(),
          const ProfilePage(),
        ],
      )),
      bottomNavigationBar: HomeBottomNav(ctrl: ctrl),
    );
  }
}

class _HomeBody extends StatefulWidget {
  final HomeController ctrl;
  const _HomeBody({required this.ctrl});

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  Future<void> _onRefresh() async {
    await Future.wait([
      widget.ctrl.fetchBukuTerbaru(),
      widget.ctrl.fetchBukuPopuler(),
      widget.ctrl.fetchRekomendasi(),
      if (Get.isRegistered<ProfileController>())
        ProfileController.to.fetchAll(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFF1565C0),
      backgroundColor: Colors.white,
      strokeWidth: 2.5,
      displacement: 16,
      onRefresh: _onRefresh,
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
                color: const Color(0xFFF4F6FB),
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
                      BannerSlider(ctrl: widget.ctrl),
                      const SizedBox(height: 20),
                      RekomendasiSection(ctrl: widget.ctrl),
                      const SizedBox(height: 24),
                      BukuPopulerSection(ctrl: widget.ctrl),
                      const SizedBox(height: 24),
                      BukuTerbaruSection(ctrl: widget.ctrl),
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

