import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/review_controller.dart';
import 'review_dialogs.dart';

class DetailUlasanTab extends StatelessWidget {
  final int bookId;
  const DetailUlasanTab({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ReviewController(bookId: bookId), tag: 'review_$bookId');

    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator(color: Color(0xFF1565C0))),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatsSection(ctrl: ctrl),
          const SizedBox(height: 16),
          _TulisUlasanSection(ctrl: ctrl),
          const SizedBox(height: 16),
          if (ctrl.reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('Belum ada ulasan',
                    style: TextStyle(color: Colors.black38, fontFamily: 'Poppins')),
              ),
            )
          else
            ...ctrl.reviews.map((r) => _ReviewItem(data: r, ctrl: ctrl)),
        ],
      );
    });
  }
}

class _StatsSection extends StatelessWidget {
  final ReviewController ctrl;
  const _StatsSection({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(ctrl.averageRating.value.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w800,
                      color: Color(0xFF1565C0), fontFamily: 'Poppins')),
              _StarRow(rating: ctrl.averageRating.value, size: 14),
              const SizedBox(height: 4),
              Text('${ctrl.totalReviews.value} ulasan',
                  style: const TextStyle(fontSize: 11, color: Colors.black45, fontFamily: 'Poppins')),
            ],
          ),
          const SizedBox(width: 16),
          const VerticalDivider(width: 1),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = ctrl.distribution['$star'] ?? 0;
                final total = ctrl.totalReviews.value;
                final pct = total > 0 ? count / total : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text('$star', style: const TextStyle(fontSize: 11, fontFamily: 'Poppins')),
                      const SizedBox(width: 4),
                      const Icon(Icons.star_rounded, size: 11, color: Color(0xFFFFB300)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 6,
                            backgroundColor: Colors.grey[200],
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 20,
                        child: Text('$count',
                            style: const TextStyle(fontSize: 10, color: Colors.black45, fontFamily: 'Poppins')),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TulisUlasanSection extends StatefulWidget {
  final ReviewController ctrl;
  const _TulisUlasanSection({required this.ctrl});

  @override
  State<_TulisUlasanSection> createState() => _TulisUlasanSectionState();
}

class _TulisUlasanSectionState extends State<_TulisUlasanSection> {
  final _key = GlobalKey();
  late final TextEditingController _textCtrl;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(text: widget.ctrl.reviewText.value);
    ever(widget.ctrl.reviewText, (val) {
      if (_textCtrl.text != val) _textCtrl.text = val;
    });
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _scrollToForm() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_key.currentContext != null) {
        Scrollable.ensureVisible(_key.currentContext!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            alignment: 0.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.ctrl;
    return Container(
      key: _key,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tulis Ulasan',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins', color: Colors.black87)),
          const SizedBox(height: 10),
          Obx(() => Row(
            children: List.generate(5, (i) {
              final star = i + 1;
              return GestureDetector(
                onTap: () => ctrl.selectedRating(star),
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    star <= ctrl.selectedRating.value
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: const Color(0xFFFFB300),
                    size: 30,
                  ),
                ),
              );
            }),
          )),
          const SizedBox(height: 10),
          TextField(
            controller: _textCtrl,
            onTap: _scrollToForm,
            onChanged: (v) => ctrl.reviewText(v),
            maxLines: 3,
            style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
            decoration: InputDecoration(
              hintText: 'Tulis ulasan kamu... (opsional)',
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400], fontFamily: 'Poppins'),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ctrl.isSubmitting.value ? null : ctrl.submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: ctrl.isSubmitting.value
                  ? const SizedBox(
                      height: 16, width: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Kirim Ulasan',
                      style: TextStyle(fontSize: 13, fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          )),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final ReviewController ctrl;
  const _ReviewItem({required this.data, required this.ctrl});

  void _showOwnerSheet(BuildContext context) {
    final reviewId = data['id'] as int;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 36, height: 4, margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            ListTile(
              leading: const Icon(Icons.reply_rounded, color: Color(0xFF1565C0)),
              title: const Text('Balas Ulasan',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
              onTap: () { Get.back(); ctrl.toggleReplies(reviewId); },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: Color(0xFF1565C0)),
              title: const Text('Edit Ulasan',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
              onTap: () { Get.back(); showEditReviewSheet(ctrl, data); },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text('Hapus Ulasan',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.redAccent)),
              onTap: () { Get.back(); showConfirmDeleteReview(ctrl, data['id']); },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showOtherSheet(BuildContext context, int reviewId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 36, height: 4, margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            ListTile(
              leading: const Icon(Icons.reply_rounded, color: Color(0xFF1565C0)),
              title: const Text('Balas Ulasan',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
              onTap: () { Get.back(); ctrl.toggleReplies(reviewId); },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.redAccent),
              title: const Text('Laporkan Ulasan',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.redAccent)),
              onTap: () { Get.back(); showReportSheet('Laporkan Ulasan', onSend: (r, d) => ctrl.reportReview(reviewId, r, d)); },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewId = data['id'] as int;
    final rating = (data['rating'] as num?)?.toInt() ?? 0;
    final nama = data['nama'] ?? 'Anonim';
    final review = data['review'] ?? '';
    final photo = data['photo_profile'] as String?;
    final date = _formatDate(data['created_at'] ?? '');
    final isOwner = ctrl.myUserId != null &&
        data['user_id'].toString() == ctrl.myUserId.toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: isOwner ? () => _showOwnerSheet(context) : null,
            onTap: isOwner
                ? () => ctrl.toggleReplies(reviewId)
                : () => _showOtherSheet(context, reviewId),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFE3F2FD),
                  backgroundImage: (photo != null && photo.isNotEmpty) ? NetworkImage(photo) : null,
                  child: (photo == null || photo.isEmpty)
                      ? Text(nama.isNotEmpty ? nama[0].toUpperCase() : '?',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                              color: Color(0xFF1565C0), fontFamily: 'Poppins'))
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(nama,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins')),
                          const Spacer(),
                          Text(date,
                              style: const TextStyle(fontSize: 10, color: Colors.black38,
                                  fontFamily: 'Poppins')),
                        ],
                      ),
                      const SizedBox(height: 3),
                      _StarRow(rating: rating.toDouble(), size: 12),
                      if (review.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(review,
                            style: const TextStyle(fontSize: 12, color: Colors.black54,
                                fontFamily: 'Poppins', height: 1.5)),
                      ],
                      const SizedBox(height: 6),
                      Obx(() {
                        final isOpen = ctrl.expandedReplies[reviewId] ?? false;
                        final replies = ctrl.repliesMap[reviewId] ?? [];
                        return GestureDetector(
                          onTap: () => ctrl.toggleReplies(reviewId),
                          child: Text(
                            isOpen
                                ? 'Sembunyikan balasan'
                                : replies.isEmpty
                                    ? 'Balas'
                                    : 'Lihat ${replies.length} balasan',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF1565C0),
                                fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            final isOpen = ctrl.expandedReplies[reviewId] ?? false;
            if (!isOpen) return const SizedBox.shrink();
            final isLoadingR = ctrl.loadingReplies[reviewId] ?? false;
            final replies = List<Map<String, dynamic>>.from(ctrl.repliesMap[reviewId] ?? []);
            return Padding(
              padding: const EdgeInsets.only(left: 46, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLoadingR)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(height: 16, width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1565C0))),
                    )
                  else
                    ...replies.map((r) => _ReplyItem(data: r, reviewId: reviewId, ctrl: ctrl)),
                  _ReplyInput(reviewId: reviewId, ctrl: ctrl),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Baru saja';
      if (diff.inHours < 1) return '${diff.inMinutes} mnt lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      if (diff.inDays < 2) return 'Kemarin';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) { return ''; }
  }
}

