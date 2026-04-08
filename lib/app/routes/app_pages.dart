import 'package:ei_books/app/controllers/detail_pengembalian_controller.dart';
import 'package:ei_books/app/views/detail_buku/detail_buku_page.dart';
import 'package:ei_books/app/views/detail_peminjaman/detail_peminjaman.dart';
import 'package:ei_books/app/views/konfirmasi_kembali/konfirmasi_kembali_screen.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/explore_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/onboarding_controller.dart';
import '../controllers/splash_controller.dart';
import '../controllers/welcome_controller.dart';
import '../controllers/detail_buku_controller.dart';
import '../controllers/detail_peminjaman_controller.dart';
import '../controllers/konfirmasi_kembali_controller.dart';
import '../controllers/perpanjang_controller.dart';
import '../controllers/detail_perpanjang_controller.dart';
import '../views/perpanjang/perpanjang_screen.dart';
import '../views/detail_perpanjang/detail_perpanjang_screen.dart';
import '../controllers/kode_pengembalian_controller.dart';
import '../views/home/home_page.dart';
import '../views/explore/explore_page.dart';
import '../views/login_page.dart';
import '../views/notification_page.dart';
import '../views/onboarding_page.dart';
import '../views/profile/change_password_page.dart';
import '../views/profile/edit_profile_page.dart';
import '../views/favorite/favorite_page.dart';
import '../views/register_page.dart';
import '../views/splash_page.dart';
import '../views/welcome_page.dart';
import '../views/kode_pengembalian/kode_pengembalian_screen.dart';
import '../views/detail_pengembalian/detail_pengembalian_screen.dart';
import '../views/riwayat/riwayat_page.dart';
import '../controllers/riwayat_controller.dart';
import '../views/konfirmasi_reservasi/konfirmasi_reservasi_screen.dart';
import '../controllers/konfirmasi_reservasi_controller.dart';
import '../controllers/baca_preview_controller.dart';
import '../views/baca_preview/baca_preview_screen.dart';
import '../views/kode_reservasi/kode_reservasi_screen.dart';

import '../models/book_detail_model.dart';

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
        Get.lazyPut(() => DetailBukuController(bookId: bookId),
            tag: 'detail_$bookId', fenix: true);
      }),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingPage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => OnboardingController())),
    ),
    GetPage(
      name: Routes.explore,
      page: () => const ExplorePage(),
      binding: BindingsBuilder(() { Get.put(ExploreController()); }),
    ),
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationPage(),
      binding:
          BindingsBuilder(() => Get.lazyPut(() => NotificationController())),
    ),
    GetPage(
      name: Routes.detailPeminjaman,
      page: () {
        final id = Get.arguments as int;
        return DetailPeminjaman(borrowingId: id);
      },
      binding: BindingsBuilder(() {
        final id = Get.arguments as int;
        Get.lazyPut(() => DetailPeminjamanController(borrowingId: id),
            tag: 'detail_pinjam_$id');
      }),
    ),
    GetPage(
      name: Routes.konfirmasiKembali,
      page: () {
        final id = Get.arguments as int;
        return KonfirmasiKembaliScreen(borrowingId: id);
      },
      binding: BindingsBuilder(() {
        final id = Get.arguments as int;
        Get.lazyPut(() => KonfirmasiKembaliController(borrowingId: id),
            tag: 'konfirmasi_kembali_$id');
      }),
    ),
    GetPage(
      name: Routes.perpanjang,
      page: () {
        final id = Get.arguments as int;
        return PerpanjangScreen(borrowingId: id);
      },
      binding: BindingsBuilder(() {
        final id = Get.arguments as int;
        Get.lazyPut(() => PerpanjangController(borrowingId: id),
            tag: 'perpanjang_$id');
      }),
    ),
    GetPage(
      name: Routes.detailPerpanjang,
      page: () {
        final id = Get.arguments as int;
        return DetailPerpanjangScreen(borrowingId: id);
      },
      binding: BindingsBuilder(() {
        final id = Get.arguments as int;
        Get.lazyPut(() => DetailPerpanjangController(borrowingId: id),
            tag: 'detail_perpanjang_$id');
      }),
    ),
    GetPage(
      name: Routes.kodeKembali,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return KodePengembalianScreen(
          borrowingId: args['borrowingId'] as int,
          kodePengembalian: args['kode'] as String,
          judulBuku: args['judulBuku'] as String,
          tanggalKembali: args['tanggalKembali'] as String,
        );
      },
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map<String, dynamic>;
        Get.lazyPut(
          () => KodePengembalianController(
            kode: args['kode'] as String,
            judulBuku: args['judulBuku'] as String,
            tanggalKembali: args['tanggalKembali'] as String,
            borrowingId: args['borrowingId'] as int,
          ),
          tag: 'kode_kembali_${args['borrowingId']}',
        );
      }),
    ),
    GetPage(
      name: Routes.detailPengembalian,
      page: () {
        final id = Get.arguments as int;
        return DetailPengembalianScreen(borrowingId: id);
      },
      binding: BindingsBuilder(() {
        final id = Get.arguments as int;
        Get.lazyPut(() => DetailPengembalianController(borrowingId: id),
            tag: 'detail_kembali_$id');
      }),
    ),
    GetPage(
      name: Routes.riwayat,
      page: () => const RiwayatPage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => RiwayatController())),
    ),
    GetPage(
      name: Routes.konfirmasiReservasi,
      page: () => const KonfirmasiReservasiScreen(),
      binding: BindingsBuilder(() {
        final buku = Get.arguments as BookDetailModel;
        Get.lazyPut(() => KonfirmasiReservasiController(buku: buku));
      }),
    ),
    GetPage(
      name: Routes.kodeReservasi,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return KodeReservasiScreen(
          kode: args['kode'] as String,
          judul: args['judul'] as String,
          pengarang: args['pengarang'] as String,
          coverImage: args['coverImage'] as String?,
          expiresAt: args['expiresAt'] as String,
          quantity: args['quantity'] as int? ?? 1,
          sisaKuota: args['sisaKuota'] as int? ?? 0,
        );
      },
    ),
    GetPage(
      name: Routes.bacaPreview,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return BacaPreviewScreen(
          bookId: args['book_id'] as int,
          bookTitle: args['book_title'] as String? ?? '',
        );
      },
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map<String, dynamic>;
        Get.lazyPut(
          () => BacaPreviewController(
            bookId: args['book_id'] as int,
            bookTitle: args['book_title'] as String? ?? '',
          ),
          tag: 'preview_${args['book_id']}',
        );
      }),
    ),
  ];
}
