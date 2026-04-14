import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_config.dart';

class KoinService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConfig.baseUrl;
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((req) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      if (token.isNotEmpty) req.headers['Authorization'] = 'Bearer $token';
      return req;
    });
  }

  /// GET /api/koin/balance
  Future<Map<String, dynamic>> getBalance() async {
    final res = await get('/api/koin/balance');
    if (res.statusCode == 200) {
      final data = res.body['data'] as Map? ?? res.body as Map;
      return Map<String, dynamic>.from(data);
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat saldo koin');
  }

  /// GET /api/koin/summary
  Future<Map<String, dynamic>> getSummary() async {
    final res = await get('/api/koin/summary');
    if (res.statusCode == 200) {
      final data = res.body['data'] as Map? ?? res.body as Map;
      return Map<String, dynamic>.from(data);
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat summary koin');
  }

  /// GET /api/koin/history
  Future<List<Map<String, dynamic>>> getHistory() async {
    final res = await get('/api/koin/history');
    if (res.statusCode == 200) {
      final List raw = res.body['data'] ?? res.body['history'] ?? [];
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat riwayat koin');
  }

  /// POST /api/koin/pay
  Future<Map<String, dynamic>> bayarDendaKoin({
    required int borrowingId,
    required int amount,
    String description = 'Bayar denda terlambat',
  }) async {
    final res = await post('/api/koin/pay', {
      'borrowing_id': borrowingId,
      'amount': amount,
      'description': description,
    });
    print('[KOIN_SERVICE] statusCode: ${res.statusCode}');
    print('[KOIN_SERVICE] body: ${res.body}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = res.body as Map? ?? {};
      return Map<String, dynamic>.from(body['data'] ?? body);
    }
    final body = res.body as Map? ?? {};
    throw Exception(body['error'] ?? body['message'] ?? 'Pembayaran koin gagal (${res.statusCode})');
  }

  /// GET /api/payments/unpaid-fines
  Future<List<Map<String, dynamic>>> getUnpaidFines() async {
    final res = await get('/api/payments/unpaid-fines');
    if (res.statusCode == 200) {
      final List raw = res.body['data'] ?? res.body['fines'] ?? [];
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat denda');
  }

  /// POST /api/payments/pay-fine-online
  Future<Map<String, dynamic>> bayarDendaOnline({
    required int borrowingId,
    required String paymentMethod,
    String? ewalletType,
  }) async {
    final body = <String, dynamic>{
      'borrowing_id': borrowingId,
      'payment_method': paymentMethod,
      if (ewalletType != null) 'ewallet_type': ewalletType,
    };
    final res = await post('/api/payments/pay-fine-online', body);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Map<String, dynamic>.from(res.body['data'] ?? res.body as Map);
    }
    throw Exception(res.body?['error'] ?? res.body?['message'] ?? 'Pembayaran gagal');
  }

  /// GET /api/payments/payment-history
  Future<List<Map<String, dynamic>>> getPaymentHistory() async {
    final res = await get('/api/payments/payment-history');
    if (res.statusCode == 200) {
      final List raw = res.body['data'] ?? res.body['payments'] ?? [];
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat riwayat pembayaran');
  }
}
