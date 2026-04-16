import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/book_detail_model.dart';
import '../services/borrowing_service.dart';
import '../widgets/overlays/transaction_overlays.dart';
import 'profile_controller.dart';

class KonfirmasiReservasiController extends GetxController {
  final BookDetailModel buku;

  KonfirmasiReservasiController({required this.buku});

  final _service = BorrowingService();
  final isLoading = false.obs;
  final quantity = 1.obs;
  final activeBorrowings = 0.obs;
  final activeReservations = 0.obs; // jumlah kode reservasi aktif

  static const int maxPinjamanPerAnggota = 5;
  static const int maxReservasiAktif = 3; // max kode reservasi aktif

  int get maxQuantity {
    final sisaKuota = maxPinjamanPerAnggota - activeBorrowings.value;
    final stokTersedia = buku.stok;
    final result = min(sisaKuota, min(stokTersedia, 5)).clamp(0, 99);
    print(
      '[KONFIRMASI] sisaKuota=$sisaKuota, stok=$stokTersedia, maxQuantity=$result',
    );
    return result;
  }

  int get sisaKuota => (maxPinjamanPerAnggota - activeBorrowings.value).clamp(
    0,
    maxPinjamanPerAnggota,
  );

  void increment() {
    if (quantity.value < maxQuantity) quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    _fetchActiveBorrowings();
    _checkActiveReservations();
  }

  Future<void> _checkActiveReservations() async {
    try {
      // Cek jumlah kode reservasi yang masih aktif
      final response = await _service.get(
        '/api/borrowings/reservations?status=active',
      );
      if (response.statusCode == 200) {
        final data = response.body;
        activeReservations.value = (data['reservations'] as List).length;
        print('[KONFIRMASI] Active reservations: ${activeReservations.value}');
      }
    } catch (e) {
      print('[KONFIRMASI] Error checking active reservations: $e');
    }
  }

  Future<void> _fetchActiveBorrowings() async {
    try {
      print(
        '[KONFIRMASI] ProfileController registered: ${Get.isRegistered<ProfileController>()}',
      );
      // Coba ambil dari ProfileController dulu (lebih akurat)
      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        print(
          '[KONFIRMASI] sedangDipinjam from profile: ${profileCtrl.sedangDipinjam.value}',
        );
        activeBorrowings(profileCtrl.sedangDipinjam.value);
        print(
          '[KONFIRMASI] activeBorrowings=${profileCtrl.sedangDipinjam.value} (from profile), maxPinjaman=$maxPinjamanPerAnggota',
        );
      } else {
        // Fallback: fetch dari API
        final list = await _service.getBorrowings(status: 'dipinjam');
        activeBorrowings(list.length);
        print(
          '[KONFIRMASI] activeBorrowings=${list.length} (from API), maxPinjaman=$maxPinjamanPerAnggota',
        );
      }
      // pastikan quantity tidak melebihi sisa kuota
      if (quantity.value > maxQuantity) quantity(maxQuantity.clamp(1, 99));
    } catch (e) {
      print('[KONFIRMASI] error fetch borrowings: $e');
    }
  }

  Future<void> konfirmasi() async {
    if (isLoading.value) return;

    // Validasi: cek apakah sudah ada terlalu banyak kode aktif
    if (activeReservations.value >= maxReservasiAktif) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Reservasi Penuh',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          content: Text(
            'Anda sudah memiliki ${activeReservations.value} kode reservasi aktif. Silakan selesaikan reservasi yang ada terlebih dahulu atau tunggu hingga kode expired.',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Tutup')),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed('/riwayat-kode');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
              ),
              child: const Text('Lihat Kode'),
            ),
          ],
        ),
      );
      return;
    }

    isLoading(true);
    try {
      final result = await _service.reserveBuku(
        buku.id,
        quantity: quantity.value,
      );

      // Tampilkan overlay success
      ReservasiOverlay.showSuccess(
        message:
            'Buku berhasil direservasi. Silakan ambil di perpustakaan sesuai jadwal.',
        onComplete: () {
          // Redirect ke detail peminjaman atau kode reservasi
          final borrowingId = result['borrowing_id'] ?? result['id'];
          if (borrowingId != null) {
            Get.offNamed('/detail-peminjaman', arguments: borrowingId);
          } else {
            // Fallback ke kode reservasi jika tidak ada borrowing_id
            Get.offNamed(
              '/kode-reservasi',
              arguments: {
                'kode': result['code'] ?? result['kode'] ?? '',
                'judul': buku.judul,
                'author': buku.authorName,
                'coverImage': buku.coverImage,
                'expiresAt': result['expires_at'] ?? '',
                'quantity': result['quantity'] ?? quantity.value,
                'sisaKuota': result['sisa_kuota'] ?? 0,
              },
            );
          }
        },
      );
    } catch (e) {
      // Show error animation
      ReservasiOverlay.showCancelled(
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading(false);
    }
  }
}
