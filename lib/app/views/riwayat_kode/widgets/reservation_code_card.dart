import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/reservation_code_model.dart';
import '../../../core/app_config.dart';

class ReservationCodeCard extends StatelessWidget {
  final ReservationCodeModel code;

  const ReservationCodeCard({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showCodeDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        code.coverImage != null && code.coverImage!.isNotEmpty
                        ? Image.network(
                            '${AppConfig.baseUrl}${code.coverImage}',
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          code.bookJudul,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (code.author != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            code.author!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          'Qty: ${code.quantity} buku',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: code.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      code.statusLabel,
                      style: TextStyle(
                        color: code.statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.qr_code,
                          size: 24,
                          color: Color(0xFF1565C0),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          code.code,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontFamily: 'Courier',
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () => _copyCode(code.code),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Berlaku sampai: ${_formatDate(code.expiresAt)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              if (code.confirmedAt != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.check_circle, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Dikonfirmasi: ${_formatDate(code.confirmedAt!)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    Get.snackbar(
      'Berhasil',
      'Kode berhasil disalin',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _showCodeDetail(BuildContext context) {
    // Jika sudah confirmed, redirect ke detail peminjaman
    if (code.isConfirmed && code.borrowingId != null) {
      Get.toNamed('/detail-peminjaman', arguments: code.borrowingId);
    } else {
      // Jika masih active/pending, tampilkan kode reservasi
      Get.toNamed(
        '/kode-reservasi',
        arguments: {
          'kode': code.code,
          'judul': code.bookJudul,
          'author': code.author ?? '',
          'coverImage': code.coverImage,
          'expiresAt': code.expiresAt.toIso8601String(),
          'quantity': code.quantity,
          'sisaKuota': 0,
          'fromHistory': true, // Dari history
        },
      );
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 50,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.book, color: Colors.grey, size: 28),
    );
  }
}
