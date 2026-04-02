import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';

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

  final _bookService = BookService();

  @override
  void onInit() {
    super.onInit();
    fetchBukuTerbaru();
    fetchBukuPopuler();
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
    } catch (e) {
      print('[FILTER] ERROR: $e');
    } finally {
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
    } catch (e) {
      print('[HOME] LOKASI ERROR: $e');
    }
  }

  Future<void> fetchBukuTerbaru() async {
    print('[BUKU TERBARU] Mulai fetch...');
    isLoadingTerbaru(true);
    try {
      final hasil = await _bookService.getBooks(sort: 'newest', limit: 10);
      bukuTerbaru.value = hasil;
      print('[BUKU TERBARU] Berhasil, jumlah: ${hasil.length} buku');
    } catch (e) {
      print('[BUKU TERBARU] Gagal: $e');
    } finally {
      isLoadingTerbaru(false);
      print('[BUKU TERBARU] Selesai.');
    }
  }

  Future<void> fetchBukuPopuler() async {
    print('[BUKU POPULER] Mulai fetch...');
    isLoadingPopuler(true);
    try {
      final hasil = await _bookService.getBooks(sort: 'popular', limit: 10);
      bukuPopuler.value = hasil;
      print('[BUKU POPULER] Berhasil, jumlah: ${hasil.length} buku');
    } catch (e) {
      print('[BUKU POPULER] Gagal: $e');
    } finally {
      isLoadingPopuler(false);
      print('[BUKU POPULER] Selesai.');
    }
  }

  void setNavIndex(int index) => currentNavIndex(index);
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
