import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/baca_preview_controller.dart';
import 'widgets/bp_bottom_nav_bar.dart';
import 'widgets/bp_font_settings_panel.dart';
import 'widgets/bp_loading_state.dart';
import 'widgets/bp_language_panel.dart';
import 'widgets/bp_locked_overlay.dart';
import 'widgets/bp_more_options_sheet.dart';
import 'widgets/bp_progress_bar.dart';
import 'widgets/bp_text_reader.dart';
import 'widgets/bp_top_bar.dart';

class BacaPreviewScreen extends StatelessWidget {
  final int bookId;
  final String bookTitle;
  const BacaPreviewScreen(
      {super.key, required this.bookId, required this.bookTitle});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final ctrl = Get.put(
      BacaPreviewController(bookId: bookId, bookTitle: bookTitle),
      tag: 'preview_$bookId',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: Obx(() {
          if (ctrl.isLoading.value) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF4361EE)),
                  SizedBox(height: 16),
                  Text('Memuat preview...',
                      style: TextStyle(
                          color: Color(0xFF888888), fontFamily: 'Poppins')),
                ],
              ),
            );
          }

          if (ctrl.error.value != null) {
            // Kalau error saat translate (bukan load awal), tampil snackbar + reset ke ID
            if (!ctrl.isLoading.value && ctrl.preview.value != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.snackbar(
                  'Terjemahan Gagal',
                  ctrl.error.value!,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFFFFEEEE),
                  colorText: const Color(0xFFE63946),
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  mainButton: TextButton(
                    onPressed: () {
                      ctrl.error(null);
                      ctrl.switchLang(ctrl.lang.value);
                    },
                    child: const Text('Coba Lagi',
                        style: TextStyle(
                            color: Color(0xFF4361EE),
                            fontWeight: FontWeight.bold)),
                  ),
                );
                ctrl.error(null);
              });
              return _TextReaderLayout(ctrl: ctrl);
            }
            return BpErrorState(
              message: ctrl.error.value!,
              onRetry: ctrl.fetchPreview,
            );
          }

          if (ctrl.isTextPreview) {
            return _TextReaderLayout(ctrl: ctrl);
          }

          return const Center(
            child: Text('Preview tidak tersedia',
                style: TextStyle(
                    color: Color(0xFF888888), fontFamily: 'Poppins')),
          );
        }),
      ),
    );
  }
}

// ── Text Reader Layout ──────────────────────────────────────────────────────

class _TextReaderLayout extends StatelessWidget {
  final BacaPreviewController ctrl;
  const _TextReaderLayout({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = ctrl.currentPage.value;
      final total = ctrl.totalPages;
      final progress = total > 0 ? (current + 1) / total : 0.0;
      final isLast = current == total - 1;

      return Stack(
        children: [
          Column(
            children: [
              BpTopBar(
                title: ctrl.bookTitle,
                subtitle: 'Baca Preview · SatMuwanii',
                onBack: () => Get.back(),
                onFontSize: ctrl.toggleSettings,
                onLanguage: ctrl.toggleLanguage,
                onMore: () => showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (_) => const BpMoreOptionsSheet(),
                ),
              ),
              BpProgressBar(
                progress: progress,
                onChanged: (val) {
                  final newPage = (val * (total - 1)).round();
                  ctrl.goToPage(newPage);
                },
              ),
              BpPageInfoRow(
                currentPage: current + 1,
                totalPages: total,
                isLastPage: isLast,
              ),
              Expanded(
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: ctrl.pageController,
                      onPageChanged: ctrl.onPageChanged,
                      itemCount: total,
                      itemBuilder: (_, index) => BpTextPage(
                        page: ctrl.previewPages[index],
                        fontSize: ctrl.fontSize.value,
                      ),
                    ),
                    if (ctrl.showSettings.value)
                      BpFontSettingsPanel(
                        fontSize: ctrl.fontSize.value,
                        onFontSizeChanged: (v) => ctrl.fontSize(v),
                        onClose: ctrl.toggleSettings,
                      ),
                    if (ctrl.showLanguage.value)
                      BpLanguagePanel(
                        lang: ctrl.lang.value,
                        onLangChanged: ctrl.switchLang,
                        onClose: ctrl.toggleLanguage,
                      ),
                  ],
                ),
              ),
              if (!ctrl.showEndOverlay.value)
                BpBottomNavBar(
                  currentPage: current + 1,
                  totalPages: total,
                  onPrev: current > 0 ? () => ctrl.goToPage(current - 1) : null,
                  onNext: current < total - 1
                      ? () => ctrl.goToPage(current + 1)
                      : null,
                ),
            ],
          ),

          // Full-screen overlay with blur + dim
          if (ctrl.showEndOverlay.value)
            Positioned.fill(
              child: FadeTransition(
                opacity: ctrl.overlayFade,
                child: BpLockedOverlay(
                  bookId: ctrl.bookId,
                  totalPages: total,
                  onBack: ctrl.closeEndOverlay,
                ),
              ),
            ),

          // Translating overlay
          if (ctrl.isTranslating.value)
            Positioned.fill(
              child: _TranslatingOverlay(lang: ctrl.lang.value),
            ),
        ],
      );
    });
  }
}

class _TranslatingOverlay extends StatelessWidget {
  final String lang;
  const _TranslatingOverlay({required this.lang});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Container(
        color: Colors.black.withValues(alpha: 0.35),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xFF4361EE)),
                const SizedBox(height: 14),
                Text(
                  lang == 'en'
                      ? 'Menerjemahkan ke English...'
                      : 'Memuat bahasa Indonesia...',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1A1A2E),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mohon tunggu sebentar',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF888888),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}