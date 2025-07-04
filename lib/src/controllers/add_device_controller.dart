import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/controllers/device_controller.dart';
import 'package:sigma_home/src/models/device_model.dart';
import 'package:sigma_home/src/models/device_type.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:uuid/uuid.dart';

class AddDeviceController extends GetxController {
  // Device selection
  var selectedDeviceIndex = (-1).obs;
  final Rxn<DeviceType> selectedDeviceType = Rxn<DeviceType>();

  // Form controllers
  final deviceNameController = TextEditingController();
  final roomNameController = TextEditingController();
  final deviceIdController = TextEditingController();

  //generated id observable
  final RxString generatedId = ''.obs;
  final RxBool isGeneratingId = false.obs;

  final RxBool isLoading = false.obs;

  final Uuid uuid = const Uuid();

  // Get device controller
  DeviceController get deviceController => Get.find<DeviceController>();
  AuthController get authContoller => Get.find<AuthController>();

  void selectDevice(int index, DeviceType deviceType) {
    selectedDeviceIndex.value = index;
    selectedDeviceType.value = deviceType;
  }

  void setRoomName(String roomName) {
    roomNameController.text = roomName;
  }

  //generate custom device id
  Future<void> generateDeviceId() async {
    try {
      isGeneratingId.value = true;

      final username =
          authContoller.userData.value?.username.replaceAll(" ", "") ?? "user";

      final uuidString = uuid.v4();

      final shortUuid = uuidString.substring(0, 8);

      final customId = '$username-$shortUuid';

      bool idExists = await checkIfIdExists(customId);

      while (idExists) {
        final newUuid = uuid.v4().substring(0, 8);
        final newCustomId = '$username-$newUuid';
        idExists = await checkIfIdExists(newCustomId);
        if (!idExists) {
          generatedId.value = newCustomId;
          deviceIdController.text = newCustomId;
          break;
        }
      }

      if (!idExists) {
        generatedId.value = customId;
        deviceIdController.text = customId;
      }

      debugPrint('Generated Device ID: ${generatedId.value}');

      Get.snackbar(
        'Success',
        'Device ID berhasil dibuat: ${generatedId.value}',
        backgroundColor: AppTheme.sucessColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (error) {
      debugPrint('Error generating device ID: $error');
      Get.snackbar(
        'Error',
        'Gagal membuat Device ID: $error',
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isGeneratingId.value = false;
    }
  }

  //check if device id alredy exists
  Future<bool> checkIfIdExists(String deviceId) async {
    try {
      final existingDevice = deviceController.getDeviceById(deviceId);
      return existingDevice != null;
    } catch (error) {
      debugPrint('error checking device id: $error');
      return false;
    }
  }

  // ✅ Get suggested rooms from existing devices
  List<String> get suggestedRooms {
    return deviceController.roomNames;
  }

  bool get canAddDevice {
    return selectedDeviceType.value != null &&
        deviceNameController.text.trim().isNotEmpty &&
        roomNameController.text.trim().isNotEmpty &&
        generatedId.value.isNotEmpty;
  }

  bool get canGenerateId {
    return selectedDeviceType.value != null &&
        deviceNameController.text.trim().isNotEmpty &&
        roomNameController.text.trim().isNotEmpty;
  }

  Future<void> addDevice() async {
    if (!canAddDevice) {
      throw 'Please complete all fields';
    }

    final device = DeviceModel(
      name: deviceNameController.text.trim(),
      id: generatedId.value,
      deviceType: selectedDeviceType.value!,
      deviceStatus: false,
      roomName: roomNameController.text.trim(),
    );

    try {
      await deviceController.addDevice(device);

      resetForm();

      Get.back();
      Get.snackbar(
        'Success',
        'Device "${device.name}" berhasil ditambahkan ke ${device.roomName}',
        backgroundColor: AppTheme.sucessColor,
        colorText: Colors.white,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    }
  }

  void resetForm() {
    selectedDeviceIndex.value = -1;
    selectedDeviceType.value = null;
    deviceNameController.clear();
    roomNameController.clear();
    deviceIdController.clear();
    generatedId.value = '';
  }
}
