import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/majalah_controller.dart';
import 'widgets/majalah_top_bar.dart';
import 'widgets/majalah_filter_bar.dart';
import 'widgets/popular_section.dart';
import 'widgets/newly_added_section.dart';

class MajalahPage extends StatefulWidget {
  const MajalahPage({super.key});

  @override
  State<MajalahPage> createState() => _MajalahPageState();
}

class _MajalahPageState extends State<MajalahPage> {
  late final MajalahController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.isRegistered<MajalahController>()
        ? Get.find<MajalahController>()
        : Get.put(MajalahController());
    ctrl.fetchPopularMajalah();
    ctrl.fetchNewMajalah();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Column(
        children: [
          const MajalahTopBar(),
          const MajalahFilterBar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                const PopularSection(),
                const SizedBox(height: 8),
                const NewlyAddedSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
