import 'package:flutter/material.dart';

class MetodeBase extends StatelessWidget {
  final bool isActive;
  final VoidCallback? onTap;
  final Widget leading;
  final String title;
  final String subtitle;
  final Color? subtitleColor;
  final Widget? badge;
  final Widget trailing;

  const MetodeBase({
    super.key,
    required this.isActive,
    required this.onTap,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.subtitleColor,
    this.badge,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? const Color(0xFF1565C0) : Colors.transparent,
            width: isActive ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? const Color(0xFF1565C0).withOpacity(0.1)
                  : Colors.black.withOpacity(0.04),
              blurRadius: isActive ? 10 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: subtitleColor ?? Colors.grey[500])),
                  if (badge != null) ...[
                    const SizedBox(height: 5),
                    badge!,
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            trailing,
          ],
        ),
      ),
    );
  }
}

class MetodeIcon extends StatelessWidget {
  final Color color;
  final IconData icon;
  const MetodeIcon({super.key, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
    width: 44, height: 44,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
    child: Icon(icon, color: Colors.white, size: 22),
  );
}

class RadioDot extends StatelessWidget {
  final bool active;
  final bool disabled;
  const RadioDot({super.key, required this.active, this.disabled = false});

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    width: 22, height: 22,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: active
            ? const Color(0xFF1565C0)
            : disabled ? Colors.grey[300]! : Colors.grey[400]!,
        width: 2,
      ),
      color: active ? const Color(0xFF1565C0) : Colors.transparent,
    ),
    child: active
        ? const Icon(Icons.check_rounded, color: Colors.white, size: 13)
        : null,
  );
}

class PaymentBadge extends StatelessWidget {
  final String label;
  final Color color, bgColor;
  const PaymentBadge({super.key, required this.label, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
  );
}

class EwalletChip extends StatelessWidget {
  final String label;
  final Color color;
  const EwalletChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(right: 4),
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
    child: Text(label,
        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
  );
}

BoxDecoration cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
);

String formatRupiah(int n) => n == 0 ? '0' : n.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

String formatKoin(int n) => n >= 1000
    ? '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}rb'
    : n.toString();
