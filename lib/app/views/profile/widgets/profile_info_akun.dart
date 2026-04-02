import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';
import '../../../controllers/auth_controller.dart';

class ProfileInfoAkun extends StatelessWidget {
  final ProfileController ctrl;
  const ProfileInfoAkun({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Obx(() {
        final user = AuthController.to.user.value;
        final denda = ctrl.totalDenda.value;
        final sedang = ctrl.sedangDipinjam.value;
        final limit = ctrl.limitPinjam.value;
        final tglDaftar = _formatTanggal(user?.tanggalDaftar);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Informasi Akun',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
                    color: Colors.black87, fontFamily: 'Poppins')),
            const SizedBox(height: 14),
            _InfoRow(label: 'Email', value: user?.email ?? '-'),
            _InfoRow(
              label: 'No. Telepon',
              value: user?.noTelepon.isNotEmpty == true ? user!.noTelepon : '-',
            ),
            _InfoRow(label: 'Buku Dipinjam', value: '$sedang / $limit Buku'),
            _InfoRow(
              label: 'Total Denda',
              value: 'Rp $denda',
              valueColor: denda > 0 ? const Color(0xFFD32F2F) : Colors.black87,
            ),
            _InfoRow(label: 'Bergabung', value: tglDaftar, isLast: true),
          ],
        );
      }),
    );
  }

  String _formatTanggal(String? raw) {
    if (raw == null || raw.isEmpty) return '-';
    try {
      final dt = DateTime.parse(raw);
      const bulan = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
                     'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
      return '${dt.day} ${bulan[dt.month]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  final bool isLast;

  const _InfoRow({
    required this.label, required this.value,
    this.valueColor, this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], fontFamily: 'Poppins')),
              Text(value,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: valueColor ?? Colors.black87, fontFamily: 'Poppins')),
            ],
          ),
        ),
        if (!isLast) Divider(color: Colors.grey[100], height: 1),
      ],
    );
  }
}
