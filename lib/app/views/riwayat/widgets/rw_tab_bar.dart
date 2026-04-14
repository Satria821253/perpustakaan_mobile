import 'package:flutter/material.dart';

class RwTabBar extends StatelessWidget implements PreferredSizeWidget {
  const RwTabBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const TabBar(
        indicatorColor: Color(0xFF1565C0),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Color(0xFF1565C0),
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'Poppins',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
        tabs: [
          Tab(text: 'Peminjaman'),
          Tab(text: 'Perpanjangan'),
          Tab(text: 'Pengembalian'),
          Tab(text: 'Transaksi'),
        ],
      ),
    );
  }
}
