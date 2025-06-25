import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/text_controller.dart';
import 'package:sigma_home/src/providers/add_device.dart';

class AddDeviceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddDeviceC());
    Get.put(AddDeviceProvider());
  }
}
