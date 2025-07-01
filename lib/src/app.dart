import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/routes/page_route.dart';
import 'package:sigma_home/src/routes/route_named.dart';
import 'package:sigma_home/src/theme/theme.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: _getInitialRoute(),
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      getPages: AppPage.pages,
    );
  }

  String _getInitialRoute() {
    final authC = Get.find<AuthController>();

    if (authC.userData.value != null) {
      return RouteNamed.homeScreen;
    } else {
      return RouteNamed.signIn;
    }
  }
}
