import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/perpanjang_controller.dart';
import 'widgets/ps_status_card.dart';
import 'widgets/ps_buku_card.dart';
import 'widgets/ps_info_card.dart';
import 'widgets/ps_steps_card.dart';
import 'widgets/ps_bottom_action.dart';

class PerpanjanganSubmissionScreen extends StatefulWidget {
  final int borrowingId;
  final String bookTitle;

  const PerpanjanganSubmissionScreen({
    super.key,
    required this.borrowingId,
    this.bookTitle = '',
  });

  @override
  State<PerpanjanganSubmissionScreen> createState() =>
      _PerpanjanganSubmissionScreenState();
}

class _PerpanjanganSubmissionScreenState
    extends State<PerpanjanganSubmissionScreen>
    with WidgetsBindingObserver {
  late PerpanjangController _controller;
  bool _isLoading = true;
  bool _hasPendingRequest = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  Future<void> _initController() async {
    if (Get.isRegistered<PerpanjangController>(
      tag: 'submission_${widget.borrowingId}',
    )) {
      _controller = Get.find<PerpanjangController>(
        tag: 'submission_${widget.borrowingId}',
      );
      await _controller.fetchDetail();
    } else {
      _controller = Get.put(
        PerpanjangController(borrowingId: widget.borrowingId),
        tag: 'submission_${widget.borrowingId}',
      );
      await _controller.fetchDetail();
    }

    _updatePendingStatus();
  }

  void _updatePendingStatus() {
    final riwayat = _controller.riwayat;
    if (riwayat.isEmpty) {
      _hasPendingRequest = true;
    } else {
      final latestRequest = riwayat.first;
      _hasPendingRequest = latestRequest.status == 'pending';
    }
    if (mounted) setState(() {});
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await _controller.fetchDetail();
    _updatePendingStatus();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Permintaan Perpanjangan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          const PsStatusCard(),
                          const SizedBox(height: 16),
                          Obx(() {
                            final detail = _controller.detail.value;
                            if (detail != null) {
                              return PsBukuCard(detail: detail);
                            }
                            return _buildSimpleBookCard();
                          }),
                          const SizedBox(height: 16),
                          const PsInfoCard(),
                          const SizedBox(height: 16),
                          const PsStepsCard(),
                        ],
                      ),
                    ),
                  ),
          ),
          PsBottomAction(
            borrowingId: widget.borrowingId,
            hasPendingRequest: _hasPendingRequest,
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleBookCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 16,
                    color: Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Buku yang Diperpanjang',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Color(0xFF1A1D23),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 62,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.book_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bookTitle.isNotEmpty
                            ? widget.bookTitle
                            : 'Judul Buku',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: Color(0xFF1A1D23),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFFFCC02).withOpacity(0.5),
                          ),
                        ),
                        child: const Text(
                          'Perpanjangan Diajukan',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Color(0xFFF57C00),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
