import '../core/app_config.dart';

class Author {
  final int id;
  final String nama;
  final String slug;
  final String? photo;
  final String? bio;
  final String? birthDate;
  final String nationality;
  final String? website;
  final Map<String, dynamic>? socialMedia;
  final int totalBooks;
  final int totalBorrowed;
  final double avgRating;
  final bool isActive;

  Author({
    required this.id,
    required this.nama,
    required this.slug,
    this.photo,
    this.bio,
    this.birthDate,
    this.nationality = 'Indonesia',
    this.website,
    this.socialMedia,
    this.totalBooks = 0,
    this.totalBorrowed = 0,
    this.avgRating = 0.0,
    this.isActive = true,
  });

  String get photoUrl {
    if (photo == null || photo!.isEmpty) return '';
    if (photo!.startsWith('http')) return photo!;
    return '${AppConfig.baseUrl}$photo';
  }

  String get initial {
    if (nama.isEmpty) return '?';
    final words = nama.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return nama[0].toUpperCase();
  }

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      slug: json['slug'] ?? '',
      photo: json['photo'],
      bio: json['bio'],
      birthDate: json['birth_date'],
      nationality: json['nationality'] ?? 'Indonesia',
      website: json['website'],
      socialMedia: json['social_media'] is String 
          ? null 
          : json['social_media'] as Map<String, dynamic>?,
      totalBooks: json['total_books'] ?? 0,
      totalBorrowed: json['total_borrowed'] ?? 0,
      avgRating: double.tryParse('${json['avg_rating']}') ?? 0.0,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'slug': slug,
      'photo': photo,
      'bio': bio,
      'birth_date': birthDate,
      'nationality': nationality,
      'website': website,
      'social_media': socialMedia,
      'total_books': totalBooks,
      'total_borrowed': totalBorrowed,
      'avg_rating': avgRating,
      'is_active': isActive,
    };
  }
}
