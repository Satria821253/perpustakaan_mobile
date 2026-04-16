import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/book_model.dart';
import '../../../routes/app_pages.dart';

class LocalComicItem extends StatelessWidget {
  final BookModel comic;

  const LocalComicItem({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.detail, arguments: comic.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 48,
                height: 62,
                color: comic.coverImage != null
                    ? null
                    : const Color(0xFFF4A67A),
                child: comic.coverImage != null
                    ? Image.network(
                        comic.coverImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comic.judul,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${comic.author} · ${comic.genre}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF888888),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: Color(0xFFFFB800),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${comic.rating}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: Text(
                '${comic.totalDipinjam} Terpinjam',
                style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
