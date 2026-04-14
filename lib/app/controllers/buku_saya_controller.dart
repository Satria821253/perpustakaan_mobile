import 'package:get/get.dart';
import '../models/my_book_model.dart';
import '../services/borrowing_service.dart';

class BukuSayaController extends GetxController {
  final _service = BorrowingService();

  final selectedTab = 0.obs;
  final pending = <MyBookModel>[].obs;
  final dipinjam = <MyBookModel>[].obs;
  final jatuhTempo = <MyBookModel>[].obs;
  final selesai = <MyBookModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading(true);
    try {
      final resPending = await _service.getBorrowings(status: 'pending');
      final resDipinjam = await _service.getBorrowings(status: 'dipinjam');
      final resTerlambat = await _service.getBorrowings(status: 'terlambat');
      final resSelesai = await _service.getBorrowings(status: 'dikembalikan');

      pending.assignAll(resPending.where((b) => b.status == 'pending').toList());
      dipinjam.assignAll(resDipinjam.where((b) => b.status == 'dipinjam').toList());

      // Jatuh tempo = terlambat BELUM bayar denda
      final semuaTerlambat = [
        ...resTerlambat.where((b) => b.status == 'terlambat'),
        ...resDipinjam.where((b) => b.hariTersisa < 0),
      ];
      final seen = <int>{};
      jatuhTempo.assignAll(
        semuaTerlambat
            .where((b) => seen.add(b.id) && !b.dendaDibayar)
            .toList(),
      );

      // Dipinjam juga tampung yang terlambat tapi sudah bayar denda
      final terlambatSudahBayar = semuaTerlambat
          .where((b) => b.dendaDibayar)
          .toList();
      dipinjam.addAll(terlambatSudahBayar);

      selesai.assignAll(resSelesai.where((b) => b.status == 'dikembalikan').toList());
    } catch (_) {} finally {
      isLoading(false);
    }
  }

  int get countPending => pending.length;
  int get countDipinjam => dipinjam.length;
  int get countJatuhTempo => jatuhTempo.length;
  int get countSelesai => selesai.length;
}
