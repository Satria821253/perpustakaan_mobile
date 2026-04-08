import 'package:flutter/material.dart';

class BpBottomNavBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const BpBottomNavBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7F3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Prev — fixed width
          SizedBox(
            width: 48,
            height: 48,
            child: _NavButton(
                icon: Icons.chevron_left_rounded, onPressed: onPrev),
          ),

          // Center — expanded agar benar-benar di tengah
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Halaman $currentPage dari $totalPages',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Preview gratis',
                  style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF888888),
                      fontFamily: 'Poppins'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Next — fixed width sama dengan prev
          SizedBox(
            width: 48,
            height: 48,
            child: _NavButton(
                icon: Icons.chevron_right_rounded,
                onPressed: onNext,
                isPrimary: true),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const _NavButton({
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed == null
            ? const Color(0xFFEEEEEE)
            : isPrimary
                ? const Color(0xFF4361EE)
                : Colors.white,
        foregroundColor: onPressed == null
            ? const Color(0xFFBBBBBB)
            : isPrimary
                ? Colors.white
                : const Color(0xFF1A1A2E),
        elevation: 0,
        padding: EdgeInsets.zero,
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: onPressed != null && !isPrimary
              ? const BorderSide(color: Color(0xFFDDDDDD))
              : BorderSide.none,
        ),
      ),
      child: Icon(icon, size: 24),
    );
  }
}
