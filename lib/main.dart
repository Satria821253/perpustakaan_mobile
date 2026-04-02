import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EI Books',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Poppins',
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
      }),
    );
  }
}
