import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cerpen_controller.dart';
import 'widgets/cerpen_top_bar.dart';
import 'widgets/cerpen_filter_bar.dart';
import 'widgets/popular_section.dart';
import 'widgets/newly_added_section.dart';

class CerpenPage extends StatefulWidget {
  const CerpenPage({super.key});

  @override
  State<CerpenPage> createState() => _CerpenPageState();
}

class _CerpenPageState extends State<CerpenPage> {
  late final CerpenController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.isRegistered<CerpenController>()
        ? Get.find<CerpenController>()
        : Get.put(CerpenController());
    ctrl.fetchPopularCerpen();
    ctrl.fetchNewCerpen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Column(
        children: [
          const CerpenTopBar(),
          const CerpenFilterBar(),
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
