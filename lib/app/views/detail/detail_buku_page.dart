import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/detail_buku_controller.dart';
import 'widgets/detail_app_bar.dart';
import 'widgets/detail_cover_slider.dart';
import 'widgets/detail_judul_info.dart';
import 'widgets/detail_tab.dart';
import 'widgets/detail_bottom_bar.dart';

class DetailBukuPage extends StatelessWidget {
  final int bookId;
  const DetailBukuPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DetailBukuController(bookId: bookId),
        tag: 'detail_$bookId');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() {
            if (ctrl.isLoading.value) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1565C0)));
            }
            if (ctrl.buku.value == null) {
              return const Center(
                  child: Text('Buku tidak ditemukan',
                      style: TextStyle(fontFamily: 'Poppins')));
            }
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: DetailCoverSlider(ctrl: ctrl)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailJudulInfo(ctrl: ctrl),
                        const SizedBox(height: 16),
                        DetailTabBar(ctrl: ctrl),
                        const Divider(height: 24),
                        DetailTabContent(ctrl: ctrl),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),

          // App bar overlay selalu di atas
          DetailAppBar(ctrl: ctrl),

          // Bottom bar
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: DetailBottomBar(ctrl: ctrl),
          ),
        ],
      ),
    );
  }
}
