import 'package:ei_books/app/controllers/explore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/explore_header.dart';
import 'widgets/explore_kategori_chips.dart';
import 'widgets/explore_grid.dart';
import 'widgets/explore_filter_dropdown.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ExploreController());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: ExploreHeader(ctrl: ctrl)),
              SliverToBoxAdapter(child: ExploreKategoriChips(ctrl: ctrl)),
              SliverToBoxAdapter(child: ExploreGrid(ctrl: ctrl)),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
          Obx(() => ctrl.showFilter.value
              ? ExploreFilterDropdown(ctrl: ctrl)
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
