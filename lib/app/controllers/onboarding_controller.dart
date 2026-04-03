import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../services/preference_service.dart';

class OnboardingController extends GetxController {
  final _service = PreferenceService();

  final currentStep = 0.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  final categories = <Map<String, dynamic>>[].obs;
  final genres = <Map<String, dynamic>>[].obs;
  final authors = <String>[].obs;
  final filteredAuthors = <String>[].obs;

  final selectedCategories = <String>[].obs;
  final selectedGenres = <String>[].obs;
  final selectedAuthors = <String>[].obs;

  final authorSearch = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    fetchOptions();
  }

  Future<void> fetchOptions() async {
    isLoading(true);
    try {
      final data = await _service.getOptions();
      categories.value = List<Map<String, dynamic>>.from(data['categories'] ?? []);
      genres.value = List<Map<String, dynamic>>.from(data['genres'] ?? []);
      authors.value = List<String>.from(data['pengarang'] ?? []);
      filteredAuthors.value = authors;
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal memuat pilihan. Coba lagi.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void toggleCategory(String slug) {
    if (selectedCategories.contains(slug)) {
      selectedCategories.remove(slug);
    } else {
      selectedCategories.add(slug);
    }
  }

  void toggleGenre(String slug) {
    if (selectedGenres.contains(slug)) {
      selectedGenres.remove(slug);
    } else {
      selectedGenres.add(slug);
    }
  }

  void toggleAuthor(String name) {
    if (selectedAuthors.contains(name)) {
      selectedAuthors.remove(name);
    } else if (selectedAuthors.length < 3) {
      selectedAuthors.add(name);
    }
  }

  void searchAuthor(String query) {
    authorSearch(query);
    if (query.trim().isEmpty) {
      filteredAuthors.value = authors;
    } else {
      filteredAuthors.value = authors
          .where((a) => a.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void nextStep() {
    if (currentStep.value < 2) currentStep(currentStep.value + 1);
  }

  void prevStep() {
    if (currentStep.value > 0) currentStep(currentStep.value - 1);
  }

  Future<void> save() async {
    isSaving(true);
    try {
      await _service.savePreferences(
        kategori: selectedCategories,
        genre: selectedGenres,
        pengarang: selectedAuthors,
      );
      Get.offAllNamed(Routes.home);
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving(false);
    }
  }

  void skip() {
    if (currentStep.value < 2) {
      currentStep(currentStep.value + 1);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }
}
