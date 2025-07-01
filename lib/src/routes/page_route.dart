import 'package:get/get.dart';
import 'package:sigma_home/src/bindings/add_device_binding.dart';
import 'package:sigma_home/src/bindings/device_binding.dart';
import 'package:sigma_home/src/middleware/auth_middleware.dart';
import 'package:sigma_home/src/middleware/guest_middleware.dart';
import 'package:sigma_home/src/routes/route_named.dart';
import 'package:sigma_home/src/screens/about_screen.dart';
import 'package:sigma_home/src/screens/add_device_screen.dart';
import 'package:sigma_home/src/screens/auth/forgot_pass.dart';
import 'package:sigma_home/src/screens/auth/sign_in.dart';
import 'package:sigma_home/src/screens/auth/sign_up.dart';
import 'package:sigma_home/src/screens/home_screen.dart';

class AppPage {
  static final pages = [
    GetPage(
      name: RouteNamed.addDevice,
      page: () => AddDeviceScreen(),
      binding: AddDeviceBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RouteNamed.homeScreen,
      page: () => HomeScreen(),
      binding: DeviceBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: RouteNamed.signIn,
      page: () => SignIn(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: RouteNamed.signUp,
      page: () => SignUp(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: RouteNamed.forgotPass,
      page: () => ForgotPass(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: RouteNamed.about,
      page: () => AboutScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
