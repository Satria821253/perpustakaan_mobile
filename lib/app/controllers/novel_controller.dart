import 'package:get/get.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';

class NovelController extends GetxController {
  final _service = BookService();

  final selectedFilter = 0.obs;
  final filters = <String>['Semua'].obs;
  final genres = <Map<String, dynamic>>[].obs;

  final popularNovels = <BookModel>[].obs;
  final newNovels = <BookModel>[].obs;

  final isLoadingPopular = false.obs;
  final isLoadingNew = false.obs;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    _loadGenres();
    fetchPopularNovels();
    fetchNewNovels();
  }

  Future<void> _loadGenres() async {
    try {
      final data = await _service.getGenres();
      genres.assignAll(data);
      final genreNames = data.map((g) => g['name'] as String).toList();
      filters.assignAll(['Semua', ...genreNames]);
    } catch (_) {
      filters.assignAll(['Semua', 'Fantasi', 'Romansa', 'Sci-Fi', 'Thriller']);
    }
  }

  Future<void> fetchPopularNovels() async {
    isLoadingPopular(true);
    try {
      final genre = selectedFilter.value > 0
          ? _getGenreFromFilter(selectedFilter.value)
          : null;
      final books = await _service.getBooks(
        sort: 'popular',
        limit: 10,
        kategori: 'novel',
        genre: genre,
      );
      popularNovels.assignAll(books.take(10).toList());
    } catch (_) {
      popularNovels.clear();
    } finally {
      isLoadingPopular(false);
    }
  }

  Future<void> fetchNewNovels() async {
    isLoadingNew(true);
    try {
      final genre = selectedFilter.value > 0
          ? _getGenreFromFilter(selectedFilter.value)
          : null;
      final books = await _service.getBooks(
        sort: 'newest',
        limit: 10,
        kategori: 'novel',
        genre: genre,
      );
      newNovels.assignAll(books.take(10).toList());
    } catch (_) {
      newNovels.clear();
    } finally {
      isLoadingNew(false);
    }
  }

  void setFilter(int index) {
    selectedFilter(index);
    fetchPopularNovels();
    fetchNewNovels();
  }

  String? _getGenreFromFilter(int index) {
    if (index > 0 && index - 1 < genres.length) {
      return genres[index - 1]['name'] as String?;
    }
    return null;
  }
}
