import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/detail_device_controller.dart';
import 'package:sigma_home/src/controllers/device_controller.dart';
import 'package:sigma_home/src/controllers/filter_controller.dart';
import 'package:sigma_home/src/controllers/room_controller.dart';

class DeviceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DeviceController());
    Get.put(FilterController());
    Get.put(DetailDeviceController());
    Get.put(RoomController());
  }
}
