import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_koin_card.dart';
import 'widgets/profile_nomor_anggota.dart';
import 'widgets/profile_statistik.dart';
import 'widgets/profile_buku_dipinjam.dart';
import 'widgets/profile_info_akun.dart';
import 'widgets/profile_menu_akun.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ProfileController(), permanent: true);
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(ctrl: ctrl),
            const SizedBox(height: 16),
            ProfileKoinCard(ctrl: ctrl),
            const SizedBox(height: 12),
            ProfileNomorAnggota(ctrl: ctrl),
            const SizedBox(height: 12),
            ProfileStatistik(ctrl: ctrl),
            const SizedBox(height: 12),
            ProfileBukuDipinjam(ctrl: ctrl),
            const SizedBox(height: 12),
            ProfileInfoAkun(ctrl: ctrl),
            const SizedBox(height: 12),
            ProfileMenuAkun(ctrl: ctrl),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
