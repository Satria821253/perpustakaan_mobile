import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/koin_service.dart';
import '../services/borrowing_service.dart';
import '../widgets/overlays/transaction_overlays.dart';
import 'detail_peminjaman_controller.dart';

class PembayaranController extends GetxController {
  final int borrowingId;
  PembayaranController({required this.borrowingId});

  final _koinService = KoinService();
  final _borrowingService = BorrowingService();

  final isLoading = false.obs;
  final isLoadingData = false.obs;
  final selectedMetode = ''.obs;
  final selectedEwallet = ''.obs;
  final ewalletExpanded = false.obs;

  final Rx<Map<String, dynamic>> buku = Rx({});
  final Rx<Map<String, dynamic>> user = Rx({});

  int get totalDenda => buku.value['total_denda'] as int? ?? 0;
  int get saldoKoin => user.value['saldo_koin'] as int? ?? 0;
  int get coinValue => user.value['coin_value'] as int? ?? 500; // 1 koin = Rp500
  int get saldoKoinRupiah => saldoKoin * coinValue;
  bool get koinCukup => saldoKoinRupiah >= totalDenda;

  final ewallets = [
    {'id': 'gopay', 'label': 'GoPay', 'color': const Color(0xFF00A651), 'short': 'GO'},
    {'id': 'ovo', 'label': 'OVO', 'color': const Color(0xFF4C3494), 'short': 'OVO'},
    {'id': 'dana', 'label': 'DANA', 'color': const Color(0xFF118EEA), 'short': 'DANA'},
    {'id': 'shopeepay', 'label': 'ShopeePay', 'color': const Color(0xFFEE4D2D), 'short': 'SPay'},
  ];

  @override
  void onInit() {
    super.onInit();
    _koinService.onInit();
    _borrowingService.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoadingData(true);
      await Future.wait([_fetchBorrowingDetail(), _fetchKoinBalance()]);
    } finally {
      isLoadingData(false);
    }
  }

  Future<void> _fetchBorrowingDetail() async {
    try {
      final detail = await _borrowingService.getBorrowingDetail(borrowingId);
      print('[PEMBAYARAN] borrowingId: $borrowingId');
      print('[PEMBAYARAN] denda dari API: ${detail.denda}');
      print('[PEMBAYARAN] hariTerlambat: ${detail.hariTerlambat}');
      print('[PEMBAYARAN] dendaDibayar: ${detail.dendaDibayar}');
      buku.value = {
        'judul': detail.bookJudul,
        'penulis': detail.pengarang,
        'cover': detail.coverImage,
        'jatuh_tempo': detail.tanggalKembaliFormatted,
        'status': detail.terlambat ? 'terlambat' : 'aktif',
        'hari_terlambat': detail.hariTerlambat,
        'denda_per_hari': detail.denda > 0 && detail.hariTerlambat > 0
            ? detail.denda ~/ detail.hariTerlambat
            : 1000,
        'total_denda': detail.denda,
      };
    } catch (e) {
      print('[PEMBAYARAN] ERROR fetchBorrowingDetail: $e');
      Get.snackbar('Error', 'Gagal memuat data peminjaman',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _fetchKoinBalance() async {
    try {
      final balance = await _koinService.getBalance();
      print('[PEMBAYARAN] balance raw: $balance');
      print('[PEMBAYARAN] saldo koin: ${balance['balance']}');
      print('[PEMBAYARAN] coin_value: ${balance['coin_value']}');
      user.value = {
        'saldo_koin': balance['balance'] as int? ?? 0,
        'coin_value': balance['coin_value'] as int? ?? 500,
        'koin_dibutuhkan': totalDenda,
      };
      print('[PEMBAYARAN] saldoKoinRupiah setelah set: $saldoKoinRupiah');
      print('[PEMBAYARAN] koinCukup setelah set: $koinCukup');
    } catch (e) {
      print('[PEMBAYARAN] ERROR fetchKoinBalance: $e');
      user.value = {'saldo_koin': 0, 'coin_value': 500, 'koin_dibutuhkan': totalDenda};
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
    if (selectedMetode.value == 'ewallet') return false; // sedang dikembangkan
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

      if (selectedMetode.value == 'koin') {
        final koinDibutuhkan = (totalDenda / coinValue).ceil();
        print('[PEMBAYARAN] metode: koin');
        print('[PEMBAYARAN] totalDenda: $totalDenda');
        print('[PEMBAYARAN] coinValue: $coinValue');
        print('[PEMBAYARAN] saldoKoin: $saldoKoin');
        print('[PEMBAYARAN] saldoKoinRupiah: $saldoKoinRupiah');
        print('[PEMBAYARAN] koinDibutuhkan: $koinDibutuhkan');
        print('[PEMBAYARAN] koinCukup: $koinCukup');
        final result = await _koinService.bayarDendaKoin(
          borrowingId: borrowingId,
          amount: koinDibutuhkan,
        );
        print('[PEMBAYARAN] response: $result');
        _navigateAfterSuccess(
          result['message'] as String? ?? 'Denda sebesar Rp ${_fmt(totalDenda)} telah dibayar dengan koin',
        );
      } else {
        print('[PEMBAYARAN] metode: ${selectedMetode.value}');
        print('[PEMBAYARAN] totalDenda: $totalDenda');
        await _borrowingService.bayarDendaSebelumKembali(
          borrowingId: borrowingId,
          metode: selectedMetode.value == 'qr' ? 'qris' : selectedMetode.value,
        );
        print('[PEMBAYARAN] bayar ${selectedMetode.value} sukses');
        _navigateAfterSuccess('Pembayaran berhasil diproses');
      }
    } catch (e) {
      print('[PEMBAYARAN] ERROR: $e');
      final msg = e.toString().replaceFirst('Exception: ', '');
      PembayaranOverlay.showError(message: msg);
    } finally {
      isLoading(false);
    }
  }

  void _navigateAfterSuccess(String message) {
    PembayaranOverlay.showSuccess(
      message: message,
      onComplete: () {
        // Refresh detail peminjaman setelah bayar
        Get.offNamed('/detail-peminjaman', arguments: borrowingId)?.then((_) {
          // Trigger refresh di detail peminjaman controller
          try {
            final detailCtrl = Get.find<DetailPeminjamanController>();
            detailCtrl.fetchDetail();
          } catch (_) {}
        });
      },
    );
  }

  String _fmt(int n) => n == 0
      ? '0'
      : n.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}
