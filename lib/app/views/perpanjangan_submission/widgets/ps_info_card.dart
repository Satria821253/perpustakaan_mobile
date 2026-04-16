import 'package:flutter/material.dart';

class PsInfoCard extends StatelessWidget {
  const PsInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Color(0xFF1565C0),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Kamu akan menerima notifikasi ketika permintaan disetujui atau ditolak oleh petugas.',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: Color(0xFF1E40AF),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
