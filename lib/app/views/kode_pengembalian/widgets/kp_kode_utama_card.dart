import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/kode_pengembalian_controller.dart';

class KpKodeUtamaCard extends StatelessWidget {
  final KodePengembalianController ctrl;
  const KpKodeUtamaCard({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF1565C0).withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8)),
            child: const Text('KODE PENGEMBALIAN',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 16),
          Text(ctrl.kode,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3)),
          const SizedBox(height: 20),
          Obx(() => GestureDetector(
                onTap: ctrl.salinKode,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: ctrl.sudahDisalin.value
                        ? const Color(0xFF2E7D32)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        ctrl.sudahDisalin.value
                            ? Icons.check_rounded
                            : Icons.copy_rounded,
                        size: 16,
                        color: ctrl.sudahDisalin.value
                            ? Colors.white
                            : const Color(0xFF1565C0),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        ctrl.sudahDisalin.value ? 'Tersalin!' : 'Salin Kode',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: ctrl.sudahDisalin.value
                                ? Colors.white
                                : const Color(0xFF1565C0)),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
