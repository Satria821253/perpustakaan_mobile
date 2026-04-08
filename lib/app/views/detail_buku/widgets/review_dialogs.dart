import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/review_controller.dart';

void showEditReviewSheet(ReviewController ctrl, Map<String, dynamic> review) {
  final ratingEdit = (review['rating'] as num).toInt().obs;
  final textCtrl = TextEditingController(text: review['review'] ?? '');
  Get.bottomSheet(
    Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            const Text('Edit Ulasan',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            Obx(() => Row(
              children: List.generate(5, (i) {
                final star = i + 1;
                return GestureDetector(
                  onTap: () => ratingEdit.value = star,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      star <= ratingEdit.value ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: const Color(0xFFFFB300), size: 36,
                    ),
                  ),
                );
              }),
            )),
            const SizedBox(height: 12),
            TextField(
              controller: textCtrl,
              maxLines: 4,
              style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
              decoration: InputDecoration(
                hintText: 'Tulis ulasan kamu...',
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400], fontFamily: 'Poppins'),
                contentPadding: const EdgeInsets.all(12),
                filled: true, fillColor: const Color(0xFFF5F8FF),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5)),
              ),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: Get.back,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', color: Colors.black54, fontWeight: FontWeight.w600)),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                onPressed: () { Get.back(); ctrl.editReview(review['id'], ratingEdit.value, textCtrl.text); },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0), elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Simpan', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w600)),
              )),
            ]),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

void showConfirmDeleteReview(ReviewController ctrl, int reviewId) {
  Get.dialog(AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    title: const Text('Hapus Ulasan?',
        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 15)),
    content: const Text('Ulasan kamu akan dihapus permanen.',
        style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
    actions: [
      TextButton(onPressed: Get.back,
          child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey))),
      TextButton(
        onPressed: () { Get.back(); ctrl.deleteReview(reviewId); },
        child: const Text('Hapus',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.red, fontWeight: FontWeight.w700)),
      ),
    ],
  ));
}

void showReportSheet(String title, {required Function(String, String) onSend}) {
  final reasons = ['spam', 'kasar', 'tidak_relevan', 'lainnya'];
  final labels = ['Spam', 'Kasar/Tidak sopan', 'Tidak relevan', 'Lainnya'];
  final selected = reasons[0].obs;
  final descCtrl = TextEditingController();
  Get.dialog(AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 15)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() => Column(
          children: List.generate(reasons.length, (i) => RadioListTile<String>(
            dense: true, contentPadding: EdgeInsets.zero,
            title: Text(labels[i], style: const TextStyle(fontSize: 13, fontFamily: 'Poppins')),
            value: reasons[i], groupValue: selected.value,
            onChanged: (v) => selected.value = v!,
            activeColor: const Color(0xFF1565C0),
          )),
        )),
        const SizedBox(height: 8),
        TextField(
          controller: descCtrl, maxLines: 2,
          style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
          decoration: InputDecoration(
            hintText: 'Keterangan tambahan (opsional)',
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400], fontFamily: 'Poppins'),
            contentPadding: const EdgeInsets.all(10), isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(onPressed: Get.back,
          child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', color: Colors.grey))),
      ElevatedButton(
        onPressed: () { Get.back(); onSend(selected.value, descCtrl.text); },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: const Text('Kirim Laporan',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    ],
  ));
}
