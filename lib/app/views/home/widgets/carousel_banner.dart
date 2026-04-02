import 'dart:async';
import 'package:flutter/material.dart';

class CarouselBanner extends StatefulWidget {
  const CarouselBanner({super.key});

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  final PageController _controller = PageController();
  int _current = 0;
  Timer? _timer;

  final _slides = [
    {
      'c1': const Color(0xFF0D47A1),
      'c2': const Color(0xFF1976D2),
      'title': 'Buku Terpopuler',
      'sub': 'Temukan\nkoleksi\nterbaik',
      'icon': Icons.auto_stories,
    },
    {
      'c1': const Color(0xFF6A1B9A),
      'c2': const Color(0xFF9C27B0),
      'title': 'Baca Gratis',
      'sub': 'Ribuan\nbuku\nuntukmu',
      'icon': Icons.menu_book,
    },
    {
      'c1': const Color(0xFFB71C1C),
      'c2': const Color(0xFFE53935),
      'title': 'Koleksi Baru',
      'sub': 'Update\nsetiap\nminggu',
      'icon': Icons.library_add,
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_controller.hasClients) {
        final next = (_current + 1) % _slides.length;
        _controller.animateToPage(next,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) {
              final s = _slides[i];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [s['c1'] as Color, s['c2'] as Color],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(s['title'] as String,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontFamily: 'Poppins')),
                    const SizedBox(height: 4),
                    Text(s['sub'] as String,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Poppins')),
                    const Spacer(),
                    Icon(s['icon'] as IconData,
                        color: Colors.white24, size: 48),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _current == i ? 16 : 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: _current == i ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
