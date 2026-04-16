import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/detail_perpanjang_controller.dart';
import '../../../models/extension_request_model.dart';
import '../../../widgets/app_shared_widgets.dart';

class DpxTimelineCard extends StatelessWidget {
  final DetailPerpanjangController ctrl;
  const DpxTimelineCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: appCardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appSectionTitle('Riwayat permintaan perpanjangan'),
          const SizedBox(height: 16),
          Obx(() {
            if (ctrl.requests.isEmpty) {
              return _EmptyState();
            }
            return Column(
              children: List.generate(ctrl.requests.length, (i) {
                return DpxRequestItem(
                  item: ctrl.requests[i],
                  ctrl: ctrl,
                  isLast: i == ctrl.requests.length - 1,
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.event_repeat_rounded,
                  size: 26, color: Colors.grey.shade300),
            ),
            const SizedBox(height: 12),
            Text(
              'Belum ada permintaan perpanjangan',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[400],
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Satu item timeline
// ─────────────────────────────────────────────────────────────
class DpxRequestItem extends StatelessWidget {
  final ExtensionRequestModel item;
  final DetailPerpanjangController ctrl;
  final bool isLast;
  const DpxRequestItem({
    super.key,
    required this.item,
    required this.ctrl,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(item.status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Garis kiri + ikon ─────────────────────────────
          SizedBox(
            width: 34,
            child: Column(
              children: [
                _TimelineIcon(
                  icon: config.icon,
                  color: config.color,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: const Color(0xFFEEEEEE),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // ── Konten ────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: _RequestCard(item: item, config: config),
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _statusConfig(String status) {
    switch (status) {
      case 'approved':
        return _StatusConfig(
          color: const Color(0xFF2E7D32),
          backgroundColor: const Color(0xFFF1FBF2),
          borderColor: const Color(0xFFC8E6C9),
          badgeBg: const Color(0xFFE8F5E9),
          icon: Icons.check_circle_outline_rounded,
          label: 'Disetujui',
        );
      case 'denied':
      case 'rejected':
        return _StatusConfig(
          color: const Color(0xFFC62828),
          backgroundColor: const Color(0xFFFFF8F8),
          borderColor: const Color(0xFFFFCDD2),
          badgeBg: const Color(0xFFFFEBEE),
          icon: Icons.cancel_outlined,
          label: 'Ditolak',
        );
      default: // pending
        return _StatusConfig(
          color: const Color(0xFFE65100),
          backgroundColor: const Color(0xFFFFFDF5),
          borderColor: const Color(0xFFFFE082),
          badgeBg: const Color(0xFFFFF8E1),
          icon: Icons.schedule_rounded,
          label: 'Menunggu',
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Ikon bulat di garis waktu
// ─────────────────────────────────────────────────────────────
class _TimelineIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _TimelineIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Kartu isi tiap item
// ─────────────────────────────────────────────────────────────
class _RequestCard extends StatelessWidget {
  final ExtensionRequestModel item;
  final _StatusConfig config;
  const _RequestCard({required this.item, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: config.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: durasi + badge status
          Row(
            children: [
              Expanded(
                child: Text(
                  'Perpanjang ${item.durasiHari} hari',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _Badge(label: config.label, config: config),
            ],
          ),
          const SizedBox(height: 7),

          // Alasan
          _DetailRow(
            label: 'Alasan',
            value: item.alasan,
            valueColor: Colors.grey.shade700,
          ),
          const SizedBox(height: 4),

          // Tanggal pengajuan
          _DetailRow(
            label: 'Diajukan',
            value: item.tanggalRequest,
            valueColor: Colors.grey.shade500,
            valueFontSize: 11,
          ),

          // Jatuh tempo baru (hanya jika approved)
          if (item.tanggalKembaliBaru != null) ...[
            const SizedBox(height: 6),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.event_available_rounded,
                    size: 12, color: Color(0xFF2E7D32)),
                const SizedBox(width: 5),
                Text(
                  'Jatuh tempo baru: ',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  item.tanggalKembaliBaru!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D32),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],

          // Catatan petugas (hanya jika ada)
          if (item.catatanPetugas != null &&
              item.catatanPetugas!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: config.color.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 12, color: config.color),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      item.catatanPetugas!,
                      style: TextStyle(
                        fontSize: 11,
                        color: config.color,
                        fontFamily: 'Poppins',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final _StatusConfig config;
  const _Badge({required this.label, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: config.badgeBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: config.color,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final double valueFontSize;
  const _DetailRow({
    required this.label,
    required this.value,
    required this.valueColor,
    this.valueFontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: valueFontSize,
          fontFamily: 'Poppins',
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: valueFontSize,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: valueColor, fontSize: valueFontSize),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Data class konfigurasi status
// ─────────────────────────────────────────────────────────────
class _StatusConfig {
  final Color color;
  final Color backgroundColor;
  final Color borderColor;
  final Color badgeBg;
  final IconData icon;
  final String label;

  const _StatusConfig({
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
    required this.badgeBg,
    required this.icon,
    required this.label,
  });
}