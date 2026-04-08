import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/buku_saya_controller.dart';
import 'widgets/buku_saya_widgets.dart';
import 'widgets/card_dipinjam.dart';
import 'widgets/card_jatuh_tempo.dart';

class BukuSayaPage extends StatelessWidget {
  const BukuSayaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.isRegistered<BukuSayaController>()
        ? Get.find<BukuSayaController>()
        : Get.put(BukuSayaController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        body: Column(
          children: [
            // Header biru
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20,
                right: 20,
                bottom: 16,
              ),
              child: const Center(
                child: Text(
                  'Buku Saya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Tab switcher
            _TabSwitcher(ctrl: ctrl),

            // Content
            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF1565C0)));
                }
                return RefreshIndicator(
                  color: const Color(0xFF1565C0),
                  onRefresh: ctrl.fetchAll,
                  child: _TabContent(ctrl: ctrl),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabSwitcher extends StatelessWidget {
  final BukuSayaController ctrl;
  const _TabSwitcher({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final tabs = ['Dipinjam', 'Jatuh Tempo', 'Selesai'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Obx(() {
          return Row(
            children: List.generate(tabs.length, (i) {
              final active = ctrl.selectedTab.value == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => ctrl.selectedTab(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFF1565C0) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: active
                          ? [BoxShadow(
                              color: const Color(0xFF1565C0).withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3))]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        tabs[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                          color: active ? Colors.white : Colors.grey[600],
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final BukuSayaController ctrl;
  const _TabContent({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (ctrl.selectedTab.value) {
        case 0:
          final normal = ctrl.dipinjam.where((b) => b.hariTersisa > 3).toList();
          final segera = ctrl.dipinjam.where((b) => b.hariTersisa <= 3 && b.hariTersisa >= 0).toList();
          if (normal.isEmpty && segera.isEmpty) {
            return const EmptyState(label: 'Belum ada buku yang dipinjam');
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              if (normal.isNotEmpty) ...[
                SectionLabel(label: 'Sedang Dipinjam'),
                const SizedBox(height: 10),
                ...normal.map((b) => CardDipinjam(buku: b)),
                const SizedBox(height: 8),
              ],
              if (segera.isNotEmpty) ...[
                SectionLabel(label: 'Segera Dikembalikan'),
                const SizedBox(height: 10),
                ...segera.map((b) => CardDipinjam(buku: b)),
              ],
            ],
          );

        case 1:
          if (ctrl.jatuhTempo.isEmpty) {
            return const EmptyState(label: 'Semua buku masih dalam batas waktu pengembalian');
          }
          final segera = ctrl.jatuhTempo.where((b) => b.hariTersisa >= 0).toList();
          final terlambat = ctrl.jatuhTempo.where((b) => b.hariTersisa < 0).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              if (segera.isNotEmpty) ...[
                SectionLabel(label: 'Jatuh Tempo'),
                const SizedBox(height: 10),
                ...segera.map((b) => CardJatuhTempo(buku: b)),
                const SizedBox(height: 8),
              ],
              if (terlambat.isNotEmpty) ...[
                SectionLabel(label: 'Terlambat'),
                const SizedBox(height: 10),
                ...terlambat.map((b) => CardJatuhTempo(buku: b)),
              ],
            ],
          );

        case 2:
          if (ctrl.selesai.isEmpty) {
            return const EmptyState(label: 'Belum ada riwayat pengembalian');
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              SectionLabel(label: 'Selesai Dikembalikan'),
              const SizedBox(height: 10),
              ...ctrl.selesai.map((b) => CardSelesai(buku: b)),
            ],
          );

        default:
          return const SizedBox.shrink();
      }
    });
  }
}
