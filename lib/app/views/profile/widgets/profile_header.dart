import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../controllers/auth_controller.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController ctrl;
  const ProfileHeader({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30, top: 20,
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            right: 103, top: 90,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              child: Obx(() {
                final user = AuthController.to.user.value;
                final statusLabel = _statusLabel(user?.status);
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Poppins'),
                            children: [
                              TextSpan(text: 'Ei', style: TextStyle(color: Color(0xFFE84B1A))),
                              TextSpan(text: '-Book', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        Obx(() {
                          final loc = Get.find<HomeController>().lokasi.value;
                          if (loc.isEmpty) return const SizedBox.shrink();
                          return Row(
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFFE84B1A), size: 16),
                              const SizedBox(width: 4),
                              Text(loc,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12, fontFamily: 'Poppins')),
                            ],
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Stack(
                      children: [
                        Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            color: Colors.grey[800],
                          ),
                          child: ClipOval(
                            child: user?.photoProfile != null && user!.photoProfile.isNotEmpty
                                ? Image.network(user.photoProfile, fit: BoxFit.cover)
                                : const Icon(Icons.person, color: Colors.white54, size: 50),
                          ),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: GestureDetector(
                            onTap: ctrl.pickAndUploadPhoto,
                            child: Obx(() => Container(
                              width: 28, height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD600),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: ctrl.isUploadingPhoto.value
                                  ? const Padding(
                                      padding: EdgeInsets.all(6),
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2))
                                  : const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                            )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.nama ?? '-',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 20,
                          fontWeight: FontWeight.w800, fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '-',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13, fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                      ),
                      child: Text(statusLabel,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13,
                              fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
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

  String _statusLabel(String? status) {
    final s = status?.toLowerCase().trim() ?? '';
    if (s == 'aktif' || s == 'active' || s == '1') return 'Member Aktif';
    if (s == 'suspended') return 'Suspended';
    if (s.isEmpty) return 'Member Aktif'; // default jika null/kosong
    return 'Member Aktif'; // fallback
  }
}
