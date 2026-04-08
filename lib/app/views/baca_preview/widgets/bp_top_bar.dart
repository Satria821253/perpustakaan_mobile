import 'package:flutter/material.dart';

class BpTopBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final VoidCallback onFontSize;
  final VoidCallback onLanguage;
  final VoidCallback onMore;

  const BpTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.onFontSize,
    required this.onLanguage,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    const double sideWidth = 120;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFFF9F7F3),
      child: Row(
        children: [
          // Kiri — back
          SizedBox(
            width: sideWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: onBack,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1A1A2E),
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),

          // Tengah — title
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                    fontFamily: 'Poppins',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF888888),
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Kanan — font + language + more
          SizedBox(
            width: sideWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _TopBarBtn(
                  label: 'Tt',
                  onTap: onFontSize,
                ),
                _TopBarBtn(
                  icon: Icons.translate_rounded,
                  onTap: onLanguage,
                ),
                _TopBarBtn(
                  icon: Icons.more_horiz_rounded,
                  onTap: onMore,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBarBtn extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onTap;

  const _TopBarBtn({required this.onTap, this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 4),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: label != null
            ? Text(
                label!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4361EE),
                  fontFamily: 'Georgia',
                ),
              )
            : Icon(icon, size: 18, color: const Color(0xFF4361EE)),
      ),
    );
  }
}
