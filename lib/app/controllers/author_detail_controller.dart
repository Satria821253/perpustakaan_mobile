import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/author_model.dart';
import '../services/author_service.dart';
import '../core/app_config.dart';

class AuthorDetailController extends GetxController {
  final int authorId;
  final AuthorService _service = AuthorService();

  AuthorDetailController({required this.authorId});

  final Rx<Author?> author = Rx<Author?>(null);
  final RxList<Map<String, dynamic>> books = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAuthorDetail();
  }

  Future<void> loadAuthorDetail() async {
    try {
      isLoading.value = true;
      final data = await _service.getAuthorDetail(authorId);
      author.value = data['author'];
      
      // Fix cover image URLs
      final booksList = List<Map<String, dynamic>>.from(data['books'] ?? []);
      for (var book in booksList) {
        if (book['cover_image'] != null && book['cover_image'].toString().isNotEmpty) {
          final raw = book['cover_image'].toString();
          book['cover_image'] = raw
              .replaceFirst(RegExp(r'https?://localhost:\d+'), AppConfig.baseUrl)
              .replaceFirst(RegExp(r'https?://127\.0\.0\.1:\d+'), AppConfig.baseUrl)
              .replaceFirst(RegExp(r'^/uploads'), '${AppConfig.baseUrl}/uploads');
        }
      }
      books.value = booksList;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load author details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
