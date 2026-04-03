import 'package:ei_books/app/controllers/explore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'explore_book_card.dart';

class ExploreGrid extends StatelessWidget {
  final ExploreController ctrl;
  const ExploreGrid({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = ctrl.books;

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Obx(() {
                  final label = ctrl.searchQuery.value.isNotEmpty
                      ? 'Hasil Pencarian'
                      : ctrl.selectedKategoriIdx.value != 0
                          ? ctrl.categories[ctrl.selectedKategoriIdx.value - 1]
                                  ['name'] as String
                          : 'Semua Buku';
                  return Text(label,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          fontFamily: 'Poppins'));
                }),
                const Spacer(),
                Obx(() => Text(
                      '${ctrl.books.length} buku',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontFamily: 'Poppins'),
                    )),
              ],
            ),
            const SizedBox(height: 14),

            // Loading
            if (ctrl.isLoading.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF1565C0))),
              )

            // Empty
            else if (list.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text('Buku tidak ditemukan',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 15,
                              fontFamily: 'Poppins')),
                    ],
                  ),
                ),
              )

            // Grid
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.52,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                ),
                itemCount: list.length,
                itemBuilder: (_, i) => ExploreBookCard(buku: list[i]),
              ),
          ],
        ),
      );
    });
  }
}
