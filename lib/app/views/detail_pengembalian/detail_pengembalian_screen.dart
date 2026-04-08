import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/detail_pengembalian_controller.dart';
import 'widgets/dp_sukses_card.dart';
import 'widgets/dp_info_buku_card.dart';
import 'widgets/dp_detail_card.dart';
import 'widgets/dp_denda_card.dart';
import 'widgets/dp_timeline_card.dart';

class DetailPengembalianScreen extends StatelessWidget {
  final int borrowingId;
  const DetailPengembalianScreen({super.key, required this.borrowingId});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(
      DetailPengembalianController(borrowingId: borrowingId),
      tag: 'detail_kembali_$borrowingId',
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text('Detail Pengembalian',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
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
              DpSuksesCard(d: d),
              const SizedBox(height: 14),
              DpInfoBukuCard(d: d),
              const SizedBox(height: 14),
              DpDetailCard(d: d),
              const SizedBox(height: 14),
              if (d.adaDenda) ...[
                DpDendaCard(d: d),
                const SizedBox(height: 14),
              ],
              DpTimelineCard(ctrl: ctrl),
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
    );
  }
}
