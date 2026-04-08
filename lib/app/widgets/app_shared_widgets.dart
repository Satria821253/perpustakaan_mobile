import 'package:flutter/material.dart';

BoxDecoration appCardDecor({double radius = 16}) => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3))
      ],
    );

String appFmt(int n) => n == 0
    ? '0'
    : n.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

Color appParseColor(String hex,
    {Color fallback = const Color(0xFF1565C0)}) {
  try {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  } catch (_) {
    return fallback;
  }
}

Widget appSectionTitle(String t) => Text(t,
    style: const TextStyle(
        fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87));

class AppInfoRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  final bool isLast;
  const AppInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                Text(value,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: valueColor ?? Colors.black87)),
              ],
            ),
          ),
          if (!isLast) Divider(height: 1, color: Colors.grey[100]),
        ],
      );
}

class AppChip extends StatelessWidget {
  final String label;
  final Color color;
  const AppChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      );
}
