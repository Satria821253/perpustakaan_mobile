import 'package:flutter/material.dart';

class BpLanguagePanel extends StatelessWidget {
  final String lang;
  final ValueChanged<String> onLangChanged;
  final VoidCallback onClose;

  const BpLanguagePanel({
    super.key,
    required this.lang,
    required this.onLangChanged,
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
                    'Pilih Bahasa',
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
              _LangOption(
                label: 'Indonesia',
                selected: lang == 'id',
                onTap: () {
                  onLangChanged('id');
                  onClose();
                },
              ),
              const SizedBox(height: 8),
              _LangOption(
                label: 'English',
                selected: lang == 'en',
                onTap: () {
                  onLangChanged('en');
                  onClose();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LangOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEEF0FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? const Color(0xFF4361EE)
                : const Color(0xFFEEEEEE),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: selected
                    ? const Color(0xFF4361EE)
                    : const Color(0xFF1A1A2E),
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(Icons.check_rounded,
                  size: 18, color: Color(0xFF4361EE)),
          ],
        ),
      ),
    );
  }
}
