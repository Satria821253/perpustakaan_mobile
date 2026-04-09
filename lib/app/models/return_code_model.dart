import 'package:flutter/material.dart';

class ReturnCodeModel {
  final int id;
  final String code;
  final int borrowingId;
  final String bookJudul;
  final String? coverImage;
  final String? pengarang;
  final String status;
  final String actualStatus;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime? usedAt;

  ReturnCodeModel({
    required this.id,
    required this.code,
    required this.borrowingId,
    required this.bookJudul,
    this.coverImage,
    this.pengarang,
    required this.status,
    required this.actualStatus,
    required this.expiresAt,
    required this.createdAt,
    this.usedAt,
  });

  factory ReturnCodeModel.fromJson(Map<String, dynamic> json) {
    return ReturnCodeModel(
      id: json['id'],
      code: json['code'],
      borrowingId: json['borrowing_id'],
      bookJudul: json['book_judul'],
      coverImage: json['cover_image'],
      pengarang: json['pengarang'],
      status: json['status'],
      actualStatus: json['actual_status'] ?? json['status'],
      expiresAt: DateTime.parse(json['expires_at']),
      createdAt: DateTime.parse(json['created_at']),
      usedAt: json['used_at'] != null ? DateTime.parse(json['used_at']) : null,
    );
  }

  bool get isActive => actualStatus == 'active' && DateTime.now().isBefore(expiresAt);
  bool get isUsed => actualStatus == 'used';
  bool get isExpired => actualStatus == 'expired' || DateTime.now().isAfter(expiresAt);

  String get statusLabel {
    if (isActive) return 'Aktif';
    if (isUsed) return 'Sudah Digunakan';
    if (isExpired) return 'Kadaluarsa';
    return status;
  }

  Color get statusColor {
    if (isActive) return Colors.green;
    if (isUsed) return Colors.blue;
    if (isExpired) return Colors.grey;
    return Colors.grey;
  }
}
