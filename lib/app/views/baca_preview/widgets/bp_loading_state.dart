import 'package:flutter/material.dart';

class BpErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const BpErrorState({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book_rounded,
                size: 64, color: Color(0xFFCCCCCC)),
            const SizedBox(height: 16),
            const Text('Preview Tidak Tersedia',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                    fontFamily: 'Poppins')),
            const SizedBox(height: 8),
            Text(message,
                style: const TextStyle(
                    color: Color(0xFF888888), fontFamily: 'Poppins'),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4361EE),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
