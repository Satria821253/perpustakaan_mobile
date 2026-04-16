import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/novel_controller.dart';
import 'section_header.dart';
import 'new_novel_card.dart';

class NewlyAddedSection extends StatelessWidget {
  const NewlyAddedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NovelController>();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Baru Ditambahkan'),
          const SizedBox(height: 12),
          Obx(() {
            if (ctrl.isLoadingNew.value) {
              return const SizedBox(
                height: 170,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (ctrl.newNovels.isEmpty) {
              return const SizedBox(
                height: 170,
                child: Center(child: Text('Tidak ada data')),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ctrl.newNovels
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: NewNovelCard(novel: c),
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
