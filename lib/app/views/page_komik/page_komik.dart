import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/komik_controller.dart';
import 'widgets/komik_top_bar.dart';
import 'widgets/komik_filter_bar.dart';
import 'widgets/popular_section.dart';
import 'widgets/newly_added_section.dart';
import 'widgets/local_comics_section.dart';

class KomikPage extends StatefulWidget {
  const KomikPage({super.key});

  @override
  State<KomikPage> createState() => _KomikPageState();
}

class _KomikPageState extends State<KomikPage> {
  late final KomikController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.isRegistered<KomikController>()
        ? Get.find<KomikController>()
        : Get.put(KomikController());
    ctrl.fetchPopularComics();
    ctrl.fetchNewComics();
    ctrl.fetchLocalComics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Column(
        children: [
          const KomikTopBar(),
          const KomikFilterBar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                const PopularSection(),
                const SizedBox(height: 8),
                const NewlyAddedSection(),
                const SizedBox(height: 8),
                const LocalComicsSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
