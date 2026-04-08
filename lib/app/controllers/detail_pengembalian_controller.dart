import 'package:get/get.dart';
import '../models/borrowing_detail_model.dart';
import '../services/borrowing_service.dart';

class DetailPengembalianController extends GetxController {
  final int borrowingId;
  DetailPengembalianController({required this.borrowingId});

  final _service = BorrowingService();
  final isLoading = true.obs;
  final detail = Rxn<BorrowingDetailModel>();

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
    } catch (_) {
    } finally {
      isLoading(false);
    }
  }
}
