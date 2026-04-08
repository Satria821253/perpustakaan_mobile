import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import '../services/preference_service.dart';

class HomeController extends GetxController {
  final currentNavIndex = 0.obs;
  final currentBannerIndex = 0.obs;

  final bukuTerbaru = <BookModel>[].obs;
  final bukuPopuler = <BookModel>[].obs;
  final isLoadingTerbaru = false.obs;
  final isLoadingPopuler = false.obs;
  final searchResults = <BookModel>[].obs;
  final isLoadingSearch = false.obs;
  final searchQuery = ''.obs;

  // Filter
  final categories = <Map<String, dynamic>>[].obs;
  final genres = <Map<String, dynamic>>[].obs;
  final selectedKategori = Rx<Map<String, dynamic>?>(null);
  final selectedGenre = Rx<Map<String, dynamic>?>(null);
  final isLoadingFilter = false.obs;

  final lokasi = ''.obs;

  final rekomendasi = <BookModel>[].obs;
  final isLoadingRekomendasi = false.obs;

  final _bookService = BookService();
  final _prefService = PreferenceService();

  @override
  void onInit() {
    super.onInit();
    _bookService.onInit();
    _prefService.onInit();
    fetchBukuTerbaru();
    fetchBukuPopuler();
    fetchRekomendasi();
    _fetchLokasi();
    fetchFilterData();
  }

  Future<void> fetchFilterData() async {
    isLoadingFilter(true);
    try {
      final results = await Future.wait([
        _bookService.getCategories(),
        _bookService.getGenres(),
      ]);
      categories.assignAll(results[0]);
      genres.assignAll(results[1]);
    } catch (_) {} finally {
      isLoadingFilter(false);
    }
  }

  Future<void> _fetchLokasi() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          p.subAdministrativeArea,
          p.administrativeArea,
        ].where((s) => s != null && s.isNotEmpty).join(', ');
        lokasi(parts);
      }
    } catch (_) {}
  }

  Future<void> fetchBukuTerbaru() async {
    isLoadingTerbaru(true);
    try {
      final hasil = await _bookService.getBooks(sort: 'newest', limit: 10);
      bukuTerbaru.value = hasil;
    } catch (_) {} finally {
      isLoadingTerbaru(false);
    }
  }

  Future<void> fetchBukuPopuler() async {
    isLoadingPopuler(true);
    try {
      final hasil = await _bookService.getBooks(sort: 'popular', limit: 10);
      bukuPopuler.value = hasil;
    } catch (_) {} finally {
      isLoadingPopuler(false);
    }
  }

  void setNavIndex(int index) {
    currentNavIndex(index);
    _refreshOnNav(index);
  }

  void _refreshOnNav(int index) {
    switch (index) {
      case 0:
        fetchBukuTerbaru();
        fetchBukuPopuler();
        fetchRekomendasi();
        break;
      case 4:
        if (Get.isRegistered<ProfileController>()) {
          ProfileController.to.fetchAll();
        }
        break;
    }
  }
  Future<void> fetchRekomendasi() async {
    isLoadingRekomendasi(true);
    try {
      final hasil = await _prefService.getRecommendations();
      rekomendasi.value = hasil.map((e) => BookModel.fromJson(e)).toList();
    } catch (_) {} finally {
      isLoadingRekomendasi(false);
    }
  }

  void setBannerIndex(int index) => currentBannerIndex(index);

  Future<void> searchBooks(String query) async {
    searchQuery(query);
    if (query.trim().isEmpty && selectedKategori.value == null && selectedGenre.value == null) {
      searchResults.clear();
      return;
    }
    isLoadingSearch(true);
    try {
      final hasil = await _bookService.getBooks(
        search: query.trim().isEmpty ? null : query.trim(),
        kategori: selectedKategori.value?['slug'],
        genre: selectedGenre.value?['slug'],
        limit: 30,
      );
      searchResults.assignAll(hasil);
    } catch (e) {
      searchResults.clear();
    } finally {
      isLoadingSearch(false);
    }
  }

  void applyFilter({Map<String, dynamic>? kategori, Map<String, dynamic>? genre}) {
    selectedKategori(kategori);
    selectedGenre(genre);
    searchBooks(searchQuery.value);
  }

  void clearFilter() {
    selectedKategori(null);
    selectedGenre(null);
    searchBooks(searchQuery.value);
  }
}
