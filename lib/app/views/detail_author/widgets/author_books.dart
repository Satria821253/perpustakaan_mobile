import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/author_detail_controller.dart';

class AuthorBooks extends StatelessWidget {
  final AuthorDetailController ctrl;
  const AuthorBooks({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final books = ctrl.books;
      if (books.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text(
              'No books available',
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        );
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(Icons.library_books, color: Color(0xFF1565C0), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Books by this Author',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: books.length,
              itemBuilder: (context, index) => _buildBookCard(books[index]),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    final coverUrl = book['cover_image'] ?? '';
    final rating = double.tryParse('${book['rating']}') ?? 0.0;
    final totalRating = book['total_rating'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed('/detail-buku', arguments: book['id']);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: coverUrl.isNotEmpty
                    ? Image.network(
                        coverUrl,
                        width: 60,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book['judul'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book['penerbit'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB300),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$rating ($totalRating)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: book['stok'] > 0
                                ? const Color(0xFFE8F5E9)
                                : const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            book['stok'] > 0 ? 'Available' : 'Out of Stock',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              color: book['stok'] > 0
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFD32F2F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 90,
      color: Colors.grey[300],
      child: const Icon(Icons.book, color: Colors.grey),
    );
  }
}
