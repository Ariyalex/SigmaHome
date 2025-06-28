import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/device_controller.dart';

class DeviceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DeviceController());
  }
}
