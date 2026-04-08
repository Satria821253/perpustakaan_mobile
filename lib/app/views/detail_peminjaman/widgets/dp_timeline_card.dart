import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/detail_peminjaman_controller.dart';
import '../../../models/borrowing_detail_model.dart';
import 'dp_helpers.dart';

class DpTimelineCard extends StatelessWidget {
  final DetailPeminjamanController ctrl;
  const DpTimelineCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: dpCardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dpSectionTitle('Riwayat Aktivitas'),
          const SizedBox(height: 16),
          Obx(() {
            final items = ctrl.detail.value?.timeline ?? [];
            if (items.isEmpty) {
              return Text('Belum ada aktivitas',
                  style: TextStyle(fontSize: 13, color: Colors.grey[400]));
            }
            return Column(
              children: List.generate(items.length, (i) => DpTimelineItem(
                item: items[i],
                isLast: i == items.length - 1,
              )),
            );
          }),
        ],
      ),
    );
  }
}

class DpTimelineItem extends StatelessWidget {
  final TimelineItem item;
  final bool isLast;
  const DpTimelineItem({super.key, required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: Icon(item.icon, color: item.color, size: 16),
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
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.description,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                  const SizedBox(height: 3),
                  Text(item.createdAt,
                      style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
