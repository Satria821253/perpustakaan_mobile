import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';
import '../../../controllers/auth_controller.dart';

class ProfileKoinCard extends StatelessWidget {
  final ProfileController ctrl;
  const ProfileKoinCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Obx(() {
        final koin = AuthController.to.user.value?.koin ?? 0;
        final totalPinjam = ctrl.totalDipinjam.value;
        final denda = ctrl.totalDenda.value;
        final tepat = denda == 0 ? 100 : 75;

        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFF8E1)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset('assets/coin.png'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Koin', style: TextStyle(fontSize: 11, color: Colors.grey[500], fontFamily: 'Poppins')),
                      Text('$koin Coin',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                              color: Color(0xFFFFB300), fontFamily: 'Poppins')),
                    ],
                  ),
                ],
              ),
            ),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            Expanded(
              child: Column(
                children: [
                  Text('$totalPinjam',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                          color: Colors.black87, fontFamily: 'Poppins')),
                  Text('Total Pinjam', style: TextStyle(fontSize: 11, color: Colors.grey[500], fontFamily: 'Poppins')),
                ],
              ),
            ),
            Container(width: 1, height: 40, color: Colors.grey[200]),
            Expanded(
              child: Column(
                children: [
                  Text('$tepat%',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                          color: Color(0xFF43A047), fontFamily: 'Poppins')),
                  Text('Tepat Waktu', style: TextStyle(fontSize: 11, color: Colors.grey[500], fontFamily: 'Poppins')),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
