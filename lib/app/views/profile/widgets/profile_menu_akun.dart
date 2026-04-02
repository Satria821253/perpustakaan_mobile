import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';

class ProfileMenuAkun extends StatelessWidget {
  final ProfileController ctrl;
  const ProfileMenuAkun({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Obx(() => _MenuItemToggle(
                icon: Icons.notifications_outlined,
                iconColor: const Color(0xFF1565C0),
                label: 'Notifikasi',
                value: ctrl.notifEnabled.value,
                onChanged: ctrl.toggleNotif,
              )),
          _divider(),
          _MenuItem(
            icon: Icons.edit_outlined,
            iconColor: const Color(0xFF1565C0),
            label: 'Edit Profile',
            onTap: () => Get.toNamed('/edit-profile'),
          ),
          _divider(),
          _MenuItem(
            icon: Icons.lock_outline_rounded,
            iconColor: const Color(0xFF6A1B9A),
            label: 'Ubah Password',
            onTap: () => Get.toNamed('/ubah-password'),
          ),
          _divider(),
          _MenuItem(
            icon: Icons.help_outline_rounded,
            iconColor: const Color(0xFF00838F),
            label: 'Bantuan & FAQ',
            onTap: () {},
          ),
          _divider(),
          _MenuItem(
            icon: Icons.logout_rounded,
            iconColor: const Color(0xFFD32F2F),
            iconBgColor: const Color(0xFFFFEBEE),
            label: 'Keluar',
            labelColor: const Color(0xFFD32F2F),
            onTap: ctrl.logout,
            showArrow: false,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey[100], indent: 58, endIndent: 16);
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color? iconBgColor, labelColor;
  final String label;
  final VoidCallback onTap;
  final bool showArrow;

  const _MenuItem({
    required this.icon, required this.iconColor,
    required this.label, required this.onTap,
    this.iconBgColor, this.labelColor, this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: iconBgColor ?? iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                      color: labelColor ?? Colors.black87, fontFamily: 'Poppins')),
            ),
            if (showArrow) Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}

class _MenuItemToggle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _MenuItemToggle({
    required this.icon, required this.iconColor,
    required this.label, required this.value, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                    color: Colors.black87, fontFamily: 'Poppins')),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF1565C0),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
