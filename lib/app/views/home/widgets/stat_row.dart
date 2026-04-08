import 'package:flutter/material.dart';

class StatRow extends StatelessWidget {
  const StatRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          _StatCard(value: '3', label: 'Dipinjam', bgColor: const Color.fromARGB(255, 209, 228, 255), valueColor: const Color.fromARGB(221, 37, 85, 218)),
          const SizedBox(width: 10),
          _StatCard(value: '1', label: 'Jatuh Tempo', bgColor: const Color(0xFFFFF8E1), valueColor: const Color(0xFFF57C00)),
          const SizedBox(width: 10),
          _StatCard(value: '12', label: 'Dikembalikan', bgColor: const Color(0xFFF1F8E9), valueColor: const Color(0xFF558B2F)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final Color bgColor, valueColor;
  const _StatCard({required this.value, required this.label, required this.bgColor, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: valueColor, fontFamily: 'Poppins')),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600], fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}
