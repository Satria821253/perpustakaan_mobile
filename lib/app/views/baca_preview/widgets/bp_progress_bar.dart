import 'package:flutter/material.dart';

class BpProgressBar extends StatelessWidget {
  final double progress;
  final ValueChanged<double> onChanged;

  const BpProgressBar({
    super.key,
    required this.progress,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        activeTrackColor: const Color(0xFF4361EE),
        inactiveTrackColor: const Color(0xFFDDE1F0),
        thumbColor: const Color(0xFF4361EE),
        overlayColor: const Color(0x264361EE),
      ),
      child: Slider(value: progress, onChanged: onChanged, min: 0.0, max: 1.0),
    );
  }
}

class BpPageInfoRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isLastPage;

  const BpPageInfoRow({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          // Kiri
          SizedBox(
            width: 48,
            child: Text(
              'Hal. $currentPage',
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF888888),
                  fontFamily: 'Poppins'),
              textAlign: TextAlign.center,
            ),
          ),

          // Badge tengah
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isLastPage
                      ? const Color(0xFFFFEEEE)
                      : const Color(0xFFEEF0FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isLastPage
                      ? 'Preview habis · $currentPage / $totalPages'
                      : 'Preview · $currentPage / $totalPages halaman',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: isLastPage
                        ? const Color(0xFFE63946)
                        : const Color(0xFF4361EE),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Kanan
          SizedBox(
            width: 48,
            child: Text(
              '$totalPages',
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF888888),
                  fontFamily: 'Poppins'),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
