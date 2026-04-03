import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/detail_buku_controller.dart';
import '../../controllers/review_controller.dart';
import 'widgets/detail_app_bar.dart';
import 'widgets/detail_cover_slider.dart';
import 'widgets/detail_judul_info.dart';
import 'widgets/detail_tab.dart';
import 'widgets/detail_bottom_bar.dart';

class DetailBukuPage extends StatefulWidget {
  final int bookId;
  const DetailBukuPage({super.key, required this.bookId});

  @override
  State<DetailBukuPage> createState() => _DetailBukuPageState();
}

class _DetailBukuPageState extends State<DetailBukuPage> {
  late final DetailBukuController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(DetailBukuController(bookId: widget.bookId), tag: 'detail_${widget.bookId}');
  }

  @override
  void dispose() {
    Get.delete<DetailBukuController>(tag: 'detail_${widget.bookId}', force: true);
    Get.delete<ReviewController>(tag: 'review_${widget.bookId}', force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: DetailBottomBar(ctrl: ctrl),
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
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),

          // App bar overlay selalu di atas
          DetailAppBar(ctrl: ctrl),
        ],
      ),
    );
  }
}
