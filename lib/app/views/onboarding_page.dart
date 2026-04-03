import 'package:ei_books/app/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(OnboardingController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (ctrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)));
          }
          return Column(
            children: [
              _Header(ctrl: ctrl),
              Expanded(child: _StepContent(ctrl: ctrl)),
              _StepIndicator(ctrl: ctrl),
              _BottomBar(ctrl: ctrl),
            ],
          );
        }),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final OnboardingController ctrl;
  const _Header({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Obx(() => AnimatedOpacity(
            opacity: ctrl.currentStep.value > 0 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: ctrl.currentStep.value > 0 ? ctrl.prevStep : null,
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.black87),
              ),
            ),
          )),
          const Spacer(),
          Obx(() => ctrl.currentStep.value < 2
              ? TextButton(
                  onPressed: ctrl.skip,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black45,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: const Text('Lewati',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final OnboardingController ctrl;
  const _StepIndicator({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          final active = ctrl.currentStep.value == i;
          final done = ctrl.currentStep.value > i;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: active ? 28 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: done
                  ? const Color(0xFF1565C0).withOpacity(0.35)
                  : active
                      ? const Color(0xFF1565C0)
                      : Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    ));
  }
}

class _StepContent extends StatelessWidget {
  final OnboardingController ctrl;
  const _StepContent({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (ctrl.currentStep.value) {
        case 0: return _StepKategori(ctrl: ctrl);
        case 1: return _StepGenre(ctrl: ctrl);
        case 2: return _StepPengarang(ctrl: ctrl);
        default: return const SizedBox.shrink();
      }
    });
  }
}

class _StepKategori extends StatelessWidget {
  final OnboardingController ctrl;
  const _StepKategori({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('Kategori Favorit',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins', color: Colors.black87)),
          const SizedBox(height: 4),
          Obx(() {
            final count = ctrl.selectedCategories.length;
            return Text(
              count == 0 ? 'Pilih 3–5 kategori yang kamu suka' : '$count dipilih',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  color: count > 0 ? const Color(0xFF1565C0) : Colors.black45),
            );
          }),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() => SingleChildScrollView(
              child: Wrap(
                spacing: 10, runSpacing: 10,
                children: ctrl.categories.map((cat) {
                  final selected = ctrl.selectedCategories.contains(cat['slug']);
                  return GestureDetector(
                    onTap: () => ctrl.toggleCategory(cat['slug']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF1565C0) : const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: selected ? const Color(0xFF1565C0) : Colors.grey[300]!),
                      ),
                      child: Text(cat['name'],
                          style: TextStyle(
                              fontSize: 13, fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : Colors.black87)),
                    ),
                  );
                }).toList(),
              ),
            )),
          ),
        ],
      ),
    );
  }
}

class _StepGenre extends StatelessWidget {
  final OnboardingController ctrl;
  const _StepGenre({required this.ctrl});

  Color _parseColor(String hex) {
    try { return Color(int.parse(hex.replaceFirst('#', '0xFF'))); }
    catch (_) { return const Color(0xFF1565C0); }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('Genre Favorit',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins', color: Colors.black87)),
          const SizedBox(height: 4),
          Obx(() {
            final count = ctrl.selectedGenres.length;
            return Text(
              count == 0 ? 'Pilih 3–5 genre yang kamu suka' : '$count dipilih',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  color: count > 0 ? const Color(0xFF1565C0) : Colors.black45),
            );
          }),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() => SingleChildScrollView(
              child: Wrap(
                spacing: 10, runSpacing: 10,
                children: ctrl.genres.map((g) {
                  final selected = ctrl.selectedGenres.contains(g['slug']);
                  final color = _parseColor(g['color'] as String? ?? '#1565C0');
                  return GestureDetector(
                    onTap: () => ctrl.toggleGenre(g['slug']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: selected ? color : const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: selected ? color : Colors.grey[300]!),
                      ),
                      child: Text(g['name'],
                          style: TextStyle(
                              fontSize: 13, fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : Colors.black87)),
                    ),
                  );
                }).toList(),
              ),
            )),
          ),
        ],
      ),
    );
  }
}

class _StepPengarang extends StatelessWidget {
  final OnboardingController ctrl;
  const _StepPengarang({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('Pengarang Favorit',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins', color: Colors.black87)),
          const SizedBox(height: 4),
          Obx(() {
            final count = ctrl.selectedAuthors.length;
            return Text(
              count == 0 ? 'Pilih hingga 3 pengarang (opsional)' : '$count dipilih',
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  color: count > 0 ? const Color(0xFF1565C0) : Colors.black45),
            );
          }),
          const SizedBox(height: 14),
          TextField(
            onChanged: ctrl.searchAuthor,
            style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
            decoration: InputDecoration(
              hintText: 'Cari pengarang...',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400], fontFamily: 'Poppins'),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
              filled: true, fillColor: const Color(0xFFF5F7FA),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5)),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() => ListView.separated(
              itemCount: ctrl.filteredAuthors.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100]),
              itemBuilder: (_, i) {
                final author = ctrl.filteredAuthors[i];
                final selected = ctrl.selectedAuthors.contains(author);
                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: Text(author,
                      style: TextStyle(
                          fontSize: 13, fontFamily: 'Poppins',
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                          color: selected ? const Color(0xFF1565C0) : Colors.black87)),
                  trailing: selected
                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFF1565C0), size: 20)
                      : Icon(Icons.radio_button_unchecked, color: Colors.grey[300], size: 20),
                  onTap: () => ctrl.toggleAuthor(author),
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final OnboardingController ctrl;
  const _BottomBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: ctrl.isSaving.value
              ? null
              : () => ctrl.currentStep.value < 2 ? ctrl.nextStep() : ctrl.save(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            disabledBackgroundColor: const Color(0xFF1565C0).withOpacity(0.6),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: ctrl.isSaving.value
              ? const SizedBox(height: 20, width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
                  ctrl.currentStep.value < 2 ? 'Lanjut' : 'Selesai',
                  style: const TextStyle(fontSize: 15, fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700, color: Colors.white),
                ),
        ),
      ),
    ));
  }
}
