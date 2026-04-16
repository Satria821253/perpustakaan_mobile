import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/app_config.dart';
import '../models/author_model.dart';

class AuthorService {
  Future<List<Author>> getPopularAuthors({int limit = 3}) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/authors/popular?limit=$limit');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final authors = (data['authors'] as List)
          .map((json) => Author.fromJson(json))
          .toList();
      return authors;
    } else {
      throw Exception('Failed to load popular authors');
    }
  }

  Future<Map<String, dynamic>> getAuthorDetail(int authorId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/authors/$authorId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'author': Author.fromJson(data['author']),
        'books': data['books'] ?? [],
      };
    } else {
      throw Exception('Failed to load author detail');
    }
  }
}
