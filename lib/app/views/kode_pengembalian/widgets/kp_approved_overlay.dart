import 'package:flutter/material.dart';

class KpApprovedOverlay extends StatefulWidget {
  const KpApprovedOverlay({super.key});

  @override
  State<KpApprovedOverlay> createState() => _KpApprovedOverlayState();
}

class _KpApprovedOverlayState extends State<KpApprovedOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF2E7D32),
                size: 90,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
