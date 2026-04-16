import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/author_detail_controller.dart';
import 'widgets/author_app_bar.dart';
import 'widgets/author_header.dart';
import 'widgets/author_stats.dart';
import 'widgets/author_bio.dart';
import 'widgets/author_social.dart';
import 'widgets/author_books.dart';

class AuthorDetailPage extends StatefulWidget {
  final int authorId;
  const AuthorDetailPage({super.key, required this.authorId});

  @override
  State<AuthorDetailPage> createState() => _AuthorDetailPageState();
}

class _AuthorDetailPageState extends State<AuthorDetailPage> {
  late final AuthorDetailController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(
      AuthorDetailController(authorId: widget.authorId),
      tag: 'author_${widget.authorId}',
    );
  }

  @override
  void dispose() {
    Get.delete<AuthorDetailController>(tag: 'author_${widget.authorId}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1565C0)),
          );
        }
        if (ctrl.author.value == null) {
          return const Center(
            child: Text(
              'Author tidak ditemukan',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          );
        }
        return CustomScrollView(
          slivers: [
            AuthorAppBar(ctrl: ctrl),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  AuthorHeader(ctrl: ctrl),
                  AuthorStats(ctrl: ctrl),
                  AuthorBio(ctrl: ctrl),
                  AuthorSocial(ctrl: ctrl),
                  AuthorBooks(ctrl: ctrl),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
