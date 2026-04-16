import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/author_detail_controller.dart';

class AuthorSocial extends StatelessWidget {
  final AuthorDetailController ctrl;
  const AuthorSocial({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final author = ctrl.author.value!;
    final socials = <Widget>[];

    if (author.website != null && author.website!.isNotEmpty) {
      socials.add(_buildSocialButton(
        icon: Icons.language,
        label: 'Website',
        url: author.website!,
        color: const Color(0xFF1565C0),
      ));
    }

    if (author.socialMedia != null) {
      final sm = author.socialMedia!;
      if (sm['twitter'] != null && sm['twitter'].toString().isNotEmpty) {
        socials.add(_buildSocialButton(
          icon: Icons.alternate_email,
          label: 'Twitter',
          url: 'https://twitter.com/${sm['twitter']}',
          color: const Color(0xFF1DA1F2),
        ));
      }
      if (sm['instagram'] != null && sm['instagram'].toString().isNotEmpty) {
        socials.add(_buildSocialButton(
          icon: Icons.camera_alt,
          label: 'Instagram',
          url: 'https://instagram.com/${sm['instagram']}',
          color: const Color(0xFFE4405F),
        ));
      }
      if (sm['facebook'] != null && sm['facebook'].toString().isNotEmpty) {
        socials.add(_buildSocialButton(
          icon: Icons.facebook,
          label: 'Facebook',
          url: 'https://facebook.com/${sm['facebook']}',
          color: const Color(0xFF1877F2),
        ));
      }
    }

    if (socials.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.share, color: Color(0xFF1565C0), size: 20),
              SizedBox(width: 8),
              Text(
                'Connect',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: socials,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required String url,
    required Color color,
  }) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
