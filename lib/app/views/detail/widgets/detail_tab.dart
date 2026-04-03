import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/detail_buku_controller.dart';
import 'detail_ulasan_tab.dart';

class DetailTabBar extends StatelessWidget {
  final DetailBukuController ctrl;
  const DetailTabBar({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final tabs = ['Deskripsi', 'Ulasan', 'Info'];
    return Obx(() => Row(
      children: List.generate(tabs.length, (i) {
        final active = ctrl.selectedTab.value == i;
        return GestureDetector(
          onTap: () => ctrl.setTab(i),
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              children: [
                Text(tabs[i],
                    style: TextStyle(
                        fontSize: 14, fontFamily: 'Poppins',
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                        color: active ? const Color(0xFF1565C0) : Colors.grey[500])),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2, width: active ? 40 : 0,
                  color: const Color(0xFF1565C0),
                ),
              ],
            ),
          ),
        );
      }),
    ));
  }
}

class DetailTabContent extends StatelessWidget {
  final DetailBukuController ctrl;
  const DetailTabContent({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (ctrl.selectedTab.value) {
        case 0: return _DeskripsiTab(ctrl: ctrl);
        case 1: return DetailUlasanTab(bookId: ctrl.bookId);
        case 2: return _InfoTab(ctrl: ctrl);
        default: return const SizedBox.shrink();
      }
    });
  }
}

class _DeskripsiTab extends StatelessWidget {
  final DetailBukuController ctrl;
  const _DeskripsiTab({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final desc = ctrl.buku.value?.deskripsi ?? '';
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(desc,
            maxLines: ctrl.showFullDesc.value ? null : 5,
            overflow: ctrl.showFullDesc.value ? null : TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Colors.black87,
                height: 1.6, fontFamily: 'Poppins')),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: ctrl.toggleDesc,
          child: Text(
            ctrl.showFullDesc.value ? 'Sembunyikan ›' : 'Baca selengkapnya ›',
            style: const TextStyle(color: Color(0xFF1565C0),
                fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
          ),
        ),
      ],
    ));
  }
}

class _InfoTab extends StatelessWidget {
  final DetailBukuController ctrl;
  const _InfoTab({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final b = ctrl.buku.value!;
    return Column(
      children: [
        _InfoRow(label: 'Penulis', value: b.pengarang),
        _InfoRow(label: 'Penerbit', value: b.penerbit),
        _InfoRow(label: 'Tahun Terbit', value: '${b.tahunTerbit}'),
        _InfoRow(label: 'Halaman', value: '${b.jumlahHalaman} halaman'),
        _InfoRow(label: 'Format', value: b.format),
        _InfoRow(label: 'Kategori', value: b.kategori),
        _InfoRow(label: 'Rating', value: '${b.rating} / 5.0'),
        _InfoRow(label: 'Stok', value: '${b.stok} tersedia'),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500], fontFamily: 'Poppins')),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}
