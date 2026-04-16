import 'package:flutter/material.dart';
import '../../../controllers/author_detail_controller.dart';

class AuthorStats extends StatelessWidget {
  final AuthorDetailController ctrl;
  const AuthorStats({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final author = ctrl.author.value!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.menu_book_rounded,
            value: '${author.totalBooks}',
            label: 'Books',
            color: const Color(0xFF1565C0),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildStatItem(
            icon: Icons.people_outline,
            value: '${author.totalBorrowed}',
            label: 'Borrowed',
            color: const Color(0xFF00897B),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildStatItem(
            icon: Icons.star_rounded,
            value: author.avgRating.toStringAsFixed(1),
            label: 'Rating',
            color: const Color(0xFFFFB300),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
