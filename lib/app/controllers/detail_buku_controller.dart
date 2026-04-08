import 'package:get/get.dart';
import '../models/book_detail_model.dart';
import '../models/book_model.dart';
import '../services/book_detail_service.dart';
import '../services/favorite_service.dart';

class DetailBukuController extends GetxController {
  final int bookId;
  DetailBukuController({required this.bookId});

  final _detailService = BookDetailService();
  final _favoriteService = FavoriteService();

  final isLoading = true.obs;
  final buku = Rx<BookDetailModel?>(null);
  final isFavorit = false.obs;
  final selectedTab = 0.obs;
  final showFullDesc = false.obs;
  final bukuSerupa = <BookModel>[].obs;

  bool get tersedia =>
      (buku.value?.stok ?? 0) > 0 && buku.value?.status == 'tersedia';

  @override
  void onInit() {
    super.onInit();
    _detailService.onInit();
    _favoriteService.onInit();
    _loadAll();
  }

  Future<void> _loadAll() async {
    isLoading(true);
    try {
      final results = await Future.wait([
        _detailService.getDetail(bookId),
        _favoriteService.checkFavorite(bookId),
        _detailService.getBukuSerupa(bookId),
      ]);
      buku.value = results[0] as BookDetailModel;
      isFavorit.value = results[1] as bool;
      final rawSerupa = results[2] as List<Map<String, dynamic>>;
      bukuSerupa.value = rawSerupa.map((e) => BookModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak dapat memuat detail buku',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  @override
  Future<void> refresh() => _loadAll();

  void setTab(int i) => selectedTab(i);
  void toggleDesc() => showFullDesc(!showFullDesc.value);

  Future<void> toggleFavorit() async {
    final prev = isFavorit.value;
    isFavorit(!prev);
    try {
      if (prev) {
        await _favoriteService.removeFavorite(bookId);
      } else {
        await _favoriteService.addFavorite(bookId);
      }
    } catch (e) {
      isFavorit(prev);
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> pinjamBuku() async {
    final b = buku.value;
    if (b == null) return;
    Get.toNamed('/konfirmasi-reservasi', arguments: b);
  }

  void bukaPdf() {
    final b = buku.value;
    if (b == null) return;
    Get.toNamed('/baca-preview', arguments: {
      'book_id': b.id,
      'book_title': b.judul,
    });
  }
}
