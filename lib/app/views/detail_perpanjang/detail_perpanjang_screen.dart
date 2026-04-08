import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/detail_perpanjang_controller.dart';
import 'widgets/dp_buku_info_card.dart';
import 'widgets/dp_timeline_card.dart';

class DetailPerpanjangScreen extends StatelessWidget {
  final int borrowingId;
  const DetailPerpanjangScreen({super.key, required this.borrowingId});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(
      DetailPerpanjangController(borrowingId: borrowingId),
      tag: 'detail_perpanjang_$borrowingId',
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
        title: const Text('Detail Perpanjangan',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins')),
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
                const Text('Gagal memuat data',
                    style: TextStyle(fontFamily: 'Poppins')),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: ctrl.fetchAll,
                    child: const Text('Coba Lagi')),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: ctrl.fetchAll,
          color: const Color(0xFF1565C0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DpxBukuInfoCard(d: ctrl.detail.value!),
                const SizedBox(height: 14),
                DpxTimelineCard(ctrl: ctrl),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }
}
