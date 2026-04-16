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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());
    _ctrl.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: RefreshIndicator(
        onRefresh: () async {
          await _ctrl.fetchAll();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              ProfileHeader(ctrl: _ctrl),
              const SizedBox(height: 16),
              ProfileKoinCard(ctrl: _ctrl),
              const SizedBox(height: 12),
              ProfileNomorAnggota(ctrl: _ctrl),
              const SizedBox(height: 12),
              ProfileStatistik(ctrl: _ctrl),
              const SizedBox(height: 12),
              ProfileBukuDipinjam(ctrl: _ctrl),
              const SizedBox(height: 12),
              ProfileInfoAkun(ctrl: _ctrl),
              const SizedBox(height: 12),
              ProfileMenuAkun(ctrl: _ctrl),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
