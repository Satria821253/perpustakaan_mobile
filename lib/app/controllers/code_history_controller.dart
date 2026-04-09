import 'package:get/get.dart';
import '../services/code_history_service.dart';
import '../models/reservation_code_model.dart';
import '../models/return_code_model.dart';

class CodeHistoryController extends GetxController {
  final _service = CodeHistoryService();

  final reservationCodes = <ReservationCodeModel>[].obs;
  final returnCodes = <ReturnCodeModel>[].obs;
  
  final isLoadingReservations = false.obs;
  final isLoadingReturns = false.obs;
  
  final selectedTab = 'reservasi'.obs;

  @override
  void onInit() {
    super.onInit();
    // Load all codes without filter
    loadReservationCodes();
    loadReturnCodes();
  }

  Future<void> loadReservationCodes({String? status}) async {
    try {
      isLoadingReservations(true);
      final codes = await _service.getReservationCodes(status: status);
      // Filter: hanya tampilkan yang aktif (belum dikonfirmasi, belum expired, belum returned)
      reservationCodes.value = codes.where((code) => 
        code.isActive && !code.isConfirmed && !code.isExpired && !code.isReturned
      ).toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat riwayat reservasi: $e');
    } finally {
      isLoadingReservations(false);
    }
  }

  Future<void> loadReturnCodes({String? status}) async {
    try {
      isLoadingReturns(true);
      final codes = await _service.getReturnCodes(status: status);
      // Filter: hanya tampilkan yang aktif (belum digunakan, belum expired)
      returnCodes.value = codes.where((code) => 
        code.isActive && !code.isUsed && !code.isExpired
      ).toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat riwayat kode pengembalian: $e');
    } finally {
      isLoadingReturns(false);
    }
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  Future<void> refreshCurrentTab() async {
    if (selectedTab.value == 'reservasi') {
      await loadReservationCodes();
    } else {
      await loadReturnCodes();
    }
  }
}
