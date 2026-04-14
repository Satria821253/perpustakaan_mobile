import 'package:get/get.dart';
import '../models/my_book_model.dart';
import '../models/extension_request_model.dart';
import '../services/borrowing_service.dart';
import '../services/koin_service.dart';

class RiwayatController extends GetxController {
  final _service = BorrowingService();
  final _koinService = KoinService();

  final tabIndex = 0.obs;
  final isLoadingPinjam = true.obs;
  final isLoadingKembali = true.obs;
  final isLoadingPerpanjang = true.obs;
  final isLoadingTransaksi = true.obs;
  final listPinjam = <MyBookModel>[].obs;
  final listKembali = <MyBookModel>[].obs;
  final listPerpanjang = <ExtensionRequestModel>[].obs;
  final listTransaksi = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    _koinService.onInit();
    fetchPinjam();
    fetchKembali();
    fetchPerpanjang();
    fetchTransaksi();
  }

  Future<void> fetchPinjam() async {
    isLoadingPinjam(true);
    try {
      final results = await Future.wait([
        _service.getBorrowings(status: 'dipinjam'),
        _service.getBorrowings(status: 'terlambat'),
        _service.getBorrowings(status: 'reservasi'),
      ]);
      listPinjam.assignAll([...results[0], ...results[1], ...results[2]]);
    } finally {
      isLoadingPinjam(false);
    }
  }

  Future<void> fetchKembali() async {
    isLoadingKembali(true);
    try {
      final data = await _service.getBorrowings(status: 'dikembalikan');
      listKembali.assignAll(data);
    } finally {
      isLoadingKembali(false);
    }
  }

  Future<void> fetchPerpanjang() async {
    isLoadingPerpanjang(true);
    try {
      final data = await _service.getAllExtensionRequests();
      listPerpanjang.assignAll(
          data.map((e) => ExtensionRequestModel.fromJson(e)).toList());
    } finally {
      isLoadingPerpanjang(false);
    }
  }

  Future<void> fetchTransaksi() async {
    isLoadingTransaksi(true);
    try {
      final data = await _koinService.getPaymentHistory();
      listTransaksi.assignAll(data);
    } catch (_) {
      listTransaksi.clear();
    } finally {
      isLoadingTransaksi(false);
    }
  }

  @override
  void refresh() {
    fetchPinjam();
    fetchKembali();
    fetchPerpanjang();
    fetchTransaksi();
  }
}
