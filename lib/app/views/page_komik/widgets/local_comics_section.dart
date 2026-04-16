import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/komik_controller.dart';
import 'section_header.dart';
import 'local_comic_item.dart';

class LocalComicsSection extends StatelessWidget {
  const LocalComicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<KomikController>();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Komik Lokal'),
          const SizedBox(height: 4),
          Obx(() {
            if (ctrl.isLoadingLocal.value) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (ctrl.localComics.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(child: Text('Tidak ada data')),
              );
            }
            return Column(
              children: List.generate(ctrl.localComics.length, (i) {
                return Column(
                  children: [
                    LocalComicItem(comic: ctrl.localComics[i]),
                    if (i < ctrl.localComics.length - 1)
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Color(0xFFEEEEEE),
                      ),
                  ],
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}
