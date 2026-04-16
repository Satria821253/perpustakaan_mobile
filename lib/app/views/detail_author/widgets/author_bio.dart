import 'package:ei_books/app/controllers/author_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/author_detail_controller.dart';

class AuthorBio extends StatelessWidget {
  final AuthorDetailController ctrl;
  const AuthorBio({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final author = ctrl.author.value!;
    if (author.bio == null || author.bio!.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Biography',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            author.bio!,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
