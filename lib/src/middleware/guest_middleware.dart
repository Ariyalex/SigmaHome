import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/routes/route_named.dart';

class GuestMiddleware extends GetMiddleware {
  @override
  int? priority = 1;

  @override
  RouteSettings? redirect(String? route) {
    final authC = Get.find<AuthController>();

    // ✅ Use isLoggedin getter instead of user object
    if (authC.isLoggedin) {
      return const RouteSettings(name: RouteNamed.homeScreen);
    }

    return null;
  }
}
