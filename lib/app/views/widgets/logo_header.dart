import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/logo_foreground.png', width: 160),
        Transform.translate(
          offset: const Offset(0, -40),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
              ),
              children: [
                TextSpan(
                    text: 'Ei',
                    style: TextStyle(color: Color(0xFFE84B1A))),
                TextSpan(
                    text: '-',
                    style: TextStyle(color: Colors.black87)),
                TextSpan(
                    text: 'Book',
                    style: TextStyle(color: Color(0xFF1A3C8F))),
              ],
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -8),
          child: const Divider(color: Color(0xFFCCCCCC), thickness: 1),
        ),
      ],
    );
  }
}
