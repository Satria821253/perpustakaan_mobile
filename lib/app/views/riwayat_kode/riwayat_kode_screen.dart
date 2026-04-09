import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/code_history_controller.dart';
import 'widgets/reservation_code_card.dart';
import 'widgets/return_code_card.dart';

class RiwayatKodeScreen extends StatelessWidget {
  const RiwayatKodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(CodeHistoryController());

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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text('Riwayat Kode',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => _TabButton(
                    label: 'Kode Reservasi',
                    isSelected: ctrl.selectedTab.value == 'reservasi',
                    onTap: () => ctrl.changeTab('reservasi'),
                  )),
                ),
                Expanded(
                  child: Obx(() => _TabButton(
                    label: 'Kode Pengembalian',
                    isSelected: ctrl.selectedTab.value == 'pengembalian',
                    onTap: () => ctrl.changeTab('pengembalian'),
                  )),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (ctrl.selectedTab.value == 'reservasi') {
                return _ReservasiTab(ctrl: ctrl);
              } else {
                return _PengembalianTab(ctrl: ctrl);
              }
            }),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF1565C0) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1565C0) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}

class _ReservasiTab extends StatelessWidget {
  final CodeHistoryController ctrl;

  const _ReservasiTab({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoadingReservations.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (ctrl.reservationCodes.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_2, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'Belum ada kode reservasi',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: ctrl.refreshCurrentTab,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ctrl.reservationCodes.length,
          itemBuilder: (context, index) {
            final code = ctrl.reservationCodes[index];
            return ReservationCodeCard(code: code);
          },
        ),
      );
    });
  }
}

class _PengembalianTab extends StatelessWidget {
  final CodeHistoryController ctrl;

  const _PengembalianTab({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoadingReturns.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (ctrl.returnCodes.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_2, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'Belum ada kode pengembalian',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: ctrl.refreshCurrentTab,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ctrl.returnCodes.length,
          itemBuilder: (context, index) {
            final code = ctrl.returnCodes[index];
            return ReturnCodeCard(code: code);
          },
        ),
      );
    });
  }
}
