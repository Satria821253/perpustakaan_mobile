import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../widgets/app_shared_widgets.dart';

class RwCover extends StatelessWidget {
  final String? url;
  const RwCover({super.key, this.url});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: url != null
            ? Image.network(url!,
                width: 60,
                height: 82,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => _placeholder())
            : _placeholder(),
      );

  Widget _placeholder() => Container(
        width: 60,
        height: 82,
        color: const Color(0xFF1A1A2E),
        child: const Center(
            child: Icon(Icons.menu_book, color: Colors.white24, size: 24)),
      );
}

class RwCoverWithBadge extends StatelessWidget {
  final String? url;
  final bool isPopuler;
  const RwCoverWithBadge({super.key, this.url, this.isPopuler = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: url != null
              ? Image.network(url!,
                  width: 90, height: 124, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder())
              : _placeholder(),
        ),
        if (isPopuler)
          Positioned(
            top: 6, left: 6,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: const Color(0xFFFF6F00),
                  borderRadius: BorderRadius.circular(4)),
              child: const Icon(Icons.local_fire_department,
                  color: Colors.white, size: 12),
            ),
          ),
      ],
    );
  }

  Widget _placeholder() => Container(
        width: 90, height: 124,
        color: const Color(0xFF1A1A2E),
        child: const Center(
            child: Icon(Icons.menu_book, color: Colors.white24, size: 34)),
      );
}

class RwGenreChips extends StatelessWidget {
  final String kategori;
  final String genre;
  const RwGenreChips({super.key, required this.kategori, required this.genre});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    final categories = homeCtrl?.categories ?? [];
    final genres = homeCtrl?.genres ?? [];

    final catData = categories.firstWhereOrNull((c) => c['name'] == kategori);
    final catColor = catData != null
        ? appParseColor(catData['color'] ?? '#1565C0')
        : const Color(0xFF1565C0);

    final genreList = genre.split(',').map((g) => g.trim()).where((g) => g.isNotEmpty).toList();

    if (kategori.isEmpty && genreList.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        if (kategori.isNotEmpty)
          AppChip(label: kategori, color: catColor),
        ...genreList.map((g) {
          final gData = genres.firstWhereOrNull(
              (e) => (e['name'] as String).toLowerCase() == g.toLowerCase());
          final color = gData != null
              ? appParseColor(gData['color'] ?? '#1565C0')
              : const Color(0xFF1565C0);
          return AppChip(label: g, color: color);
        }),
      ],
    );
  }
}

class RwStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const RwStatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700, color: color)),
      );
}

class RwInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  const RwInfoRow(
      {super.key, required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 12, color: color ?? Colors.grey[500]),
          const SizedBox(width: 5),
          Expanded(
            child: Text(text,
                style:
                    TextStyle(fontSize: 12, color: color ?? Colors.grey[500])),
          ),
        ],
      );
}

class RwEmpty extends StatelessWidget {
  final IconData icon;
  final String label;
  const RwEmpty({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(label,
                style: TextStyle(fontSize: 14, color: Colors.grey[400])),
          ],
        ),
      );
}

BoxDecoration rwCardDecor() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2))
      ],
    );

String rwFmt(int n) => n == 0
    ? '0'
    : n
        .toString()
        .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
