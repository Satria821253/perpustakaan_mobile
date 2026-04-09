import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/app_config.dart';
import '../models/reservation_code_model.dart';
import '../models/return_code_model.dart';
import 'preference_service.dart';

class CodeHistoryService {
  Future<List<ReservationCodeModel>> getReservationCodes({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final token = await PreferenceService.getToken();
    if (token.isEmpty) throw Exception('Token tidak ditemukan');

    var url = '${AppConfig.baseUrl}/api/borrowings/reservations?page=$page&limit=$limit';
    if (status != null) {
      url += '&status=$status';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List reservations = data['reservations'];
      return reservations.map((json) => ReservationCodeModel.fromJson(json)).toList();
    }
    throw Exception('Gagal memuat riwayat reservasi');
  }

  Future<List<ReturnCodeModel>> getReturnCodes({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final token = await PreferenceService.getToken();
    if (token.isEmpty) throw Exception('Token tidak ditemukan');

    var url = '${AppConfig.baseUrl}/api/borrowings/return-codes?page=$page&limit=$limit';
    if (status != null) {
      url += '&status=$status';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List returnCodes = data['return_codes'];
      return returnCodes.map((json) => ReturnCodeModel.fromJson(json)).toList();
    }
    throw Exception('Gagal memuat riwayat kode pengembalian');
  }
}
