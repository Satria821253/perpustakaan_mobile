import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/fcm_service.dart';
import '../services/preference_service.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final _service = AuthService();
  final _prefService = PreferenceService();

  final isLoggedIn = false.obs;
  final isLoading = false.obs;
  final Rx<UserModel?> user = Rx(null);

  bool get bolehPinjam => isLoggedIn.value;

  static const _keyToken = 'auth_token';
  static const _keyUser  = 'auth_user';

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    _prefService.onInit();
  }

  Future<void> checkSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token    = prefs.getString(_keyToken);
      final userJson = prefs.getString(_keyUser);
      if (token != null && token.isNotEmpty && userJson != null) {
        user(UserModel.fromJson(jsonDecode(userJson)));
        isLoggedIn(true);
      }
    } catch (_) {}
  }

  Future<void> login({required String email, required String password}) async {
    isLoading(true);
    try {
      final res = await _service.login(email: email, password: password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyToken, res['token'] ?? '');
      await prefs.setString(_keyUser, jsonEncode(res['user']));
      user(UserModel.fromJson(res['user']));
      isLoggedIn(true);
      await FcmService.uploadTokenIfLoggedIn();
      final onboardingDone = await _prefService.isOnboardingDone();
      if (onboardingDone) {
        Get.offAllNamed('/home');
      } else {
        final hasPref = await _prefService.hasPreferences();
        if (!hasPref) {
          Get.offAllNamed('/onboarding');
        } else {
          await _prefService.markOnboardingDone();
          Get.offAllNamed('/home');
        }
      }
      _refreshUser();
    } catch (e) {
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> _refreshUser() async {
    try {
      final res = await _service.getProfile();
      final fresh = UserModel.fromJson(res['user']);
      user(fresh);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUser, jsonEncode(res['user']));
    } catch (_) {}
  }

  Future<void> register({
    required String email,
    required String password,
    required String nama,
    required String noTelepon,
  }) async {
    isLoading(true);
    try {
      await _service.register(
        email: email,
        password: password,
        nama: nama,
        noTelepon: noTelepon,
      );
    } catch (e) {
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
    isLoggedIn(false);
    user(null);
    Get.offAllNamed('/welcome');
  }
}
