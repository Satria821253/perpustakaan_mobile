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
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody(ctrl)),
      // FAB perpanjangan — hanya tampil jika bisa perpanjang
      floatingActionButton: Obx(() {
        final detail = ctrl.detail.value;
        if (detail == null) return const SizedBox.shrink();
        final canExtend =
            detail.jumlahPerpanjangan < 3 && detail.status == 'dipinjam';
        if (!canExtend) return const SizedBox.shrink();
        return _ExtendFAB(ctrl: ctrl);
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
      title: const Text(
        'Detail Perpanjangan',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: 'Poppins',
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(DetailPerpanjangController ctrl) {
    if (ctrl.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF1565C0),
          strokeWidth: 2.5,
        ),
      );
    }

    if (ctrl.detail.value == null) {
      return _ErrorState(onRetry: ctrl.fetchAll);
    }

    return RefreshIndicator(
      onRefresh: ctrl.fetchAll,
      color: const Color(0xFF1565C0),
      strokeWidth: 2.5,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          children: [
            // Banner menunggu persetujuan
            Obx(() {
              if (!ctrl.isPolling.value) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PollingBanner(),
              );
            }),

            DpxBukuInfoCard(d: ctrl.detail.value!),
            const SizedBox(height: 14),
            DpxTimelineCard(ctrl: ctrl),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Banner polling
// ─────────────────────────────────────────────────────────────
class _PollingBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFF57C00),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menunggu persetujuan',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE65100),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Permintaan sedang diproses petugas perpustakaan',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[700],
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cloud_off_rounded,
                  size: 32, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat data',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Periksa koneksi internet kamu dan coba lagi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text(
                'Coba lagi',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1565C0),
                side: const BorderSide(color: Color(0xFF1565C0)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FAB ajukan perpanjangan
// ─────────────────────────────────────────────────────────────
class _ExtendFAB extends StatelessWidget {
  final DetailPerpanjangController ctrl;
  const _ExtendFAB({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => ctrl.showExtendDialog(),
          icon: const Icon(Icons.event_repeat_rounded, size: 18),
          label: const Text(
            'Ajukan perpanjangan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: const Color(0xFF1565C0).withValues(alpha: 0.35),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
} 