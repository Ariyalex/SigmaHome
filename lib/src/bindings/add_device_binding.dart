import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/add_device_controller.dart';

class AddDeviceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddDeviceController());
  }
}