class _ReplyItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final int reviewId;
  final ReviewController ctrl;
  const _ReplyItem({required this.data, required this.reviewId, required this.ctrl});

  void _showSheet(BuildContext context, int replyId, String nama, String reply, bool isOwner) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 36, height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 4),
              // Preview bubble
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                  border: const Border(left: BorderSide(color: Color(0xFF1565C0), width: 3)),
                ),
                child: Row(
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nama, style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700,
                            color: Color(0xFF1565C0), fontFamily: 'Poppins')),
                        const SizedBox(height: 2),
                        Text(
                          reply.length > 60 ? '${reply.substring(0, 60)}...' : reply,
                          style: const TextStyle(fontSize: 12, color: Colors.black54, fontFamily: 'Poppins'),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              // Aksi
              _SheetTile(
                icon: Icons.reply_rounded,
                color: const Color(0xFF1565C0),
                label: 'Balas',
                onTap: () { Get.back(); ctrl.setReplyingTo(reviewId, nama, reply); },
              ),
              if (isOwner) ...[
                _SheetTile(
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF1565C0),
                  label: 'Edit Balasan',
                  onTap: () { Get.back(); _showEditSheet(context, replyId, reply); },
                ),
                _SheetTile(
                  icon: Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  label: 'Hapus Balasan',
                  labelColor: Colors.redAccent,
                  onTap: () { Get.back(); ctrl.deleteReplyAction(reviewId, replyId); },
                ),
              ] else
                _SheetTile(
                  icon: Icons.flag_outlined,
                  color: Colors.redAccent,
                  label: 'Laporkan Balasan',
                  labelColor: Colors.redAccent,
                  onTap: () { Get.back(); showReportSheet('Laporkan Balasan', onSend: (r, d) => ctrl.reportReview(replyId, r, d)); },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, int replyId, String current) {
    final textCtrl = TextEditingController(text: current);
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
              const SizedBox(height: 14),
              const Text('Edit Balasan', style: TextStyle(
                  fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 12),
              TextField(
                controller: textCtrl,
                maxLines: 4,
                autofocus: true,
                style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                decoration: InputDecoration(
                  hintText: 'Tulis balasan...',
                  filled: true, fillColor: const Color(0xFFF5F8FF),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5)),
                ),
              ),
              const SizedBox(height: 12),
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
                  onPressed: () { Get.back(); ctrl.editReplyAction(reviewId, replyId, textCtrl.text); },
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

  @override
  Widget build(BuildContext context) {
    final replyId = data['id'] as int;
    final nama = data['nama'] ?? 'Anonim';
    final reply = data['reply'] ?? '';
    final photo = data['photo_profile'] as String?;
    final date = _formatDate(data['created_at'] ?? '');
    final isOwner = ctrl.myUserId != null &&
        data['user_id'].toString() == ctrl.myUserId.toString();

    final avatar = CircleAvatar(
      radius: 14,
      backgroundColor: const Color(0xFFE3F2FD),
      backgroundImage: (photo != null && photo.isNotEmpty) ? NetworkImage(photo) : null,
      child: (photo == null || photo.isEmpty)
          ? Text(nama.isNotEmpty ? nama[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                  color: Color(0xFF1565C0), fontFamily: 'Poppins'))
          : null,
    );

    final bubble = _buildBubble(context, isOwner, nama, reply, date);

    return GestureDetector(
      onLongPress: () => _showSheet(context, replyId, nama, reply, isOwner),
      onTap: () => ctrl.setReplyingTo(reviewId, nama, reply),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: isOwner ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: isOwner
              ? [bubble, const SizedBox(width: 6), avatar]
              : [avatar, const SizedBox(width: 6), bubble],
        ),
      ),
    );
  }

  Widget _buildBubble(BuildContext context, bool isOwner, String nama, String reply, String date) {
    String? quotedNama;
    String? quotedText;
    String actualReply = reply;

    final newlineIdx = reply.indexOf('\n');
    if (newlineIdx != -1 && reply.startsWith('@')) {
      final firstLine = reply.substring(0, newlineIdx);
      final colonIdx = firstLine.indexOf(': ');
      if (colonIdx != -1) {
        quotedNama = firstLine.substring(1, colonIdx);
        quotedText = firstLine.substring(colonIdx + 2);
        actualReply = reply.substring(newlineIdx + 1);
      }
    }

    final bubbleColor = isOwner ? const Color(0xFF1565C0) : const Color(0xFFF0F0F0);
    final textColor = isOwner ? Colors.white : Colors.black87;
    final timeColor = isOwner ? Colors.white60 : Colors.black38;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      child: Container(
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isOwner ? 12 : 2),
            bottomRight: Radius.circular(isOwner ? 2 : 12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (quotedNama != null)
              Container(
                margin: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isOwner
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(
                      color: isOwner ? Colors.white70 : const Color(0xFF1565C0),
                      width: 3,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(quotedNama,
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: isOwner ? Colors.white : const Color(0xFF1565C0))),
                    const SizedBox(height: 2),
                    Text(
                      quotedText!.length > 80 ? '${quotedText.substring(0, 80)}...' : quotedText,
                      style: TextStyle(
                          fontSize: 11, fontFamily: 'Poppins',
                          color: isOwner ? Colors.white70 : Colors.black54),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
              child: Column(
                crossAxisAlignment: isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isOwner) ...[
                    Text(nama,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                            color: Color(0xFF1565C0), fontFamily: 'Poppins')),
                    const SizedBox(height: 2),
                  ],
                  Text(actualReply,
                      style: TextStyle(fontSize: 12, fontFamily: 'Poppins',
                          height: 1.4, color: textColor)),
                  const SizedBox(height: 3),
                  Text(date,
                      style: TextStyle(fontSize: 10, fontFamily: 'Poppins', color: timeColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Baru saja';
      if (diff.inHours < 1) return '${diff.inMinutes} mnt lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      if (diff.inDays < 2) return 'Kemarin';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) { return ''; }
  }
}

class _SheetTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final Color? labelColor;
  final VoidCallback onTap;
  const _SheetTile({required this.icon, required this.color, required this.label, required this.onTap, this.labelColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label, style: TextStyle(
          fontFamily: 'Poppins', fontSize: 14,
          color: labelColor ?? Colors.black87, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}

class _ReplyInput extends StatefulWidget {
  final int reviewId;
  final ReviewController ctrl;
  const _ReplyInput({required this.reviewId, required this.ctrl});

  @override
  State<_ReplyInput> createState() => _ReplyInputState();
}

class _ReplyInputState extends State<_ReplyInput> {
  final _ctrl = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() { _ctrl.dispose(); _focusNode.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final target = widget.ctrl.replyingTo[widget.reviewId];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (target != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(10),
                border: const Border(
                  left: BorderSide(color: Color(0xFF1565C0), width: 3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Membalas ${target['nama']}',
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700,
                                color: Color(0xFF1565C0), fontFamily: 'Poppins')),
                        const SizedBox(height: 2),
                        Text(
                          target['reply']!.length > 60
                              ? '${target['reply']!.substring(0, 60)}...'
                              : target['reply']!,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black54, fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.ctrl.cancelReplyingTo(widget.reviewId);
                      _focusNode.unfocus();
                    },
                    child: const Icon(Icons.close, size: 16, color: Colors.black38),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  focusNode: _focusNode,
                  style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: target != null
                        ? 'Balas ${target['nama']}...'
                        : 'Balas komentar...',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400], fontFamily: 'Poppins'),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  final text = _ctrl.text.trim();
                  if (text.isEmpty) return;
                  _ctrl.clear();
                  _focusNode.unfocus();
                  await widget.ctrl.submitReply(widget.reviewId, text);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1565C0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _StarRow extends StatelessWidget {
  final double rating;
  final double size;
  const _StarRow({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) => Icon(
        i < rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
        color: const Color(0xFFFFB300),
        size: size,
      )),
    );
  }
}
