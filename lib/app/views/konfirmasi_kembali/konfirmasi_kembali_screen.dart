import 'package:ei_books/app/controllers/konfirmasi_kembali_controller.dart';
import 'package:ei_books/app/views/konfirmasi_kembali/widgets/kk_bottom_cta.dart';
import 'package:ei_books/app/views/konfirmasi_kembali/widgets/kk_buku_summary_card.dart';
import 'package:ei_books/app/views/konfirmasi_kembali/widgets/kk_denda_section.dart';
import 'package:ei_books/app/views/konfirmasi_kembali/widgets/kk_instruksi_card.dart';
import 'package:ei_books/app/views/konfirmasi_kembali/widgets/kk_ringkasan_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class KonfirmasiKembaliScreen extends StatelessWidget {
  final int borrowingId;
  const KonfirmasiKembaliScreen({super.key, required this.borrowingId});

  @override
  Widget build(BuildContext context) {
    Get.delete<KonfirmasiKembaliController>(tag: 'konfirmasi_kembali_$borrowingId', force: true);
    final ctrl = Get.put(
      KonfirmasiKembaliController(borrowingId: borrowingId),
      tag: 'konfirmasi_kembali_$borrowingId',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text('Konfirmasi Pengembalian',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)));
        }
        if (ctrl.detail.value == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                const Text('Gagal memuat data'),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: ctrl.fetchDetail,
                    child: const Text('Coba Lagi')),
              ],
            ),
          );
        }
        final d = ctrl.detail.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              KkBukuSummaryCard(ctrl: ctrl, d: d),
              const SizedBox(height: 14),
              KkRingkasanCard(ctrl: ctrl, d: d),
              const SizedBox(height: 14),
              if (ctrl.adaDenda && !(ctrl.detail.value?.dendaDibayar ?? false)) ...[
                KkDendaSection(ctrl: ctrl),
                const SizedBox(height: 14),
              ],
              KkInstruksiCard(quantity: d.quantity),
              const SizedBox(height: 90),
            ],
          ),
        );
      }),
      bottomNavigationBar: KkBottomCta(ctrl: ctrl),
    );
  }
}
