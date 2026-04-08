import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/book_detail_model.dart';
import '../services/borrowing_service.dart';
import 'profile_controller.dart';

class KonfirmasiReservasiController extends GetxController {
  final BookDetailModel buku;

  KonfirmasiReservasiController({required this.buku});

  final _service = BorrowingService();
  final isLoading = false.obs;
  final quantity = 1.obs;
  final activeBorrowings = 0.obs; // jumlah pinjaman aktif saat ini

  static const int maxPinjamanPerAnggota = 5; // max limit perpustakaan

  int get maxQuantity {
    final sisaKuota = maxPinjamanPerAnggota - activeBorrowings.value;
    final stokTersedia = buku.stok;
    final result = min(sisaKuota, min(stokTersedia, 5)).clamp(0, 99);
    print('[KONFIRMASI] sisaKuota=$sisaKuota, stok=$stokTersedia, maxQuantity=$result');
    return result;
  }

  int get sisaKuota => (maxPinjamanPerAnggota - activeBorrowings.value).clamp(0, maxPinjamanPerAnggota);

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
  }

  Future<void> _fetchActiveBorrowings() async {
    try {
      print('[KONFIRMASI] ProfileController registered: ${Get.isRegistered<ProfileController>()}');
      // Coba ambil dari ProfileController dulu (lebih akurat)
      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        print('[KONFIRMASI] sedangDipinjam from profile: ${profileCtrl.sedangDipinjam.value}');
        activeBorrowings(profileCtrl.sedangDipinjam.value);
        print('[KONFIRMASI] activeBorrowings=${profileCtrl.sedangDipinjam.value} (from profile), maxPinjaman=$maxPinjamanPerAnggota');
      } else {
        // Fallback: fetch dari API
        final list = await _service.getBorrowings(status: 'dipinjam');
        activeBorrowings(list.length);
        print('[KONFIRMASI] activeBorrowings=${list.length} (from API), maxPinjaman=$maxPinjamanPerAnggota');
      }
      // pastikan quantity tidak melebihi sisa kuota
      if (quantity.value > maxQuantity) quantity(maxQuantity.clamp(1, 99));
    } catch (e) {
      print('[KONFIRMASI] error fetch borrowings: $e');
    }
  }

  Future<void> konfirmasi() async {
    isLoading(true);
    try {
      final result = await _service.reserveBuku(buku.id, quantity: quantity.value);
      Get.offNamed('/kode-reservasi', arguments: {
        'kode': result['code'] ?? result['kode'] ?? '',
        'judul': buku.judul,
        'pengarang': buku.pengarang,
        'coverImage': buku.coverImage,
        'expiresAt': result['expires_at'] ?? '',
        'quantity': result['quantity'] ?? quantity.value,
        'sisaKuota': result['sisa_kuota'] ?? 0,
      });
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading(false);
    }
  }
}
