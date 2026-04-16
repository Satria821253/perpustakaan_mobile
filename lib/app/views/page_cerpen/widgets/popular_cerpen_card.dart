import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/book_model.dart';
import '../../../routes/app_pages.dart';

class PopularCerpenCard extends StatelessWidget {
  final BookModel cerpen;

  const PopularCerpenCard({super.key, required this.cerpen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.detail, arguments: cerpen.id),
      child: SizedBox(
        width: 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 90,
                height: 120,
                color: cerpen.coverImage != null
                    ? null
                    : const Color(0xFFE65100),
                child: cerpen.coverImage != null
                    ? Image.network(
                        cerpen.coverImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              cerpen.judul,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            cerpen.judul,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              cerpen.judul,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Text(
              cerpen.pengarang,
              style: const TextStyle(fontSize: 10, color: Color(0xFF888888)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 11,
                  color: Color(0xFFFFB800),
                ),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    '${cerpen.rating}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF888888),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
