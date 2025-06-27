import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/routes/route_named.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? priority = 1; //lower number = higher priority

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    final isLoggedIn = authController.user != null;

    if (isLoggedIn) {
      return null;
    }

    return const RouteSettings(name: RouteNamed.signIn);
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint("route called; ${page?.name}");
    return page;
  }

  @override
  Widget onPageBuilt(Widget page) {
    debugPrint("page built: ${Get.currentRoute}");
    return page;
  }
}
