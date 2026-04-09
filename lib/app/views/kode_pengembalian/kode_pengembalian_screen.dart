import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/kode_pengembalian_controller.dart';
import 'widgets/kp_sukses_header.dart';
import 'widgets/kp_kode_utama_card.dart';
import 'widgets/kp_timer_card.dart';
import 'widgets/kp_info_langkah.dart';

class KodePengembalianScreen extends StatelessWidget {
  final int borrowingId;
  final String kodePengembalian;
  final String judulBuku;
  final String tanggalKembali;

  const KodePengembalianScreen({
    super.key,
    required this.borrowingId,
    required this.kodePengembalian,
    required this.judulBuku,
    required this.tanggalKembali,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(
      KodePengembalianController(
        kode: kodePengembalian,
        judulBuku: judulBuku,
        tanggalKembali: tanggalKembali,
        borrowingId: borrowingId,
      ),
      tag: 'kode_kembali_$borrowingId',
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text('Kode Pengembalian',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            KpSuksesHeader(ctrl: ctrl),
            const SizedBox(height: 20),
            KpKodeUtamaCard(ctrl: ctrl),
            const SizedBox(height: 16),
            KpTimerCard(ctrl: ctrl),
            const SizedBox(height: 16),
            const KpLangkahCard(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: ctrl.isCekLoading.value ? null : ctrl.cekStatus,
                icon: ctrl.isCekLoading.value
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1565C0)))
                    : const Icon(Icons.refresh_rounded, size: 18),
                label: Text(ctrl.isCekLoading.value
                    ? 'Mengecek...'
                    : 'Sudah ke Petugas? Cek Status'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1565C0),
                  side: const BorderSide(color: Color(0xFF1565C0)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const SizedBox.shrink(),
    );
  }
}
