import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/krs_kode_card.dart';
import 'widgets/krs_info_widgets.dart';

class KodeReservasiScreen extends StatelessWidget {
  final String kode;
  final String judul;
  final String pengarang;
  final String? coverImage;
  final String expiresAt;
  final int quantity;
  final int sisaKuota;

  const KodeReservasiScreen({
    super.key,
    required this.kode,
    required this.judul,
    required this.pengarang,
    this.coverImage,
    required this.expiresAt,
    this.quantity = 1,
    this.sisaKuota = 0,
  });

  @override
  Widget build(BuildContext context) {
    final sudahDisalin = false.obs;

    return PopScope(
      canPop: false,
      child: Scaffold(
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
          title: const Text('Reservasi Berhasil',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins')),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header sukses
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_circle_rounded,
                                color: Color(0xFF1565C0), size: 40),
                          ),
                          const SizedBox(height: 12),
                          const Text('Reservasi Berhasil! 🎉',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                  fontFamily: 'Poppins')),
                          const SizedBox(height: 4),
                          Text(
                            'Tunjukkan kode ini ke petugas perpustakaan',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                fontFamily: 'Poppins'),
                            textAlign: TextAlign.center,
                          ),
                          if (quantity > 1) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$quantity stock dipinjam · Sisa kuota: $sisaKuota stock',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1565C0),
                                    fontFamily: 'Poppins'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    KrKodeCard(kode: kode, sudahDisalin: sudahDisalin),
                    const SizedBox(height: 16),
                    KrInfoBukuCard(
                      judul: judul,
                      pengarang: pengarang,
                      coverImage: coverImage,
                      expiresAt: expiresAt,
                    ),
                    const SizedBox(height: 16),
                    const KrLangkahCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Tombol selesai
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 12,
                      offset: const Offset(0, -3))
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Selesai',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
