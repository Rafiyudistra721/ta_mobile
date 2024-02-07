import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta_mobile/app/data/Models/theme_model.dart';
import 'package:ta_mobile/app/modules/auth/controllers/auth_controller.dart';
import 'package:ta_mobile/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authC.streamAuthStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print(snapshot.data);
          String initialRoute;
          if (snapshot.data != null) {
            // If user is logged in, decide initial route based on user level
            initialRoute = authC.user.level == "Admin" ||
                    authC.user.level == "Petugas"
                ? Routes.DASHBOARD
                : Routes.HOME;
          } else {
            // If user is not logged in, show intro first
            initialRoute = Routes.INTRO;
          }

          // Delay for 2 seconds before navigating to landing page 1
          Future.delayed(Duration(seconds: 2), () {
            Get.offNamed(
              Routes.LANDING_PAGE,
            );
          });

          // Delay for additional 2 seconds before navigating to landing page 2
          Future.delayed(Duration(seconds: 4), () {
            Get.offNamed(
              Routes.LANDING_PAGE2,
            );
          });

          // Delay for additional 2 seconds before navigating to AUTH page
          Future.delayed(Duration(seconds: 6), () {
            Get.offNamed(
              Routes.AUTH,
            );
          });

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeModel.lightTheme,
            darkTheme: ThemeModel.darkTheme,
            title: "Application",
            initialRoute: initialRoute,
            getPages: AppPages.routes,
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
