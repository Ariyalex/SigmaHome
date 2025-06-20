import 'package:get/get.dart';
import 'package:sigma_home/src/routes/route_named.dart';
import 'package:sigma_home/src/screens/add_device.dart';
import 'package:sigma_home/src/screens/auth/sign_in.dart';

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
  ];
}
