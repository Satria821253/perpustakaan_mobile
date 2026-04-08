import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/kode_pengembalian_controller.dart';

class KpSuksesHeader extends StatelessWidget {
  final KodePengembalianController ctrl;
  const KpSuksesHeader({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ctrl.sudahDikonfirmasi.value
        ? const _AnimatedCeklis()
        : Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFFE3F2FD)),
                child: const Icon(Icons.qr_code_rounded,
                    color: Color(0xFF1565C0), size: 40),
              ),
              const SizedBox(height: 12),
              const Text('Tunjukkan Kode ke Petugas',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87)),
              const SizedBox(height: 4),
              Text(
                'Petugas akan memproses pengembalian buku Anda',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ));
  }
}

class _AnimatedCeklis extends StatefulWidget {
  const _AnimatedCeklis();

  @override
  State<_AnimatedCeklis> createState() => _AnimatedCeklisState();
}

class _AnimatedCeklisState extends State<_AnimatedCeklis>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0xFFE8F5E9)),
            child: const Icon(Icons.check_circle_rounded,
                color: Color(0xFF2E7D32), size: 42),
          ),
          const SizedBox(height: 12),
          const Text('Pengembalian Dikonfirmasi!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E7D32))),
          const SizedBox(height: 4),
          Text(
            'Buku berhasil dikembalikan',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
