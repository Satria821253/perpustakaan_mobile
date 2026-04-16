import 'package:get/get.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';

class MajalahController extends GetxController {
  final _service = BookService();

  final selectedFilter = 0.obs;
  final filters = <String>['Semua'].obs;
  final genres = <Map<String, dynamic>>[].obs;

  final popularMajalah = <BookModel>[].obs;
  final newMajalah = <BookModel>[].obs;

  final isLoadingPopular = false.obs;
  final isLoadingNew = false.obs;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    _loadGenres();
    fetchPopularMajalah();
    fetchNewMajalah();
  }

  Future<void> _loadGenres() async {
    try {
      final data = await _service.getGenres();
      genres.assignAll(data);
      final genreNames = data.map((g) => g['name'] as String).toList();
      filters.assignAll(['Semua', ...genreNames]);
    } catch (_) {
      filters.assignAll(['Semua', 'Teknologi', 'Fashion', 'Kuliner', 'Otomotif']);
    }
  }

  Future<void> fetchPopularMajalah() async {
    isLoadingPopular(true);
    try {
      final genre = selectedFilter.value > 0
          ? _getGenreFromFilter(selectedFilter.value)
          : null;
      final books = await _service.getBooks(
        sort: 'popular',
        limit: 10,
        kategori: 'majalah',
        genre: genre,
      );
      popularMajalah.assignAll(books.take(10).toList());
    } catch (_) {
      popularMajalah.clear();
    } finally {
      isLoadingPopular(false);
    }
  }

  Future<void> fetchNewMajalah() async {
    isLoadingNew(true);
    try {
      final genre = selectedFilter.value > 0
          ? _getGenreFromFilter(selectedFilter.value)
          : null;
      final books = await _service.getBooks(
        sort: 'newest',
        limit: 10,
        kategori: 'majalah',
        genre: genre,
      );
      newMajalah.assignAll(books.take(10).toList());
    } catch (_) {
      newMajalah.clear();
    } finally {
      isLoadingNew(false);
    }
  }

  void setFilter(int index) {
    selectedFilter(index);
    fetchPopularMajalah();
    fetchNewMajalah();
  }

  String? _getGenreFromFilter(int index) {
    if (index > 0 && index - 1 < genres.length) {
      return genres[index - 1]['name'] as String?;
    }
    return null;
  }
}
