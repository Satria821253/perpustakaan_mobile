import 'package:ei_books/app/controllers/explore_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'widgets/explore_kategori_chips.dart';
import 'widgets/explore_grid.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.isRegistered<ExploreController>()
        ? Get.find<ExploreController>()
        : Get.put(ExploreController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        body: CustomScrollView(
          slivers: [
            // Search bar + filter — pinned
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 64,
              titleSpacing: 16,
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Icon(Icons.search_rounded, color: Colors.grey[400], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: ctrl.setSearch,
                              decoration: InputDecoration(
                                hintText: 'Cari judul, penulis...',
                                hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                    fontFamily: 'Poppins'),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(() => GestureDetector(
                    onTap: () => ctrl.openFilterSheet(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: ctrl.hasActiveFilter
                            ? const Color(0xFF1565C0)
                            : const Color(0xFFF4F6FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: ctrl.hasActiveFilter ? Colors.white : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  )),
                ],
              ),
            ),

            // Kategori chips — pinned tepat di bawah search bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _ChipsDelegate(ctrl: ctrl),
            ),

            SliverToBoxAdapter(child: ExploreGrid(ctrl: ctrl)),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _ChipsDelegate extends SliverPersistentHeaderDelegate {
  final ExploreController ctrl;
  _ChipsDelegate({required this.ctrl});

  @override
  double get minExtent => 52;
  @override
  double get maxExtent => 52;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: overlapsContent
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 2))]
            : [],
      ),
      child: ExploreKategoriChips(ctrl: ctrl),
    );
  }

  @override
  bool shouldRebuild(_ChipsDelegate old) => false;
}
