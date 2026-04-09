import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/app_config.dart';
import '../services/preference_service.dart';
import '../widgets/overlays/transaction_overlays.dart';

class PembayaranController extends GetxController {
  final int borrowingId;
  PembayaranController({required this.borrowingId});

  final RxBool isLoading = false.obs;
  final RxBool isLoadingData = false.obs;
  final RxString selectedMetode = ''.obs;
  final RxString selectedEwallet = ''.obs;
  final RxBool ewalletExpanded = false.obs;

  // Data dari API
  final Rx<Map<String, dynamic>> buku = Rx({});
  final Rx<Map<String, dynamic>> user = Rx({});

  int get totalDenda => buku.value['total_denda'] as int? ?? 0;
  int get saldoKoin => user.value['saldo_koin'] as int? ?? 0;
  bool get koinCukup => saldoKoin >= totalDenda;

  final ewallets = [
    {'id': 'gopay', 'label': 'GoPay', 'color': const Color(0xFF00A651), 'short': 'GO'},
    {'id': 'ovo', 'label': 'OVO', 'color': const Color(0xFF4C3494), 'short': 'OVO'},
    {'id': 'dana', 'label': 'DANA', 'color': const Color(0xFF118EEA), 'short': 'DANA'},
    {'id': 'shopeepay', 'label': 'ShopeePay', 'color': const Color(0xFFEE4D2D), 'short': 'SPay'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchBorrowingDetail();
  }

  Future<void> fetchBorrowingDetail() async {
    try {
      isLoadingData(true);
      
      final token = await PreferenceService.getToken();
      
      // Get borrowing detail
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/borrowings/borrowings/$borrowingId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final b = data['borrowing'];
        
        // Hitung denda
        final daysLate = (b['hari_tersisa'] ?? 0) < 0 ? (b['hari_tersisa'] as int).abs() : 0;
        final dendaPerHari = 1000; // dari settings
        final totalDenda = daysLate * dendaPerHari;
        
        buku.value = {
          'judul': b['book_judul'] ?? 'Unknown',
          'penulis': b['pengarang'] ?? 'Unknown',
          'cover': b['cover_image'],
          'jatuh_tempo': b['tanggal_kembali_formatted'] ?? '-',
          'status': daysLate > 0 ? 'terlambat' : 'aktif',
          'hari_terlambat': daysLate,
          'denda_per_hari': dendaPerHari,
          'total_denda': totalDenda,
        };
      }
      
      // Get user koin
      final userResponse = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/user/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (userResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        user.value = {
          'saldo_koin': userData['koin'] ?? 0,
          'koin_dibutuhkan': totalDenda,
        };
      }
      
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingData(false);
    }
  }

  void selectMetode(String metode) {
    selectedMetode(metode);
    if (metode != 'ewallet') {
      ewalletExpanded(false);
      selectedEwallet('');
    }
  }

  void toggleEwallet() {
    if (selectedMetode.value == 'ewallet') {
      ewalletExpanded(!ewalletExpanded.value);
    } else {
      selectedMetode('ewallet');
      ewalletExpanded(true);
    }
  }

  void selectEwallet(String id) {
    selectedEwallet(id);
    selectedMetode('ewallet');
  }

  bool get bisaKonfirmasi {
    if (selectedMetode.value == 'ewallet') return selectedEwallet.value.isNotEmpty;
    if (selectedMetode.value == 'koin') return koinCukup;
    return selectedMetode.value.isNotEmpty;
  }

  String get labelMetodeTerpilih {
    switch (selectedMetode.value) {
      case 'kasir': return 'Bayar di Perpustakaan';
      case 'ewallet':
        final e = ewallets.firstWhere(
          (e) => e['id'] == selectedEwallet.value,
          orElse: () => {'label': 'E-Wallet'},
        );
        return e['label'] as String;
      case 'koin': return 'Koin Aplikasi';
      case 'qr': return 'QR Code';
      default: return '';
    }
  }

  Future<void> konfirmasi() async {
    if (!bisaKonfirmasi) {
      Get.snackbar('Perhatian', 'Pilih metode pembayaran terlebih dahulu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[100], colorText: Colors.orange[900]);
      return;
    }

    try {
      isLoading(true);
      
      // Tentukan payment_method
      String paymentMethod = '';
      if (selectedMetode.value == 'kasir') {
        paymentMethod = 'kasir';
      } else if (selectedMetode.value == 'ewallet') {
        paymentMethod = selectedEwallet.value; // gopay, ovo, dana, shopeepay
      } else if (selectedMetode.value == 'koin') {
        paymentMethod = 'koin';
      } else if (selectedMetode.value == 'qr') {
        paymentMethod = 'qris';
      }
      
      final token = await PreferenceService.getToken();
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/borrowings/pay-fine-before-return'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'borrowing_id': borrowingId,
          'payment_method': paymentMethod,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        Get.back(result: true); // Kembali dengan result success
        
        // Show success animation
        PembayaranOverlay.showSuccess(
          message: data['message'] ?? 'Denda sebesar Rp ${_fmt(totalDenda)} telah dibayar',
        );
      } else {
        final error = jsonDecode(response.body);
        
        // Show error animation
        PembayaranOverlay.showError(
          message: error['error'] ?? 'Pembayaran gagal. Silakan coba lagi.',
        );
      }
    } catch (e) {
      // Show error animation
      PembayaranOverlay.showError(
        message: 'Terjadi kesalahan: $e',
      );
    } finally {
      isLoading(false);
    }
  }

  String _fmt(int n) => n == 0 ? '0' : n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}
