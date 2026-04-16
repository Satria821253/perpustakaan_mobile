import 'package:flutter/material.dart';

class KrInfoBukuCard extends StatelessWidget {
  final String judul;
  final String author;
  final String? coverImage;
  final String expiresAt;
  const KrInfoBukuCard({
    super.key,
    required this.judul,
    required this.author,
    this.coverImage,
    required this.expiresAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: coverImage != null
                ? Image.network(
                    coverImage!,
                    width: 60,
                    height: 82,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontFamily: 'Poppins',
                  ),
                ),
                if (expiresAt.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: Color(0xFFF57C00),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Berlaku hingga: $expiresAt',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFF57C00),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 60,
    height: 82,
    color: const Color(0xFF1A1A2E),
    child: const Center(
      child: Icon(Icons.menu_book, color: Colors.white24, size: 24),
    ),
  );
}

class KrLangkahCard extends StatelessWidget {
  const KrLangkahCard({super.key});

  @override
  Widget build(BuildContext context) {
    final langkah = [
      (Icons.qr_code_rounded, 'Simpan atau salin kode reservasi ini'),
      (Icons.directions_walk_rounded, 'Datang ke perpustakaan'),
      (Icons.badge_rounded, 'Tunjukkan kode ke petugas'),
      (Icons.menu_book_rounded, 'Petugas akan menyiapkan buku untuk kamu'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Langkah Selanjutnya',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(langkah.length, (i) {
            final (icon, text) = langkah[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecor() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ],
);
