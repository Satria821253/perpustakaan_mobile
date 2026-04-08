import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';

class ProfileStatistik extends StatelessWidget {
  final ProfileController ctrl;
  const ProfileStatistik({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Obx(() {
        final denda = ctrl.totalDenda.value;
        final dipinjam = ctrl.sedangDipinjam.value;
        final limit = ctrl.limitPinjam.value;
        final totalPinjam = ctrl.totalDipinjam.value;
        final ulasan = ctrl.totalReview.value;
        return Row(
          children: [
            _StatItem(
              icon: Icons.library_books_outlined,
              label: 'Total Pinjam',
              value: '$totalPinjam',
            ),
            _divider(),
            _StatItem(
              icon: Icons.book_outlined,
              label: 'Dipinjam',
              value: '$dipinjam/$limit',
            ),
            _divider(),
            _StatItem(
              icon: Icons.star_outline_rounded,
              label: 'Ulasan',
              value: '$ulasan',
            ),
            _divider(),
            _StatItem(
              icon: Icons.receipt_long_outlined,
              label: 'Denda',
              value: 'Rp $denda',
              valueColor: denda > 0 ? const Color(0xFFD32F2F) : Colors.black87,
            ),
          ],
        );
      }),
    );
  }

  Widget _divider() => Container(width: 1, height: 36, color: Colors.grey[200]);
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color? valueColor;

  const _StatItem({
    required this.icon, required this.label, required this.value, this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF1565C0), size: 22),
          ),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                  color: valueColor ?? Colors.black87, fontFamily: 'Poppins')),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(fontSize: 10, color: Colors.grey[500], fontFamily: 'Poppins'),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
