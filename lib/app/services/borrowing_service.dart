import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_config.dart';
import '../models/borrowing_detail_model.dart';
import '../models/my_book_model.dart';

class BorrowingService extends GetConnect {
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

  Future<List<MyBookModel>> getBorrowings({String status = 'dipinjam'}) async {
    try {
      final res = await get('/api/borrowings/borrowings?status=$status');
      if (res.statusCode == 200) {
        final List raw = res.body['borrowings'] ?? [];
        return raw
            .map((e) {
              try {
                return MyBookModel.fromJson(e as Map<String, dynamic>);
              } catch (_) {
                return null;
              }
            })
            .whereType<MyBookModel>()
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<BorrowingDetailModel> getBorrowingDetail(int borrowingId) async {
    final res = await get('/api/borrowings/borrowings/$borrowingId');
    if (res.statusCode == 200) {
      final body = res.body as Map;
      final data = Map<String, dynamic>.from(body['borrowing'] as Map? ?? body);
      data['timeline'] = body['timeline'] ?? [];
      return BorrowingDetailModel.fromJson(data);
    }
    throw Exception(res.body?['message'] ?? 'Gagal memuat detail');
  }

  Future<void> bayarDendaSebelumKembali({
    required int borrowingId,
    required String metode,
  }) async {
    final res = await post('/api/borrowings/pay-fine-before-return', {
      'borrowing_id': borrowingId,
      'metode': metode,
    });
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(res.body?['message'] ?? 'Gagal membayar denda');
    }
  }

  Future<Map<String, dynamic>> generateReturnCode(int borrowingId) async {
    final res = await post('/api/borrowings/generate-return-code', {
      'borrowing_id': borrowingId,
    });
    if (res.statusCode == 200) return res.body as Map<String, dynamic>;
    throw Exception(res.body?['message'] ?? 'Gagal generate kode');
  }

  Future<void> requestExtension(
      int borrowingId, int durasiHari, String reason) async {
    final res = await post('/api/borrowings/extension-request', {
      'borrowing_id': borrowingId,
      'durasi_hari': durasiHari,
      'reason': reason,
    });
    if (res.statusCode != 200 && res.statusCode != 201) {
      final msg = res.body?['error'] ?? res.body?['message'] ?? 'Gagal request perpanjangan';
      throw Exception(msg);
    }
  }

  Future<List<Map<String, dynamic>>> getExtensionRequests(int borrowingId) async {
    try {
      // endpoint per-borrowing tidak ada, filter dari all requests
      final all = await getAllExtensionRequests();
      return all.where((e) => e['borrowing_id'] == borrowingId).toList();
    } catch (e) {
      print('[EXT-REQ] error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllExtensionRequests() async {
    try {
      final res = await get('/api/borrowings/extension-requests');
      if (res.statusCode == 200) {
        final List raw = res.body['requests'] ?? res.body['data'] ?? [];
        return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return [];
    } catch (e) {
      print('[ALL-EXT] error: $e');
      return [];
    }
  }

  Future<String> checkBorrowingStatus(int borrowingId) async {
    final res = await get('/api/borrowings/borrowings/$borrowingId');
    if (res.statusCode == 200) {
      final body = res.body as Map;
      final data = body['borrowing'] as Map? ?? body;
      return data['status'] as String? ?? '';
    }
    return '';
  }

  Future<Map<String, dynamic>> reserveBuku(int bookId, {int quantity = 1}) async {
    final res = await post('/api/borrowings/reserve-book', {
      'book_id': bookId,
      'quantity': quantity,
    });
    if (res.statusCode == 200 || res.statusCode == 201) {
      return res.body as Map<String, dynamic>;
    }
    throw Exception(
      res.body?['error'] ?? res.body?['message'] ?? 'Gagal reservasi buku',
    );
  }
}
