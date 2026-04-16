import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/novel_controller.dart';
import 'widgets/novel_top_bar.dart';
import 'widgets/novel_filter_bar.dart';
import 'widgets/popular_section.dart';
import 'widgets/newly_added_section.dart';

class NovelPage extends StatelessWidget {
  const NovelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Column(
        children: [
          const NovelTopBar(),
          const NovelFilterBar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                const _NovelDataLoader(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NovelDataLoader extends StatefulWidget {
  const _NovelDataLoader();

  @override
  State<_NovelDataLoader> createState() => _NovelDataLoaderState();
}

class _NovelDataLoaderState extends State<_NovelDataLoader> {
  late final NovelController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.isRegistered<NovelController>()
        ? Get.find<NovelController>()
        : Get.put(NovelController());
    ctrl.fetchPopularNovels();
    ctrl.fetchNewNovels();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [PopularSection(), SizedBox(height: 8), NewlyAddedSection()],
    );
  }
}
