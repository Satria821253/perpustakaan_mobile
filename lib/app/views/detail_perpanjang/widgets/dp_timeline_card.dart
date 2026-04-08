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
          appSectionTitle('Riwayat Permintaan Perpanjangan'),
          const SizedBox(height: 16),
          Obx(() {
            if (ctrl.requests.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Icon(Icons.event_repeat_rounded,
                          size: 48, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text('Belum ada permintaan perpanjangan',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[400],
                              fontFamily: 'Poppins')),
                    ],
                  ),
                ),
              );
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

class DpxRequestItem extends StatelessWidget {
  final ExtensionRequestModel item;
  final DetailPerpanjangController ctrl;
  final bool isLast;
  const DpxRequestItem(
      {super.key,
      required this.item,
      required this.ctrl,
      required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = ctrl.statusColor(item.status);
    final label = ctrl.statusLabel(item.status);
    final icon = ctrl.statusIcon(item.status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 18),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey[200],
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Perpanjang ${item.durasiHari} hari',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                fontFamily: 'Poppins')),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(label,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                  fontFamily: 'Poppins')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Alasan: ${item.alasan}',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontFamily: 'Poppins')),
                    const SizedBox(height: 4),
                    Text('Diajukan: ${item.tanggalRequest}',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                            fontFamily: 'Poppins')),
                    if (item.tanggalKembaliBaru != null) ...[
                      const SizedBox(height: 4),
                      Text('Jatuh tempo baru: ${item.tanggalKembaliBaru}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E7D32),
                              fontFamily: 'Poppins')),
                    ],
                    if (item.catatanPetugas != null &&
                        item.catatanPetugas!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('Catatan: ${item.catatanPetugas}',
                          style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontFamily: 'Poppins')),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
