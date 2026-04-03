import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';
import '../services/preference_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () async {
      await AuthController.to.checkSession();
      if (!AuthController.to.isLoggedIn.value) {
        Get.offAllNamed(Routes.welcome);
        return;
      }
      // Cek preferensi
      const forceOnboarding = false;
      final prefService = PreferenceService()..onInit();
      final hasPref = await prefService.hasPreferences();
      if (!hasPref || forceOnboarding) {
        Get.offAllNamed(Routes.onboarding);
      } else {
        Get.offAllNamed(Routes.home);
      }
    });
  }
}
