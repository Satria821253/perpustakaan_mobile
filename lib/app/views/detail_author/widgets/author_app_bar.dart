import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/author_detail_controller.dart';
import '../../../models/author_model.dart';

class AuthorAppBar extends StatelessWidget {
  final AuthorDetailController ctrl;
  const AuthorAppBar({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final author = ctrl.author.value!;
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: const Color(0xFF1565C0),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildGradient(),
            _buildPhotoCircle(author),
          ],
        ),
      ),
    );
  }

  Widget _buildGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
        ),
      ),
    );
  }

  Widget _buildPhotoCircle(Author author) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Hero(
        tag: 'author_${author.id}',
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: author.photoUrl.isNotEmpty
                ? Image.network(
                    author.photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildAvatar(author),
                  )
                : _buildAvatar(author),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Author author) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[300]!, Colors.blue[600]!],
        ),
      ),
      child: Center(
        child: Text(
          author.initial,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
