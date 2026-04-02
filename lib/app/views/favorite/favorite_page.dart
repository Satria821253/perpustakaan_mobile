import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favorite_controller.dart';
import 'widgets/favorite_item.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  void _showFilterSheet(FavoriteController ctrl) {
    final tempStatus = Rx<String?>(ctrl.selectedStatus.value);
    final tempSort = ctrl.selectedSort.value.obs;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Filter Favorit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins', color: Colors.black87)),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    tempStatus.value = null;
                    tempSort.value = 'terbaru';
                  },
                  child: const Text('Reset',
                      style: TextStyle(color: Color(0xFF1565C0), fontFamily: 'Poppins')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Status',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins', color: Colors.black87)),
            const SizedBox(height: 8),
            Obx(() => Wrap(
              spacing: 8,
              children: ['tersedia', 'dipinjam'].map((s) {
                final selected = tempStatus.value == s;
                return GestureDetector(
                  onTap: () => tempStatus.value = selected ? null : s,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF1565C0) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: selected ? const Color(0xFF1565C0) : Colors.grey[300]!),
                    ),
                    child: Text(s == 'tersedia' ? 'Tersedia' : 'Dipinjam',
                        style: TextStyle(
                            fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w500,
                            color: selected ? Colors.white : Colors.black87)),
                  ),
                );
              }).toList(),
            )),
            const SizedBox(height: 16),
            const Text('Urutkan',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins', color: Colors.black87)),
            const SizedBox(height: 8),
            Obx(() => Wrap(
              spacing: 8,
              children: ['terbaru', 'terlama'].map((s) {
                final selected = tempSort.value == s;
                return GestureDetector(
                  onTap: () => tempSort.value = s,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF1565C0) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: selected ? const Color(0xFF1565C0) : Colors.grey[300]!),
                    ),
                    child: Text(s == 'terbaru' ? 'Terbaru' : 'Terlama',
                        style: TextStyle(
                            fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w500,
                            color: selected ? Colors.white : Colors.black87)),
                  ),
                );
              }).toList(),
            )),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  ctrl.applyFilter(status: tempStatus.value, sort: tempSort.value);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Terapkan Filter',
                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                        fontSize: 14, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(FavoriteController());
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('Favorit Saya',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 16)),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(() {
            final hasFilter = ctrl.selectedStatus.value != null ||
                ctrl.selectedSort.value != 'terbaru';
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: () => _showFilterSheet(ctrl),
                ),
                if (hasFilter)
                  Positioned(
                    right: 8, top: 8,
                    child: Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(
                          color: Color(0xFFFFD600), shape: BoxShape.circle),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF1565C0),
        onRefresh: ctrl.fetchFavorites,
        child: Obx(() {
          if (ctrl.isLoading.value && ctrl.favorites.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)));
          }
          if (ctrl.favorites.isEmpty) {
            return ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite_border, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text('Belum ada buku favorit',
                            style: TextStyle(color: Colors.grey[500], fontFamily: 'Poppins', fontSize: 14)),
                        const SizedBox(height: 6),
                        Text('Tambahkan buku favorit dari halaman detail buku',
                            style: TextStyle(color: Colors.grey[400], fontFamily: 'Poppins', fontSize: 12),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: ctrl.favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => FavoriteItem(
              item: ctrl.favorites[i],
              onRemove: () => ctrl.toggleFavorite(ctrl.favorites[i]['book_id']),
            ),
          );
        }),
      ),
    );
  }
}
