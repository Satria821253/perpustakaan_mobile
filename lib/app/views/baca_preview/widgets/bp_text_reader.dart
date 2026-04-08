import 'package:flutter/material.dart';
import '../../../models/book_preview_model.dart';

class BpTextPage extends StatelessWidget {
  final PreviewPage page;
  final double fontSize;

  const BpTextPage({
    super.key,
    required this.page,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (page.chapterTitle.isNotEmpty && page.page == 1) ...[
            Text(
              page.chapterTitle,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Color(0xFF4361EE),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 6),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('— ', style: TextStyle(color: Color(0xFFBBBBBB))),
              Text('${page.page}',
                  style: const TextStyle(
                      color: Color(0xFFBBBBBB), fontSize: 13)),
              const Text(' —', style: TextStyle(color: Color(0xFFBBBBBB))),
            ],
          ),
          const SizedBox(height: 20),
          ...page.paragraphs.map((para) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _Para(text: para, fontSize: fontSize),
          )),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _Para extends StatelessWidget {
  final String text;
  final double fontSize;
  const _Para({required this.text, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Georgia',
        fontSize: fontSize,
        height: 1.75,
        color: const Color(0xFF333333),
        letterSpacing: 0.2,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
