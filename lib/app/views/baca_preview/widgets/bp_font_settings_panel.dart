import 'package:flutter/material.dart';

class BpFontSettingsPanel extends StatelessWidget {
  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;
  final VoidCallback onClose;

  const BpFontSettingsPanel({
    super.key,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 12,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ukuran Teks',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1A1A2E),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: const Icon(Icons.close,
                        size: 18, color: Color(0xFF888888)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('A',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888888),
                          fontFamily: 'Poppins')),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 6),
                        activeTrackColor: const Color(0xFF4361EE),
                        inactiveTrackColor: const Color(0xFFDDE1F0),
                        thumbColor: const Color(0xFF4361EE),
                      ),
                      child: Slider(
                        value: fontSize,
                        min: 12,
                        max: 22,
                        onChanged: onFontSizeChanged,
                      ),
                    ),
                  ),
                  const Text('A',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF333333),
                          fontFamily: 'Poppins')),
                ],
              ),
              Center(
                child: Text(
                  '${fontSize.round()} pt',
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                      fontFamily: 'Poppins'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
