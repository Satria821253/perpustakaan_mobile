import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/author_service.dart';
import '../../../models/author_model.dart';

class AuthorsCard extends StatefulWidget {
  const AuthorsCard({super.key});

  @override
  State<AuthorsCard> createState() => _AuthorsCardState();
}

class _AuthorsCardState extends State<AuthorsCard> {
  final _authorService = AuthorService();
  List<Author> _authors = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAuthors();
  }

  Future<void> _loadAuthors() async {
    try {
      final authors = await _authorService.getPopularAuthors(limit: 3);
      if (mounted) {
        setState(() {
          _authors = authors;
          _loading = false;
        });
      }
    } catch (e) {
      print('Error loading authors: $e');
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    height: 1.4),
                children: [
                  TextSpan(
                      text: 'P',
                      style: TextStyle(
                          color: Color(0xFFFF6B35),
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  TextSpan(text: 'enulis\n&\n'),
                  TextSpan(
                      text: 'P',
                      style: TextStyle(
                          color: Color(0xFFFF6B35),
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  TextSpan(text: 'engarang'),
                ],
              ),
            ),
            const Spacer(),
            _loading
                ? const SizedBox(
                    height: 36,
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white70),
                        ),
                      ),
                    ),
                  )
                : _authors.isEmpty
                    ? SizedBox(
                        height: 36,
                        child: Stack(
                          children: [
                            _avatar(0, const Color(0xFF8B0000), null, '?'),
                            _avatar(20, const Color(0xFF5D0000), null, '?'),
                            _avatar(40, const Color(0xFF3B0000), null, '?'),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 36,
                        child: Stack(
                          children: List.generate(
                            _authors.length > 3 ? 3 : _authors.length,
                            (i) {
                              final author = _authors[i];
                              final colors = [
                                const Color(0xFF8B0000),
                                const Color(0xFF5D0000),
                                const Color(0xFF3B0000),
                              ];
                              return _avatar(
                                i * 20.0,
                                colors[i],
                                author.photoUrl.isNotEmpty
                                    ? author.photoUrl
                                    : null,
                                author.initial,
                              );
                            },
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(double left, Color color, String? photoUrl, String initial) {
    return Positioned(
      left: left,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: photoUrl != null ? Colors.white : color,
          border: Border.all(color: Colors.white, width: 1.5),
          image: photoUrl != null
              ? DecorationImage(
                  image: NetworkImage(photoUrl),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                )
              : null,
        ),
        child: photoUrl == null
            ? Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
