import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';

class ProfileChallenge extends StatelessWidget {
  final ProfileController ctrl;
  const ProfileChallenge({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ch = ctrl.challenge.value;
      if (ch == null) return const SizedBox.shrink();

      final n = (dynamic v) => v is num ? v : num.tryParse(v?.toString() ?? '') ?? 0;
      final pct = n(ch['percentage']) / 100;
      final read = n(ch['books_read']).toInt();
      final target = n(ch['target']).toInt();
      final reward = n(ch['reward_koin']).toInt();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFD600), size: 22),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Challenge Bulan Ini',
                      style: TextStyle(color: Colors.white, fontSize: 14,
                          fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('+$reward Koin',
                      style: const TextStyle(color: Colors.white, fontSize: 12,
                          fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: pct.clamp(0.0, 1.0),
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD600)),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$read / $target buku',
                    style: const TextStyle(color: Colors.white, fontSize: 13,
                        fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                Text('${(pct * 100).toStringAsFixed(0)}%',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12, fontFamily: 'Poppins')),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text('Lihat Semua Challenge',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
              ),
            ),
          ],
        ),
      );
    });
  }
}
