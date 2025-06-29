import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/device_controller.dart';
import 'package:sigma_home/src/theme/theme.dart';

class DetailDeviceController extends GetxController {
  RxBool isEditingName = false.obs;
  RxBool isEditingRoom = false.obs;
  RxBool isSaving = false.obs;

  Future<void> saveDeviceName(String deviceName, String deviceId) async {
    final deviceC = Get.find<DeviceController>();
    isSaving.value = true;

    try {
      await deviceC.userDevicesRef
          .child(deviceId)
          .child('device_name')
          .set(deviceName);

      isEditingName.value = false;

      Get.snackbar(
        'Berhasil',
        'Nama device berhasil diperbarui',
        backgroundColor: AppTheme.sucessColor,
        colorText: Colors.white,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui nama device: $error',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> saveRoomName(String deviceId, String roomName) async {
    final deviceC = Get.find<DeviceController>();
    isSaving.value = true;

    try {
      await deviceC.userDevicesRef
          .child(deviceId)
          .child('room_name')
          .set(roomName);

      isEditingRoom.value = false;

      Get.snackbar(
        'Berhasil',
        'Nama ruangan berhasil diperbarui',
        backgroundColor: AppTheme.sucessColor,
        colorText: Colors.white,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui nama ruangan: $error',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  void copyDeviceId(String deviceId) {
    Clipboard.setData(ClipboardData(text: deviceId));
    Get.snackbar(
      'Berhasil',
      'Device ID telah disalin: $deviceId',
      backgroundColor: AppTheme.sucessColor,
      colorText: Colors.white,
    );
  }
}
