import 'package:ei_books/app/controllers/pembayaran_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'shared_widgets.dart';

class MetodeKasir extends StatelessWidget {
  final PembayaranController ctrl;
  const MetodeKasir({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = ctrl.selectedMetode.value == 'kasir';
      return MetodeBase(
        isActive: active,
        onTap: () => ctrl.selectMetode('kasir'),
        leading: const MetodeIcon(color: Color(0xFFF57C00), icon: Icons.store_outlined),
        title: 'Bayar di Perpustakaan',
        subtitle: 'Langsung ke kasir · Gratis admin',
        badge: const PaymentBadge(label: 'Gratis', color: Color(0xFF2E7D32), bgColor: Color(0xFFE8F5E9)),
        trailing: RadioDot(active: active),
      );
    });
  }
}

class MetodeEwallet extends StatelessWidget {
  final PembayaranController ctrl;
  const MetodeEwallet({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = ctrl.selectedMetode.value == 'ewallet';
      final expanded = ctrl.ewalletExpanded.value;
      final selected = ctrl.selectedEwallet.value;

      String subtitle = 'GoPay · OVO · DANA · ShopeePay';
      if (selected.isNotEmpty) {
        final e = ctrl.ewallets.firstWhere((e) => e['id'] == selected);
        subtitle = '${e['label']} dipilih';
      }

      return Column(
        children: [
          MetodeBase(
            isActive: active,
            onTap: ctrl.toggleEwallet,
            leading: const MetodeIcon(color: Color(0xFF6A1B9A), icon: Icons.account_balance_wallet_outlined),
            title: 'E-Wallet',
            subtitle: subtitle,
            badge: Row(
              children: ctrl.ewallets.map((e) => EwalletChip(
                label: e['short'] as String,
                color: e['color'] as Color,
              )).toList(),
            ),
            trailing: Icon(
              expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              color: Colors.grey[400],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: expanded
                ? Container(
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF1565C0).withOpacity(0.3)),
                    ),
                    child: Column(
                      children: ctrl.ewallets.asMap().entries.map((entry) {
                        final i = entry.key;
                        final e = entry.value;
                        final isLast = i == ctrl.ewallets.length - 1;
                        final isSelected = ctrl.selectedEwallet.value == e['id'];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => ctrl.selectEwallet(e['id'] as String),
                              borderRadius: BorderRadius.circular(14),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36, height: 36,
                                      decoration: BoxDecoration(
                                        color: e['color'] as Color,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(e['short'] as String,
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 10,
                                                fontWeight: FontWeight.w800)),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(e['label'] as String,
                                          style: const TextStyle(
                                              fontSize: 14, fontWeight: FontWeight.w600,
                                              color: Colors.black87)),
                                    ),
                                    RadioDot(active: isSelected),
                                  ],
                                ),
                              ),
                            ),
                            if (!isLast)
                              Divider(height: 1, color: Colors.grey[100], indent: 64, endIndent: 16),
                          ],
                        );
                      }).toList(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      );
    });
  }
}

class MetodeKoin extends StatelessWidget {
  final PembayaranController ctrl;
  const MetodeKoin({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = ctrl.selectedMetode.value == 'koin';
      final cukup = ctrl.koinCukup;

      return MetodeBase(
        isActive: active,
        onTap: cukup ? () => ctrl.selectMetode('koin') : null,
        leading: const MetodeIcon(color: Color(0xFFFFB300), icon: Icons.monetization_on_outlined),
        title: 'Koin Aplikasi',
        subtitle: 'Saldo: ${formatKoin(ctrl.saldoKoin)} koin',
        subtitleColor: const Color(0xFFFFB300),
        badge: PaymentBadge(
          label: cukup
              ? 'Cukup'
              : 'Butuh ${formatKoin(ctrl.user.value['koin_dibutuhkan'] as int? ?? 0)} koin — tidak cukup',
          color: cukup ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
          bgColor: cukup ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        ),
        trailing: RadioDot(active: active, disabled: !cukup),
      );
    });
  }
}

class MetodeQR extends StatelessWidget {
  final PembayaranController ctrl;
  const MetodeQR({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = ctrl.selectedMetode.value == 'qr';
      return MetodeBase(
        isActive: active,
        onTap: () => ctrl.selectMetode('qr'),
        leading: const MetodeIcon(color: Color(0xFF2E7D32), icon: Icons.qr_code_2_rounded),
        title: 'QR Code',
        subtitle: 'Scan di kasir atau mesin bayar',
        trailing: RadioDot(active: active),
      );
    });
  }
}
