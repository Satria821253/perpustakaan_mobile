import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

enum AnimationType {
  approved,
  denied,
  success,
  error,
  loading,
}

class AnimationOverlay extends StatefulWidget {
  final AnimationType type;
  final String? title;
  final String? message;
  final VoidCallback? onComplete;
  final Duration duration;

  const AnimationOverlay({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.onComplete,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimationOverlay> createState() => _AnimationOverlayState();

  /// Show animation overlay
  static void show({
    required AnimationType type,
    String? title,
    String? message,
    VoidCallback? onComplete,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.dialog(
      AnimationOverlay(
        type: type,
        title: title,
        message: message,
        onComplete: onComplete,
        duration: duration,
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
    );
  }

  /// Show approved animation
  static void showApproved({
    String? title,
    String? message,
    VoidCallback? onComplete,
  }) {
    show(
      type: AnimationType.approved,
      title: title ?? 'Disetujui!',
      message: message,
      onComplete: onComplete,
    );
  }

  /// Show denied animation
  static void showDenied({
    String? title,
    String? message,
    VoidCallback? onComplete,
  }) {
    show(
      type: AnimationType.denied,
      title: title ?? 'Ditolak',
      message: message,
      onComplete: onComplete,
    );
  }

  /// Show success animation
  static void showSuccess({
    String? title,
    String? message,
    VoidCallback? onComplete,
  }) {
    show(
      type: AnimationType.success,
      title: title ?? 'Berhasil!',
      message: message,
      onComplete: onComplete,
    );
  }

  /// Show error animation
  static void showError({
    String? title,
    String? message,
    VoidCallback? onComplete,
  }) {
    show(
      type: AnimationType.error,
      title: title ?? 'Gagal',
      message: message,
      onComplete: onComplete,
    );
  }
}

class _AnimationOverlayState extends State<AnimationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Auto close after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _closeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeOverlay() async {
    if (!mounted) return;
    
    await _controller.reverse();
    
    if (mounted && Get.isDialogOpen == true) {
      Get.back(); // Close dialog
      // Wait a bit before calling onComplete to ensure dialog is closed
      await Future.delayed(const Duration(milliseconds: 100));
      widget.onComplete?.call();
    }
  }

  String _getAnimationPath() {
    switch (widget.type) {
      case AnimationType.approved:
      case AnimationType.success:
        return 'assets/animations/approved.json';
      case AnimationType.denied:
      case AnimationType.error:
        return 'assets/animations/denied.json';
      case AnimationType.loading:
        return 'assets/animations/pendding.json';
    }
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case AnimationType.approved:
      case AnimationType.success:
        return const Color(0xFF4CAF50);
      case AnimationType.denied:
      case AnimationType.error:
        return const Color(0xFFE53935);
      case AnimationType.loading:
        return const Color(0xFF1565C0);
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case AnimationType.approved:
      case AnimationType.success:
        return Icons.check_circle;
      case AnimationType.denied:
      case AnimationType.error:
        return Icons.cancel;
      case AnimationType.loading:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animation or Icon
                  _buildAnimation(),
                  
                  const SizedBox(height: 20),
                  
                  // Title
                  if (widget.title != null)
                    Text(
                      widget.title!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getBackgroundColor(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  
                  // Message
                  if (widget.message != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.message!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    // Try to load Lottie animation, fallback to icon if not found
    return FutureBuilder(
      future: _checkAnimationExists(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return SizedBox(
            width: 150,
            height: 150,
            child: Lottie.asset(
              _getAnimationPath(),
              repeat: widget.type == AnimationType.loading, // Loop untuk loading/pending
              animate: true,
            ),
          );
        } else {
          // Fallback to icon
          return Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: _getBackgroundColor().withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(),
              size: 80,
              color: _getBackgroundColor(),
            ),
          );
        }
      },
    );
  }

  Future<bool> _checkAnimationExists() async {
    try {
      await DefaultAssetBundle.of(context).load(_getAnimationPath());
      return true;
    } catch (e) {
      return false;
    }
  }
}
