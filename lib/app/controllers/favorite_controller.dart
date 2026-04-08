import 'package:get/get.dart';
import '../services/favorite_service.dart';

class FavoriteController extends GetxController {
  static FavoriteController get to => Get.find();

  final _service = FavoriteService();

  final favorites = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final favoriteIds = <int>{}.obs;

  // filter state
  final selectedStatus = Rx<String?>(null); // 'tersedia' | 'dipinjam'
  final selectedSort = 'terbaru'.obs;       // 'terbaru' | 'terlama'

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    isLoading(true);
    try {
      final list = await _service.getFavorites(
        status: selectedStatus.value,
        sort: selectedSort.value,
      );
      favorites.assignAll(list);
      favoriteIds.assignAll(list.map((e) => e['book_id'] as int).toSet());
    } catch (_) {
    } finally {
      isLoading(false);
    }
  }

  void applyFilter({String? status, String? sort}) {
    selectedStatus.value = status;
    if (sort != null) selectedSort.value = sort;
    fetchFavorites();
  }

  void clearFilter() {
    selectedStatus.value = null;
    selectedSort.value = 'terbaru';
    fetchFavorites();
  }

  bool isFavorite(int bookId) => favoriteIds.contains(bookId);

  Future<void> toggleFavorite(int bookId) async {
    try {
      if (isFavorite(bookId)) {
        await _service.removeFavorite(bookId);
        favoriteIds.remove(bookId);
        favorites.removeWhere((e) => e['book_id'] == bookId);
        Get.snackbar('Dihapus', 'Buku dihapus dari favorit',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        await _service.addFavorite(bookId);
        favoriteIds.add(bookId);
        await fetchFavorites();
        Get.snackbar('Ditambahkan', 'Buku ditambahkan ke favorit',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
