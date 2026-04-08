import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/konfirmasi_kembali_controller.dart';
import 'kk_helpers.dart';

class KkDendaSection extends StatelessWidget {
  final KonfirmasiKembaliController ctrl;
  const KkDendaSection({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFF57C00), size: 20),
              const SizedBox(width: 8),
              kkSectionTitle('Pembayaran Denda'),
            ],
          ),
          const SizedBox(height: 4),
          Text('Rp ${kkFmt(ctrl.denda)}',
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFD32F2F))),
          const SizedBox(height: 14),
          const Text('Metode Pembayaran',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54)),
          const SizedBox(height: 10),
          Obx(() => Column(
                children: [
                  KkMetodeCard(
                    isSelected: ctrl.metodePembayaran.value == 'koin',
                    onTap: () => ctrl.setMetode('koin'),
                    icon: Icons.monetization_on_outlined,
                    iconColor: const Color(0xFFFFB300),
                    title: 'Bayar dengan Koin',
                    subtitle: 'Saldo: ${ctrl.saldoKoin} koin',
                    trailing: !ctrl.koinCukup
                        ? const Text('Koin tidak cukup',
                            style: TextStyle(fontSize: 11, color: Colors.red))
                        : null,
                  ),
                  const SizedBox(height: 8),
                  KkMetodeCard(
                    isSelected: ctrl.metodePembayaran.value == 'tunai',
                    onTap: () => ctrl.setMetode('tunai'),
                    icon: Icons.payments_outlined,
                    iconColor: const Color(0xFF2E7D32),
                    title: 'Bayar Tunai ke Petugas',
                    subtitle: 'Bayar langsung saat pengembalian',
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class KkMetodeCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final Widget? trailing;

  const KkMetodeCard({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1565C0).withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1565C0) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                  Text(subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
            ),
            if (trailing != null) ...[trailing!, const SizedBox(width: 8)],
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1565C0)
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF1565C0) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
