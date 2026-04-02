import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () async {
      await AuthController.to.checkSession();
      if (AuthController.to.isLoggedIn.value) {
        Get.offAllNamed(Routes.home);
      } else {
        Get.offAllNamed(Routes.welcome);
      }
    });
  }
}
