import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';

class Authbinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
