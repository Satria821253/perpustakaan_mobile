import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/profile_service.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  final _service = ProfileService();
  final _picker = ImagePicker();

  final isLoading = false.obs;
  final isUploadingPhoto = false.obs;
  final notifEnabled = true.obs;

  // Stats dari profile-complete
  final totalDipinjam = 0.obs;
  final sedangDipinjam = 0.obs;
  final totalDenda = 0.obs;
  final totalReview = 0.obs;
  final limitPinjam = 3.obs;

  // Challenge
  final Rx<Map<String, dynamic>?> challenge = Rx(null);

  // Active borrowings
  final activeBorrowings = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _service.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading(true);
    try {
      final res = await _service.getProfileComplete();

      final userJson = res['user'] as Map<String, dynamic>;
      final koin = (res['koin']?['saldo'] ?? 0) as int;
      final user = UserModel.fromJson({...userJson, 'koin': koin});
      AuthController.to.user(user);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_user', jsonEncode({...userJson, 'koin': koin}));

      final stats = res['stats'] as Map<String, dynamic>? ?? {};
      totalDipinjam(stats['total_buku_dipinjam'] ?? 0);
      sedangDipinjam(stats['buku_sedang_dipinjam'] ?? 0);
      totalDenda((stats['total_denda'] ?? 0).toInt());
      totalReview(stats['total_review'] ?? 0);

      final list = (res['active_borrowings'] as List? ?? []).cast<Map<String, dynamic>>();
      activeBorrowings.assignAll(list);
      print('[PROFILE] active_borrowings: ${list.map((e) => e['cover_image']).toList()}');

      challenge(res['challenge_progress'] as Map<String, dynamic>?);
    } catch (e) {
      print('[PROFILE] FETCH ERROR: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> pickAndUploadPhoto() async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (file == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Foto',
          toolbarColor: const Color(0xFF1565C0),
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: const Color(0xFF1565C0),
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
          ],
        ),
      ],
    );
    if (cropped == null) return;

    isUploadingPhoto(true);
    try {
      final bytes = await cropped.readAsBytes();
      await _service.uploadPhoto(bytes, file.name);
      await fetchAll();
      Get.snackbar('Berhasil', 'Foto profile diperbarui', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUploadingPhoto(false);
    }
  }

  Future<void> updateProfile({required String nama, required String noTelepon}) async {
    try {
      await _service.updateProfile(nama: nama, noTelepon: noTelepon);
      await fetchAll();
      Get.back();
      Get.snackbar('Berhasil', 'Profile berhasil diupdate', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> requestOtp() => _service.requestOtp();

  Future<void> changePasswordWithOtp({required String otp, required String newPassword}) async {
    await _service.changePasswordWithOtp(otp: otp, newPassword: newPassword);
  }

  void toggleNotif(bool val) => notifEnabled(val);

  Future<void> logout() => AuthController.to.logout();
}
