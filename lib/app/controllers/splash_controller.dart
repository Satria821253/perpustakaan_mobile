import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';
import '../services/preference_service.dart';

class SplashController extends GetxController {
  final _prefService = PreferenceService();

  @override
  void onInit() {
    super.onInit();
    _prefService.onInit();
    Future.delayed(const Duration(seconds: 3), () async {
      await AuthController.to.checkSession();
      if (!AuthController.to.isLoggedIn.value) {
        Get.offAllNamed(Routes.welcome);
        return;
      }
      final onboardingDone = await _prefService.isOnboardingDone();
      if (onboardingDone) {
        Get.offAllNamed(Routes.home);
        return;
      }
      final hasPref = await _prefService.hasPreferences();
      if (!hasPref) {
        Get.offAllNamed(Routes.onboarding);
      } else {
        Get.offAllNamed(Routes.home);
      }
    });
  }
}
