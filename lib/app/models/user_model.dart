import 'package:ei_books/app/core/app_config.dart';

class UserModel {
  final int id;
  final String email;
  final String nama;
  final String noTelepon;
  final String nomorAnggota;
  final String photoProfile;
  final String role;
  final String status;
  final String tanggalDaftar;
  final int koin;

  UserModel({
    required this.id,
    required this.email,
    required this.nama,
    required this.noTelepon,
    required this.nomorAnggota,
    required this.photoProfile,
    required this.role,
    required this.status,
    required this.tanggalDaftar,
    required this.koin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final raw = json['photo_profile'] as String? ?? '';
    final photo = raw.isNotEmpty && !raw.startsWith('http')
        ? '${AppConfig.baseUrl}$raw'
        : raw;
    return UserModel(
      id: json['id'],
      email: json['email'],
      nama: json['nama'],
      noTelepon: json['no_telepon'] ?? '',
      nomorAnggota: json['nomor_anggota'] ?? '',
      photoProfile: photo,
      role: json['role'] ?? '',
      status: json['status'] ?? 'aktif',
      tanggalDaftar: json['tanggal_daftar'] ?? '',
      koin: json['koin'] ?? 0,
    );
  }
}
