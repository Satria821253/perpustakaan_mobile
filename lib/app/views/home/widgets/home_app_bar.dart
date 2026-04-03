import 'package:ei_books/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/notification_controller.dart';
import '../../home/search_page.dart';
import 'circle_icon_button.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 20,
        right: 20,
        bottom: 52,
      ),
      child: Column(
        children: [
          // Baris 1: Logo + Lokasi
          Row(
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontStyle: FontStyle.italic),
                  children: [
                    TextSpan(
                        text: 'Ei',
                        style: TextStyle(
                            color: Color(0xFFE84B1A),
                            fontSize: 24,
                            fontWeight: FontWeight.w800)),
                    TextSpan(
                        text: '-',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800)),
                    TextSpan(
                        text: 'Book',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const Spacer(),
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
          const SizedBox(height: 18),

          // Baris 2: Avatar + Info + Ikon
          Obx(() {
            final user = AuthController.to.user.value;
            return Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.grey[700],
                    ),
                    child: ClipOval(
                      child: user?.photoProfile.isNotEmpty == true
                          ? Image.network(user!.photoProfile, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.white54, size: 38))
                          : const Icon(Icons.person, color: Colors.white54, size: 38),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Hallo, Selamat Datang',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontFamily: 'Poppins')),
                        Text(
                          user?.nama ?? 'Tamu',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins'),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 18, height: 18, child: Image.asset('assets/coin.png')),
                            const SizedBox(width: 4),
                            Text(
                              '${user?.koin ?? 0} Koin',
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CircleIconButton(
                    icon: Icons.favorite_border_outlined,
                    onTap: () => Get.toNamed('/favorit'),
                  ),
                  const SizedBox(width: 8),
                  Obx(() {
                    final ctrl = Get.isRegistered<NotificationController>()
                        ? NotificationController.to
                        : null;
                    final count = ctrl?.unreadCount.value ?? 0;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleIconButton(
                          icon: Icons.notifications_outlined,
                          onTap: () => Get.toNamed(Routes.notifications),
                        ),
                        if (count > 0)
                          Positioned(
                            top: -2, right: -2,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                              child: Text(
                                count > 99 ? '99+' : '$count',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 9,
                                    fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              );
          }),
          const SizedBox(height: 32),

          // Baris 3: Search + Kalender
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.to(() => const SearchPage(),
                      transition: Transition.fadeIn),
                  child: Container(
                    height: 43,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Icon(Icons.search, color: Colors.grey[400], size: 20),
                        const SizedBox(width: 8),
                        Text('Cari Buku...',
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                                fontFamily: 'Poppins')),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CircleIconButton(icon: Icons.calendar_today_outlined),
            ],
          ),
        ],
      ),
    );
  }
}
