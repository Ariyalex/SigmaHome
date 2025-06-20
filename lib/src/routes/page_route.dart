import 'package:get/get.dart';
import 'package:sigma_home/src/routes/route_named.dart';
import 'package:sigma_home/src/screens/add_device.dart';
import 'package:sigma_home/src/screens/auth/forgot_pass.dart';
import 'package:sigma_home/src/screens/auth/sign_in.dart';
import 'package:sigma_home/src/screens/auth/sign_up.dart';

class AppPage {
  static final pages = [
    GetPage(
      name: RouteNamed.addDevice,
      page: () => AddDevice(),
    ),
    GetPage(
      name: RouteNamed.signIn,
      page: () => SignIn(),
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
