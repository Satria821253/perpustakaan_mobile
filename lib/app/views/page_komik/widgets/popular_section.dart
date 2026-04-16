import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/komik_controller.dart';
import 'section_header.dart';
import 'popular_comic_card.dart';

class PopularSection extends StatelessWidget {
  const PopularSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<KomikController>();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Populer Minggu Ini'),
          const SizedBox(height: 12),
          Obx(() {
            if (ctrl.isLoadingPopular.value) {
              return const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (ctrl.popularComics.isEmpty) {
              return const SizedBox(
                height: 150,
                child: Center(child: Text('Tidak ada data')),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ctrl.popularComics
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: PopularComicCard(comic: c),
                      ),
                    )
                    .toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
