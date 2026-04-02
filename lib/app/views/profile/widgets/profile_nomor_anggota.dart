import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/profile_controller.dart';

class ProfileNomorAnggota extends StatelessWidget {
  final ProfileController ctrl;
  const ProfileNomorAnggota({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Obx(() {
        final user = AuthController.to.user.value;
        final nomor = user?.nomorAnggota ?? '-';
        final s = user?.status.toLowerCase().trim() ?? '';
        final aktif = s.isEmpty || s == 'aktif' || s == 'active' || s == '1';
        return Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
              child: const Icon(Icons.badge_outlined, color: Colors.black54, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nomor Anggota',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500], fontFamily: 'Poppins')),
                  Text(nomor,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                          color: Colors.black87, letterSpacing: 0.5, fontFamily: 'Poppins')),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: aktif ? const Color(0xFFE8F5E9) : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                aktif ? 'Aktif' : 'Nonaktif',
                style: TextStyle(
                    color: aktif ? const Color(0xFF2E7D32) : Colors.grey[600],
                    fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
              ),
            ),
          ],
        );
      }),
    );
  }
}
