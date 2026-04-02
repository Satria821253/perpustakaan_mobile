import 'package:flutter/material.dart';

class AuthorsCard extends StatelessWidget {
  const AuthorsCard({super.key});

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
                  TextSpan(text: 'egarang'),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 36,
              child: Stack(
                children: [
                  _avatar(0, const Color(0xFF8B0000)),
                  _avatar(20, const Color(0xFF5D0000)),
                  _avatar(40, const Color(0xFF3B0000)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(double left, Color color) {
    return Positioned(
      left: left,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: const Icon(Icons.person, color: Colors.white54, size: 16),
      ),
    );
  }
}
