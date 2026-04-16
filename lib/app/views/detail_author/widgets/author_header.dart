import 'package:flutter/material.dart';
import '../../../controllers/author_detail_controller.dart';

class AuthorHeader extends StatelessWidget {
  final AuthorDetailController ctrl;
  const AuthorHeader({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final author = ctrl.author.value!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        children: [
          Text(
            author.nama,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.flag_outlined, size: 16, color: Colors.black54),
              const SizedBox(width: 4),
              Text(
                author.nationality,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
              if (author.birthDate != null) ...[
                const SizedBox(width: 12),
                const Icon(Icons.cake_outlined, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Text(
                  _formatDate(author.birthDate!),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final dt = DateTime.parse(date);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return date;
    }
  }
}
