import 'package:flutter/material.dart';

class PsStepsCard extends StatelessWidget {
  const PsStepsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        icon: Icons.send_rounded,
        color: const Color(0xFF10B981),
        bg: const Color(0xFFD1FAE5),
        title: 'Permintaan dikirim',
        desc: 'Permintaan perpanjangan berhasil dikirim ke sistem.',
        done: true,
      ),
      (
        icon: Icons.manage_accounts_rounded,
        color: const Color(0xFFF59E0B),
        bg: const Color(0xFFFEF3C7),
        title: 'Menunggu persetujuan',
        desc: 'Petugas sedang memeriksa permintaan kamu.',
        done: false,
      ),
      (
        icon: Icons.check_circle_rounded,
        color: const Color(0xFF6B7280),
        bg: const Color(0xFFF3F4F6),
        title: 'Hasil keputusan',
        desc: 'Perpanjangan disetujui atau ditolak.',
        done: false,
      ),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.timeline_rounded, size: 16, color: Color(0xFF1565C0)),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Status Proses',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Color(0xFF1A1D23),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(steps.length, (i) {
                final step = steps[i];
                final isLast = i == steps.length - 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: step.bg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(step.icon, size: 18, color: step.color),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 36,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: step.done
                                  ? const Color(0xFF10B981).withOpacity(0.3)
                                  : const Color(0xFFE5E7EB),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 6, bottom: isLast ? 0 : 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  step.title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                    color: step.done
                                        ? const Color(0xFF1A1D23)
                                        : i == 1
                                            ? const Color(0xFFF59E0B)
                                            : const Color(0xFF9CA3AF),
                                  ),
                                ),
                                if (i == 1) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF59E0B),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              step.desc,
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'Poppins',
                                color: Color(0xFF9CA3AF),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
