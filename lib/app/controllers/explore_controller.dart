import 'package:get/get.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';

class ExploreController extends GetxController {
  final _service = BookService();

  final searchQuery = ''.obs;
  final selectedKategoriIdx = 0.obs;
  final selectedSort = 'popular'.obs;
  final showFilter = false.obs;
  final books = <BookModel>[].obs;
  final isLoading = false.obs;
  final categories = <Map<String, dynamic>>[].obs;

  final sortOptions = const [
    {'label': 'Terpopuler',       'value': 'popular'},
    {'label': 'Terbaru',          'value': 'newest'},
    {'label': 'Rating Tertinggi', 'value': 'rating'},
  ];

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    _loadCategories();
    fetchBooks();
  }

  Future<void> _loadCategories() async {
    try {
      final data = await _service.getCategories();
      categories.assignAll(data);
    } catch (_) {}
  }

  Future<void> fetchBooks() async {
    isLoading(true);
    try {
      final slug = selectedKategoriIdx.value == 0
          ? null
          : categories[selectedKategoriIdx.value - 1]['slug'] as String?;
      final hasil = await _service.getBooks(
        sort: selectedSort.value,
        limit: 40,
        kategori: slug,
        search: searchQuery.value.trim().isEmpty ? null : searchQuery.value.trim(),
      );
      books.assignAll(hasil);
    } catch (_) {
      books.clear();
    } finally {
      isLoading(false);
    }
  }

  void setKategori(int i) {
    selectedKategoriIdx(i);
    fetchBooks();
  }

  void setSearch(String q) {
    searchQuery(q);
    fetchBooks();
  }

  void setSort(String val) {
    selectedSort(val);
    showFilter(false);
    fetchBooks();
  }

  void toggleFilter() => showFilter(!showFilter.value);

  String get selectedSortLabel =>
      sortOptions.firstWhere((s) => s['value'] == selectedSort.value,
          orElse: () => sortOptions.first)['label']!;
}
