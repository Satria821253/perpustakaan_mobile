import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/favorite_controller.dart';
import '../../../core/app_config.dart';

const _baseUrl = AppConfig.baseUrl;

String formatRupiah(int nominal) {
  if (nominal == 0) return '0';
  return nominal.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  );
}

class CoverWidget extends StatelessWidget {
  final String? cover;
  final double width;
  final double height;
  const CoverWidget({super.key, required this.cover, this.width = 68, this.height = 90});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: width,
        height: height,
        color: const Color(0xFF1A1A2E),
        child: cover != null
            ? Image.network(
                cover!.startsWith('http') ? cover! : '$_baseUrl$cover',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const Center(child: Icon(Icons.menu_book, color: Colors.white24, size: 28)),
              )
            : const Center(child: Icon(Icons.menu_book, color: Colors.white24, size: 28)),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87, fontFamily: 'Poppins')),        
      ],
    );
  }
}

class OutlineBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const OutlineBtn({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 15),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1565C0),
        side: const BorderSide(color: Color(0xFF1565C0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 10),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
      ),
    );
  }
}

class FilledBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const FilledBtn({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = const Color(0xFF1565C0),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 15),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 10),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String label;
  const EmptyState({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books_outlined, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(label,
                style: TextStyle(fontSize: 14, color: Colors.grey[400], fontFamily: 'Poppins'),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class BookmarkBtn extends StatelessWidget {
  final int bookId;
  const BookmarkBtn({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FavoriteController>()) {
      return Icon(Icons.bookmark_rounded, color: Colors.grey[300], size: 20);
    }
    final fav = Get.find<FavoriteController>();
    return Obx(() {
      final isFav = fav.favoriteIds.contains(bookId);
      return GestureDetector(
        onTap: () => fav.toggleFavorite(bookId),
        child: Icon(Icons.bookmark_rounded,
            color: isFav ? const Color(0xFF1565C0) : Colors.grey[300], size: 20),
      );
    });
  }
}
