import 'package:ei_books/app/controllers/explore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreHeader extends StatelessWidget {
  final ExploreController ctrl;
  const ExploreHeader({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20, right: 20, bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explore Buku',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins')),
                  Text('Temukan buku favoritmu',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontFamily: 'Poppins')),
                ],
              ),
              const Spacer(),
              Obx(() => GestureDetector(
                onTap: ctrl.toggleFilter,
                child: Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: ctrl.showFilter.value
                        ? Colors.white
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.tune_rounded,
                      color: ctrl.showFilter.value
                          ? const Color(0xFF1565C0)
                          : Colors.white,
                      size: 22),
                ),
              )),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                Icon(Icons.search_rounded, color: Colors.grey[400], size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: ctrl.setSearch,
                    decoration: InputDecoration(
                      hintText: 'Cari judul, penulis...',
                      hintStyle:
                          TextStyle(color: Colors.grey[400], fontSize: 14, fontFamily: 'Poppins'),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black87, fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
