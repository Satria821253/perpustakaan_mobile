import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/perpanjang_controller.dart';

class PsStatusCard extends StatelessWidget {
  const PsStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final borrowingId = Get.arguments?['borrowingId'] as int? ?? 0;
    final controller = Get.find<PerpanjangController>(
      tag: 'submission_$borrowingId',
    );

    return Obx(() {
      final riwayat = controller.riwayat;
      final status = riwayat.isNotEmpty ? riwayat.first.status : 'pending';

      return Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getBgColor(status),
                    border: Border.all(
                      color: _getBorderColor(status),
                      width: 8,
                    ),
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getIconBgColor(status),
                    border: Border.all(
                      color: _getBorderColor(status).withOpacity(0.6),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _getIcon(status),
                    size: 32,
                    color: _getIconColor(status),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: _getBadgeBgColor(status),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: _getBadgeBorderColor(status),
                  width: 1,
                ),
              ),
              child: Text(
                _getStatusLabel(status),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: _getBadgeTextColor(status),
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _getTitle(status),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins',
                color: Color(0xFF1A1D23),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getMessage(status),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
                color: Color(0xFF6B7280),
                height: 1.6,
              ),
            ),
          ],
        ),
      );
    });
  }

  Color _getBgColor(String status) {
    switch (status) {
      case 'approved':
        return const Color(0xFFE8F5E9);
      case 'rejected':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFFFF8E1);
    }
  }

  Color _getBorderColor(String status) {
    switch (status) {
      case 'approved':
        return const Color(0xFF4CAF50).withOpacity(0.4);
      case 'rejected':
        return const Color(0xFFE53935).withOpacity(0.4);
      default:
        return const Color(0xFFFFCC02).withOpacity(0.4);
    }
  }

  Color _getIconBgColor(String status) {
    switch (status) {
      case 'approved':
        return const Color(0xFFC8E6C9);
      case 'rejected':
        return const Color(0xFFFFCDD2);
      default:
        return const Color(0xFFFFF3CD);
    }
  }

  Color _getIconColor(String status) {
    switch (status) {
      case 'approved':
        return const Color(0xFF2E7D32);
      case 'rejected':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFFF57C00);
    }
  }

  IconData _getIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  Color _getBadgeBgColor(String status) {
    switch (status) {
      case 'approved':
        return const Color(0xFFE8F5E9);
      case 'rejected':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFFFF3CD);
    }
  }

  Color _getBadgeBorderColor(String status) {
    switch (status) {
      case 'approved':
        return const Color(0xFF4CAF50);
      case 'rejected':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFFFFCC02);
    }
  }

  Color _getBadgeTextColor(String status) {
    switch (status) {
      case 'approved':
        return const Color(0xFF2E7D32);
      case 'rejected':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFFF57C00);
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Menunggu Persetujuan';
    }
  }

  String _getTitle(String status) {
    switch (status) {
      case 'approved':
        return 'Perpanjangan Disetujui!';
      case 'rejected':
        return 'Perpanjangan Ditolak';
      default:
        return 'Permintaan Terkirim!';
    }
  }

  String _getMessage(String status) {
    switch (status) {
      case 'approved':
        return 'Perpanjangan peminjaman kamu\ntelah disetujui oleh petugas.';
      case 'rejected':
        return 'Maaf, permintaan perpanjangan\ntidak dapat diproses.';
      default:
        return 'Permintaan perpanjangan kamu sedang\ndiproses oleh petugas perpustakaan.';
    }
  }
}
