import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/splash_controller.dart';
import '../controllers/welcome_controller.dart';
import '../views/home/home_page.dart';
import '../views/login_page.dart';
import '../views/profile/change_password_page.dart';
import '../views/profile/edit_profile_page.dart';
import '../controllers/detail_buku_controller.dart';
import '../views/detail/detail_buku_page.dart';
import '../views/favorite/favorite_page.dart';
import '../views/register_page.dart';
import '../views/splash_page.dart';
import '../views/welcome_page.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => SplashPage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => SplashController())),
    ),
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomePage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => WelcomeController())),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomePage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => HomeController())),
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfilePage(),
    ),
    GetPage(
      name: Routes.changePassword,
      page: () => const ChangePasswordPage(),
    ),
    GetPage(
      name: Routes.favorite,
      page: () => const FavoritePage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => FavoriteController())),
    ),
    GetPage(
      name: Routes.detail,
      page: () {
        final bookId = Get.arguments as int;
        return DetailBukuPage(bookId: bookId);
      },
      binding: BindingsBuilder(() {
        final bookId = Get.arguments as int;
        Get.lazyPut(() => DetailBukuController(bookId: bookId), tag: 'detail_$bookId');
      }),
    ),
  ];
}
