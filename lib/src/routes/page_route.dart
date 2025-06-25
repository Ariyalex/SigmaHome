import 'package:get/get.dart';
import 'package:sigma_home/src/bindings/add_device_binding.dart';
import 'package:sigma_home/src/bindings/auth_binding.dart';
import 'package:sigma_home/src/routes/route_named.dart';
import 'package:sigma_home/src/screens/add_device.dart';
import 'package:sigma_home/src/screens/auth/forgot_pass.dart';
import 'package:sigma_home/src/screens/auth/sign_in.dart';
import 'package:sigma_home/src/screens/auth/sign_up.dart';
import 'package:sigma_home/src/screens/home_screen.dart';

class AppPage {
  static final pages = [
    GetPage(
      name: RouteNamed.addDevice,
      page: () => AddDevice(),
      binding: AddDeviceBinding(),
    ),
    GetPage(
      name: RouteNamed.homeScreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: RouteNamed.signIn,
      page: () => SignIn(),
      binding: Authbinding(),
    ),
    GetPage(
      name: RouteNamed.signUp,
      page: () => SignUp(),
    ),
    GetPage(
      name: RouteNamed.forgotPass,
      page: () => ForgotPass(),
    ),
  ];
}
