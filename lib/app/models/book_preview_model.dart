import 'package:ei_books/app/core/app_config.dart';

class BookPreview {
  final int bookId;
  final String bookTitle;
  final String previewType;
  final PreviewData previewData;

  BookPreview({
    required this.bookId,
    required this.bookTitle,
    required this.previewType,
    required this.previewData,
  });

  factory BookPreview.fromJson(Map<String, dynamic> j) {
    return BookPreview(
      bookId: j['book_id'] ?? 0,
      bookTitle: j['book_title'] ?? '',
      previewType: j['preview_type'] ?? 'pdf',
      previewData: PreviewData.fromJson(
        j['preview_data'] as Map<String, dynamic>? ?? {},
        j['preview_type'] ?? 'pdf',
      ),
    );
  }
}

class PreviewData {
  final String? pdfUrl;
  final int? numPages;
  final String? filePath;
  final String? textContent;
  final String? source;
  final String? imageUrl;
  final List<PreviewPage> pages;

  PreviewData({
    this.pdfUrl,
    this.numPages,
    this.filePath,
    this.textContent,
    this.source,
    this.imageUrl,
    this.pages = const [],
  });

  factory PreviewData.fromJson(Map<String, dynamic> j, String type) {
    String? normalizeUrl(String? url) {
      if (url == null || url.isEmpty) return null;
      return url
          .replaceFirst(RegExp(r'https?://localhost:\d+'), AppConfig.baseUrl)
          .replaceFirst(RegExp(r'https?://127\.0\.0\.1:\d+'), AppConfig.baseUrl);
    }

    if (type == 'pdf') {
      return PreviewData(
        pdfUrl: normalizeUrl(j['pdf_url'] as String?),
        numPages: j['num_pages'] as int?,
        filePath: j['file_path'] as String?,
      );
    } else if (type == 'text') {
      final rawPages = j['pages'] as List?;
      List<PreviewPage> pages = [];
      if (rawPages != null) {
        pages = rawPages
            .map((e) => PreviewPage.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        // fallback: split textContent by double newline
        final text = j['text_content'] as String? ?? '';
        final chunks = text
            .split(RegExp(r'\n{2,}|\n'))
            .where((s) => s.trim().isNotEmpty)
            .toList();
        // group ~3 paragraphs per page
        for (var i = 0; i < chunks.length; i += 3) {
          final end = (i + 3).clamp(0, chunks.length);
          pages.add(PreviewPage(
            page: pages.length + 1,
            chapterTitle: j['chapter_title'] as String? ?? '',
            paragraphs: chunks.sublist(i, end),
          ));
        }
      }
      return PreviewData(
        textContent: j['text_content'] as String?,
        source: j['source'] as String?,
        numPages: j['num_pages'] as int? ?? pages.length,
        pages: pages,
      );
    } else if (type == 'image') {
      return PreviewData(
        imageUrl: normalizeUrl(j['image_url'] as String?),
        filePath: j['file_path'] as String?,
      );
    }
    return PreviewData();
  }
}

class PreviewPage {
  final int page;
  final String chapterTitle;
  final List<String> paragraphs;

  const PreviewPage({
    required this.page,
    required this.chapterTitle,
    required this.paragraphs,
  });

  factory PreviewPage.fromJson(Map<String, dynamic> j) {
    final rawParagraphs = (j['paragraphs'] as List?)?.cast<String>() ?? [];
    // Filter teks 'Halaman X' / 'Page X' yang disisipi backend
    final cleaned = rawParagraphs
        .map((p) => p.replaceAll(RegExp(r'\s*Halaman\s+\d+\s*'), '').replaceAll(RegExp(r'\s*Page\s+\d+\s*'), '').trim())
        .where((p) => p.isNotEmpty)
        .toList();
    return PreviewPage(
      page: j['page'] as int? ?? 0,
      chapterTitle: j['chapter_title'] as String? ?? '',
      paragraphs: cleaned,
    );
  }
}
