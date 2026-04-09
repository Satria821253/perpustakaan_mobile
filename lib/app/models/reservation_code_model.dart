import 'package:flutter/material.dart';

class ReservationCodeModel {
  final int id;
  final String code;
  final int bookId;
  final String bookJudul;
  final String? coverImage;
  final String? pengarang;
  final int quantity;
  final String status;
  final String? borrowingStatus; // Status peminjaman: dipinjam, dikembalikan, dll
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final int? borrowingId;

  ReservationCodeModel({
    required this.id,
    required this.code,
    required this.bookId,
    required this.bookJudul,
    this.coverImage,
    this.pengarang,
    required this.quantity,
    required this.status,
    this.borrowingStatus,
    required this.expiresAt,
    required this.createdAt,
    this.confirmedAt,
    this.borrowingId,
  });

  factory ReservationCodeModel.fromJson(Map<String, dynamic> json) {
    return ReservationCodeModel(
      id: json['id'],
      code: json['code'],
      bookId: json['book_id'],
      bookJudul: json['book_judul'],
      coverImage: json['cover_image'],
      pengarang: json['pengarang'],
      quantity: json['quantity'] ?? 1,
      status: json['status'],
      borrowingStatus: json['borrowing_status'],
      expiresAt: DateTime.parse(json['expires_at']),
      createdAt: DateTime.parse(json['created_at']),
      confirmedAt: json['confirmed_at'] != null ? DateTime.parse(json['confirmed_at']) : null,
      borrowingId: json['borrowing_id'],
    );
  }

  bool get isActive => status == 'active' && DateTime.now().isBefore(expiresAt);
  bool get isExpired => status == 'expired' || DateTime.now().isAfter(expiresAt);
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isReturned => borrowingStatus == 'dikembalikan' || borrowingStatus == 'returned';

  String get statusLabel {
    if (isReturned) return 'Selesai';
    if (isActive) return 'Aktif';
    if (isConfirmed) return 'Dikonfirmasi';
    if (isExpired) return 'Kadaluarsa';
    if (isCancelled) return 'Dibatalkan';
    return status;
  }

  Color get statusColor {
    if (isReturned) return Colors.grey;
    if (isActive) return Colors.green;
    if (isConfirmed) return Colors.blue;
    if (isExpired) return Colors.grey;
    if (isCancelled) return Colors.red;
    return Colors.grey;
  }
}
