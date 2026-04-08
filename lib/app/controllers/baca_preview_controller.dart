import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../models/book_preview_model.dart';
import '../services/book_detail_service.dart';

class BacaPreviewController extends GetxController
    implements TickerProvider {
  final int bookId;
  final String bookTitle;
  BacaPreviewController({required this.bookId, required this.bookTitle});

  final _service = BookDetailService();

  final isLoading = true.obs;
  final isTranslating = false.obs;
  final error = Rxn<String>();

  final preview = Rxn<BookPreview>();
  final currentPage = 0.obs;

  // Text reader state
  final fontSize = 16.0.obs;
  final showSettings = false.obs;
  final showLanguage = false.obs;
  final showEndOverlay = false.obs;
  final lang = 'id'.obs; // 'id' atau 'en'

  late final PageController pageController;
  late final AnimationController overlayAnimController;
  late final Animation<double> overlayFade;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    overlayAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    overlayFade = CurvedAnimation(
      parent: overlayAnimController,
      curve: Curves.easeInOut,
    );
    _service.onInit();
    fetchPreview();
  }

  @override
  void onClose() {
    pageController.dispose();
    overlayAnimController.dispose();
    super.onClose();
  }

  Future<void> fetchPreview({String? language}) async {
    final useLang = language ?? lang.value;
    final isLangSwitch = language != null;

    if (isLangSwitch) {
      isTranslating(true);
    } else {
      isLoading(true);
    }
    error(null);
    currentPage(0);
    showEndOverlay(false);
    overlayAnimController.reset();
    if (pageController.hasClients) pageController.jumpToPage(0);
    try {
      print('[PREVIEW] fetching bookId=$bookId type=text lang=$useLang');
      final data = await _service.getPreview(bookId, 'text', lang: useLang);
      print('[PREVIEW] response keys: ${data.keys}');
      print('[PREVIEW] preview_type: ${data['preview_type']}');
      final pd = data['preview_data'];
      if (pd != null) {
        print('[PREVIEW] preview_data keys: ${(pd as Map).keys}');
        print('[PREVIEW] pages count: ${(pd['pages'] as List?)?.length ?? 0}');
      }
      preview.value = BookPreview.fromJson(data);
      print('[PREVIEW] isTextPreview: $isTextPreview, totalPages: $totalPages');
      for (var i = 0; i < previewPages.length; i++) {
        print('[PREVIEW] page ${i+1} lang check: ${previewPages[i].paragraphs.first}');
      }
    } catch (e, st) {
      print('[PREVIEW] ERROR: $e');
      print('[PREVIEW] STACKTRACE: $st');
      error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading(false);
      isTranslating(false);
    }
  }

  void switchLang(String newLang) {
    if (lang.value == newLang) return;
    lang(newLang);
    fetchPreview(language: newLang);
  }

static const int maxPreviewPages = 10;

  bool get isTextPreview =>
      preview.value?.previewType == 'text' &&
      (preview.value?.previewData.pages.isNotEmpty ?? false);

  List<PreviewPage> get pages => preview.value?.previewData.pages ?? [];

  int get totalPages =>
      isTextPreview
          ? pages.length.clamp(0, maxPreviewPages)
          : (preview.value?.previewData.numPages ?? 0);

  List<PreviewPage> get previewPages =>
      pages.take(maxPreviewPages).toList();

  void setPage(int page) => currentPage(page);

  void goToPage(int index) {
    if (index < 0 || index >= totalPages) return;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    currentPage(index);
    if (index >= totalPages - 1) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!isClosed) {
          showEndOverlay(true);
          overlayAnimController.forward();
        }
      });
    } else {
      showEndOverlay(false);
      overlayAnimController.reset();
    }
  }

  void toggleSettings() => showSettings.toggle();
  void toggleLanguage() => showLanguage.toggle();

  void closeEndOverlay() {
    showEndOverlay(false);
    overlayAnimController.reset();
  }

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
