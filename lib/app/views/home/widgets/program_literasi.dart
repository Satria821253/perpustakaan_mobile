import 'package:flutter/material.dart';

class ProgramLiterasi extends StatelessWidget {
  const ProgramLiterasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Program Literasi Bulanan',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins')),
                const SizedBox(height: 2),
                Text('Sisa: hari jam',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 11,
                        fontFamily: 'Poppins')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _LiterasiCard(
                        title: 'Target Dasar',
                        body: 'Baca 5 Buku\nGet 30 Coin',
                        icon: Icons.book_outlined,
                        bgColor: const Color(0xFFE3F2FD),
                        fgColor: const Color(0xFF1565C0),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _LiterasiCard(
                        title: 'Target Prestasi',
                        body: 'Baca 8 Buku\nGet Sertifikat Digital\n+ 75 Coin',
                        icon: Icons.emoji_events_outlined,
                        bgColor: const Color(0xFFFFF8E1),
                        fgColor: const Color(0xFFF57C00),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 0, bottom: 0,
            child: Opacity(
              opacity: 0.15,
              child: const Icon(Icons.local_library, size: 80, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiterasiCard extends StatelessWidget {
  final String title, body;
  final IconData icon;
  final Color bgColor, fgColor;
  const _LiterasiCard({
    required this.title,
    required this.body,
    required this.icon,
    required this.bgColor,
    required this.fgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: fgColor,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: fgColor, size: 26),
              const SizedBox(width: 6),
              Expanded(
                child: Text(body,
                    style: TextStyle(
                        fontSize: 11, color: fgColor, height: 1.5, fontFamily: 'Poppins')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
