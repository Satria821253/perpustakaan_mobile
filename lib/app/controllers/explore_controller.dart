import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import '../services/preference_service.dart';

class ExploreController extends GetxController {
  final _service = BookService();
  final _prefService = PreferenceService();

  final searchQuery = ''.obs;
  final selectedKategoriIdx = 0.obs;
  final selectedSort = 'popular'.obs;
  final showFilter = false.obs;
  final books = <BookModel>[].obs;
  final isLoading = false.obs;
  final categories = <Map<String, dynamic>>[].obs;
  final genres = <Map<String, dynamic>>[].obs;
  final selectedGenreSlug = Rx<String?>(null);

  final rekomendasi = <BookModel>[].obs;
  final List<BookModel> allRekomendasi = [];
  final isLoadingRekomendasi = false.obs;

  final sortOptions = const [
    {'label': 'Terpopuler',  'value': 'popular'},
    {'label': 'Terbaru',     'value': 'newest'},
    {'label': 'Rating Tertinggi', 'value': 'rating'},
  ];

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    _prefService.onInit();
    _loadCategories();
    _loadGenres();
    fetchBooks();
    fetchRekomendasi();
  }

  Future<void> _loadGenres() async {
    try {
      final data = await _service.getGenres();
      genres.assignAll(data);
    } catch (_) {}
  }

  void openFilterSheet(BuildContext context) {
    showFilter(true);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      isScrollControlled: true,
      builder: (_) => _FilterBottomSheet(ctrl: this),
    ).then((_) => showFilter(false));
  }

  Future<void> fetchRekomendasi() async {
    isLoadingRekomendasi(true);
    try {
      final raw = await _prefService.getRecommendations();
      allRekomendasi.clear();
      allRekomendasi.addAll(raw.map((e) => BookModel.fromJson(e)));
      applyRekomendasiFilter();
    } catch (_) {
      rekomendasi.clear();
    } finally {
      isLoadingRekomendasi(false);
    }
  }

  void applyRekomendasiFilter() {
    var filtered = List<BookModel>.from(allRekomendasi);

    // Filter kategori
    if (selectedKategoriIdx.value != 0 && categories.isNotEmpty) {
      final selectedName =
          (categories[selectedKategoriIdx.value - 1]['name'] as String).toLowerCase();
      filtered = filtered.where((b) => b.kategori.toLowerCase() == selectedName).toList();
    }

    // Filter genre
    if (selectedGenreSlug.value != null) {
      final genreName = genres
          .firstWhereOrNull((g) => g['slug'] == selectedGenreSlug.value)?['name']
          ?.toString()
          .toLowerCase();
      if (genreName != null) {
        filtered = filtered.where((b) => b.genre.toLowerCase() == genreName).toList();
      } else {
        filtered = [];
      }
    }

    // Sort
    switch (selectedSort.value) {
      case 'newest':
        filtered.sort((a, b) => b.tahunTerbit.compareTo(a.tahunTerbit));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'popular':
      default:
        filtered.sort((a, b) => b.totalDipinjam.compareTo(a.totalDipinjam));
        break;
    }

    rekomendasi.assignAll(filtered);
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
        genre: selectedGenreSlug.value,
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
    applyRekomendasiFilter();
  }

  void setSearch(String q) {
    searchQuery(q);
    fetchBooks();
  }

  void setSort(String val) {
    selectedSort(val);
    fetchBooks();
  }

  void setGenre(String? slug) {
    selectedGenreSlug(slug);
    fetchBooks();
  }

  void toggleFilter() => showFilter(!showFilter.value);

  bool get hasActiveFilter => selectedGenreSlug.value != null;

  String get selectedSortLabel =>
      sortOptions.firstWhere((s) => s['value'] == selectedSort.value,
          orElse: () => sortOptions.first)['label']!;
}

class _FilterBottomSheet extends StatelessWidget {
  final ExploreController ctrl;
  const _FilterBottomSheet({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Filter & Urutkan',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Colors.black87)),
              const Spacer(),
              Obx(() => ctrl.hasActiveFilter
                  ? GestureDetector(
                      onTap: () {
                        ctrl.selectedGenreSlug.value = null;
                        ctrl.fetchBooks();
                        ctrl.applyRekomendasiFilter();
                        Navigator.pop(context);
                      },
                      child: const Text('Reset',
                          style: TextStyle(
                              color: Color(0xFF1565C0),
                              fontSize: 13,
                              fontFamily: 'Poppins')),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
          const SizedBox(height: 20),
          // Sort
          const Text('Urutkan',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Colors.black54)),
          const SizedBox(height: 10),
          Obx(() => Row(
            children: ctrl.sortOptions.map((s) {
              final active = ctrl.selectedSort.value == s['value'];
              return GestureDetector(
                onTap: () => ctrl.selectedSort(s['value']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFF1565C0) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? const Color(0xFF1565C0) : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(s['label']!,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                          color: active ? Colors.white : Colors.black54)),
                ),
              );
            }).toList(),
          )),
          const SizedBox(height: 20),
          // Genre
          const Text('Genre',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Colors.black54)),
          const SizedBox(height: 10),
          Obx(() {
            if (ctrl.genres.isEmpty) return const SizedBox.shrink();
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ctrl.genres.map((g) {
                final slug = g['slug'] as String;
                final name = g['name'] as String;
                final active = ctrl.selectedGenreSlug.value == slug;
                return GestureDetector(
                  onTap: () => ctrl.selectedGenreSlug.value = active ? null : slug,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFF1565C0) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active ? const Color(0xFF1565C0) : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(name,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                            color: active ? Colors.white : Colors.black54)),
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 24),
          // Tombol Terapkan
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ctrl.fetchBooks();
                ctrl.applyRekomendasiFilter();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Terapkan',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
