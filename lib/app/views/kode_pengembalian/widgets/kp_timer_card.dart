import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/kode_pengembalian_controller.dart';

class KpTimerCard extends StatelessWidget {
  final KodePengembalianController ctrl;
  const KpTimerCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expired = ctrl.hampirExpired;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: expired ? const Color(0xFFFFEBEE) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: expired ? const Color(0xFFFFCDD2) : Colors.transparent),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.timer_outlined,
                    color: expired
                        ? const Color(0xFFD32F2F)
                        : const Color(0xFFF57C00),
                    size: 18),
                const SizedBox(width: 8),
                Text(
                  expired ? 'Kode hampir kadaluarsa!' : 'Kode berlaku selama:',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: expired
                          ? const Color(0xFFD32F2F)
                          : Colors.black54),
                ),
                const Spacer(),
                Text(
                  ctrl.timerLabel,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: expired
                          ? const Color(0xFFD32F2F)
                          : const Color(0xFF1565C0)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: ctrl.timerProgress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  expired
                      ? const Color(0xFFD32F2F)
                      : const Color(0xFF1565C0),
                ),
                minHeight: 8,
              ),
            ),
            if (expired) ...[
              const SizedBox(height: 8),
              const Text('Segera tunjukkan kepada petugas!',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFD32F2F),
                      fontWeight: FontWeight.w600)),
            ],
          ],
        ),
      );
    });
  }
}
