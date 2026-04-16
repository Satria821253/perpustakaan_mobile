import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../models/book_model.dart';
import '../../routes/app_pages.dart';

Color _parseColor(String hex) {
  try {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  } catch (_) {
    return const Color(0xFF1565C0);
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _ctrl = Get.find<HomeController>();
  final _textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textCtrl.text = _ctrl.searchQuery.value;
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    // temp selection
    final tempKategori = Rx<Map<String, dynamic>?>(
      _ctrl.selectedKategori.value,
    );
    final tempGenre = Rx<Map<String, dynamic>?>(_ctrl.selectedGenre.value);

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Filter Buku',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    tempKategori(null);
                    tempGenre(null);
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Kategori',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _ctrl.categories.map((cat) {
                  final selected = tempKategori.value?['id'] == cat['id'];
                  return GestureDetector(
                    onTap: () => tempKategori(selected ? null : cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF1565C0)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF1565C0)
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        cat['name'],
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: selected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Genre',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _ctrl.genres.map((g) {
                  final selected = tempGenre.value?['id'] == g['id'];
                  final color = _parseColor(g['color'] as String? ?? '#1565C0');
                  return GestureDetector(
                    onTap: () => tempGenre(selected ? null : g),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? color : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? color : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        g['name'],
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: selected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  _ctrl.applyFilter(
                    kategori: tempKategori.value,
                    genre: tempGenre.value,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Terapkan Filter',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF1565C0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: TextField(
          controller: _textCtrl,
          autofocus: true,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Cari judul, author...',
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
            border: InputBorder.none,
          ),
          onChanged: (val) => _ctrl.searchBooks(val),
          onSubmitted: (val) => _ctrl.searchBooks(val),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: _textCtrl,
            builder: (context, val, child) => val.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _textCtrl.clear();
                      _ctrl.searchBooks('');
                    },
                  )
                : const SizedBox.shrink(),
          ),
          Obx(() {
            final hasFilter =
                _ctrl.selectedKategori.value != null ||
                _ctrl.selectedGenre.value != null;
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: _showFilterSheet,
                ),
                if (hasFilter)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD600),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // Active filter chips
          Obx(() {
            final kat = _ctrl.selectedKategori.value;
            final gen = _ctrl.selectedGenre.value;
            if (kat == null && gen == null) return const SizedBox.shrink();
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  const Text(
                    'Filter: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  if (kat != null)
                    _activeChip(
                      kat['name'],
                      () => _ctrl.applyFilter(genre: gen),
                    ),
                  if (kat != null && gen != null) const SizedBox(width: 6),
                  if (gen != null)
                    _activeChip(
                      gen['name'],
                      () => _ctrl.applyFilter(kategori: kat),
                    ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _ctrl.clearFilter,
                    child: const Text(
                      'Hapus semua',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF1565C0),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              if (_ctrl.isLoadingSearch.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1565C0)),
                );
              }
              final hasFilter =
                  _ctrl.selectedKategori.value != null ||
                  _ctrl.selectedGenre.value != null;
              if (_ctrl.searchQuery.value.isEmpty && !hasFilter) {
                return _buildDefaultContent();
              }
              if (_ctrl.searchResults.isEmpty) {
                return _buildEmptyState(
                  Icons.search_off,
                  'Buku tidak ditemukan',
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _ctrl.searchResults.length,
                separatorBuilder: (context, value) =>
                    const SizedBox(height: 10),
                itemBuilder: (_, i) =>
                    _BookResultItem(book: _ctrl.searchResults[i]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _activeChip(String label, VoidCallback onRemove) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE3F2FD),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF1565C0),
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onRemove,
          child: const Icon(Icons.close, size: 12, color: Color(0xFF1565C0)),
        ),
      ],
    ),
  );

  Widget _buildDefaultContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Buku Populer',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (_ctrl.isLoadingPopuler.value) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1565C0)),
              );
            }
            if (_ctrl.bukuPopuler.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              children: _ctrl.bukuPopuler
                  .take(10)
                  .map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _BookResultItem(book: b),
                    ),
                  )
                  .toList(),
            );
          }),
          const SizedBox(height: 8),
          const Text(
            'Buku Terbaru',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (_ctrl.isLoadingTerbaru.value) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1565C0)),
              );
            }
            if (_ctrl.bukuTerbaru.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              children: _ctrl.bukuTerbaru
                  .take(10)
                  .map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _BookResultItem(book: b),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[500],
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BookResultItem extends StatelessWidget {
  final BookModel book;
  const _BookResultItem({required this.book});

  @override
  Widget build(BuildContext context) {
    final tersedia = book.status == 'tersedia';
    final isPopuler =
        book.totalDipinjam > 0 && book.rating >= 4.0 && book.totalRating >= 3;
    final homeCtrl = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;
    final categories = homeCtrl?.categories ?? [];
    final genres = homeCtrl?.genres ?? [];
    final catData = categories.firstWhereOrNull(
      (c) => c['name'] == book.kategori,
    );
    final catColor = catData != null
        ? _parseColor(catData['color'] ?? '#1565C0')
        : const Color(0xFF1565C0);
    final genreNames = book.genre
        .split(',')
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty)
        .toList();
    final genreDataList = genreNames
        .map(
          (name) => genres.firstWhereOrNull(
            (g) => (g['name'] as String).toLowerCase() == name.toLowerCase(),
          ),
        )
        .whereType<Map<String, dynamic>>()
        .toList();
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.detail, arguments: book.id),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 80,
                height: 110,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    book.coverImage != null && book.coverImage!.isNotEmpty
                        ? Image.network(
                            book.coverImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) =>
                                _placeholder(),
                          )
                        : _placeholder(),
                    if (isPopuler)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6F00),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                color: Colors.white,
                                size: 9,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Populer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          book.judul,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: tersedia
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tersedia ? 'Tersedia' : 'Dipinjam',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: tersedia
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFD32F2F),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    book.pengarang,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (book.kategori.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: catColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        book.kategori,
                        style: TextStyle(
                          fontSize: 9,
                          color: catColor,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  if (genreDataList.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: genreDataList.map((g) {
                        final color = _parseColor(g['color'] ?? '#1565C0');
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: color.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            g['name'],
                            style: TextStyle(
                              fontSize: 9,
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB300),
                        size: 13,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${book.rating.toStringAsFixed(1)} (${book.totalRating})',
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 1,
                        height: 12,
                        color: Colors.grey[300],
                      ),
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Stok: ${book.stok}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: Colors.grey[200],
    child: const Center(
      child: Icon(Icons.menu_book, color: Colors.black26, size: 32),
    ),
  );
}
