import 'package:get/get.dart';
import '../models/borrowing_detail_model.dart';
import '../services/borrowing_service.dart';

class DetailPengembalianController extends GetxController {
  final int borrowingId;
  DetailPengembalianController({required this.borrowingId});

  final _service = BorrowingService();
  final isLoading = true.obs;
  final detail = Rxn<BorrowingDetailModel>();

  // Info dari proses pengembalian
  final koinEarned = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading(true);
    try {
      detail.value = await _service.getBorrowingDetail(borrowingId);

      // Ambil info tambahan dari arguments jika ada
      final args = Get.arguments;
      if (args is Map) {
        koinEarned.value = args['koin_earned'] ?? 0;
      }
    } catch (_) {
    } finally {
      isLoading(false);
    }
  }


}
