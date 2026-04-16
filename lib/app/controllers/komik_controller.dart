import 'package:get/get.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';

class KomikController extends GetxController {
  final _service = BookService();

  final selectedFilter = 0.obs;
  final filters = <String>['Semua'].obs;
  final genres = <Map<String, dynamic>>[].obs;

  final popularComics = <BookModel>[].obs;
  final newComics = <BookModel>[].obs;
  final localComics = <BookModel>[].obs;

  final isLoadingPopular = false.obs;
  final isLoadingNew = false.obs;
  final isLoadingLocal = false.obs;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    _loadGenres();
    fetchPopularComics();
    fetchNewComics();
    fetchLocalComics();
  }

  Future<void> _loadGenres() async {
    try {
      final data = await _service.getGenres();
      genres.assignAll(data);
      final genreNames = data.map((g) => g['name'] as String).toList();
      filters.assignAll(['Semua', ...genreNames]);
    } catch (_) {
      filters.assignAll(['Semua', 'Action', 'Fantasy', 'Romance', 'Horror']);
    }
  }

  Future<void> fetchPopularComics() async {
    isLoadingPopular(true);
    try {
      final genre = selectedFilter.value > 0
          ? _getGenreFromFilter(selectedFilter.value)
          : null;
      final books = await _service.getBooks(
        sort: 'popular',
        limit: 10,
        kategori: 'komik',
        genre: genre,
      );
      popularComics.assignAll(books.take(10).toList());
    } catch (_) {
      popularComics.clear();
    } finally {
      isLoadingPopular(false);
    }
  }

  Future<void> fetchNewComics() async {
    isLoadingNew(true);
    try {
      final genre = selectedFilter.value > 0
          ? _getGenreFromFilter(selectedFilter.value)
          : null;
      final books = await _service.getBooks(
        sort: 'newest',
        limit: 10,
        kategori: 'komik',
        genre: genre,
      );
      newComics.assignAll(books.take(10).toList());
    } catch (_) {
      newComics.clear();
    } finally {
      isLoadingNew(false);
    }
  }

  Future<void> fetchLocalComics() async {
    isLoadingLocal(true);
    try {
      final genre = selectedFilter.value > 0
          ? _getGenreFromFilter(selectedFilter.value)
          : null;
      final books = await _service.getBooks(
        sort: 'popular',
        limit: 20,
        kategori: 'komik',
        genre: genre,
      );
      localComics.assignAll(books);
    } catch (_) {
      localComics.clear();
    } finally {
      isLoadingLocal(false);
    }
  }

  void setFilter(int index) {
    selectedFilter(index);
    fetchPopularComics();
    fetchNewComics();
    fetchLocalComics();
  }

  String? _getGenreFromFilter(int index) {
    if (index > 0 && index - 1 < genres.length) {
      return genres[index - 1]['name'] as String?;
    }
    return null;
  }
}
