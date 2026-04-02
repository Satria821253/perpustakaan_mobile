import 'package:flutter/material.dart';
import '../../../controllers/home_controller.dart';
import 'carousel_banner.dart';
import 'challenge_card.dart';
import 'authors_card.dart';

class BannerSlider extends StatelessWidget {
  final HomeController ctrl;
  const BannerSlider({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200 + 24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Timer di belakang (tertutup banner)
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                const SizedBox(width: 10),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 59, 106, 236),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: const Text('07:00:00',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontFamily: 'Poppins')),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          // Banner di depan (menutupi bagian bawah timer)
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            height: 200 + 8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Expanded(child: CarouselBanner()),
                SizedBox(width: 10),
                Expanded(child: ChallengeCard()),
                SizedBox(width: 10),
                Expanded(child: AuthorsCard()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
