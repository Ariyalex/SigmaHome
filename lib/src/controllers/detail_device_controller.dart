import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sigma_home/firebase_options.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/controllers/device_controller.dart';
import 'package:sigma_home/src/models/device_type.dart';
import 'package:sigma_home/src/theme/theme.dart';

class DetailDeviceController extends GetxController {
  RxBool isEditingName = false.obs;
  RxBool isEditingRoom = false.obs;
  RxBool isEditingType = false.obs; // ✅ Add editing state for device type
  RxBool isSaving = false.obs;
  Rx<DeviceType> selectedDeviceType =
      DeviceType.lamp.obs; // ✅ Observable for selected device type

  String get userEmail {
    final authController = Get.find<AuthController>();
    final email = authController.currentUserEmail;
    if (email == null) throw "User not logged in";
    return email.replaceAll(".", "_");
  }

  String get databaseUrl {
    return DefaultFirebaseOptions.android.databaseURL!;
  }

  String get userPath {
    return "$databaseUrl/$userEmail.json";
  }

  String get idToken {
    final authController = Get.find<AuthController>();
    return authController.idToken.value;
  }

  Future<void> saveDeviceName(String deviceName, String deviceId) async {
    isSaving.value = true;

    try {
      final url =
          "$databaseUrl/$userEmail/$deviceId/device_name.json?auth=$idToken";

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(deviceName),
      );

      if (response.statusCode == 200) {
        isEditingName.value = false;

        // Refresh device list
        final deviceC = Get.find<DeviceController>();
        await deviceC.loadDevices();

        Get.snackbar(
          'Berhasil',
          'Nama device berhasil diperbarui',
          backgroundColor: AppTheme.sucessColor,
          colorText: Colors.white,
        );
      } else if (response.statusCode == 401) {
        throw "Token invalid or expired";
      } else {
        throw "Failed to update device name: ${response.statusCode}";
      }
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
    isSaving.value = true;

    try {
      final url =
          "$databaseUrl/$userEmail/$deviceId/room_name.json?auth=$idToken";

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(roomName),
      );

      if (response.statusCode == 200) {
        isEditingRoom.value = false;

        // Refresh device list
        final deviceC = Get.find<DeviceController>();
        await deviceC.loadDevices();

        Get.snackbar(
          'Berhasil',
          'Nama ruangan berhasil diperbarui',
          backgroundColor: AppTheme.sucessColor,
          colorText: Colors.white,
        );
      } else if (response.statusCode == 401) {
        throw "Token invalid or expired";
      } else {
        throw "Failed to update room name: ${response.statusCode}";
      }
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

  // ✅ Add function to save device type
  Future<void> saveDeviceType(String deviceId, DeviceType deviceType) async {
    isSaving.value = true;

    try {
      final url =
          "$databaseUrl/$userEmail/$deviceId/device_type.json?auth=$idToken";

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          deviceType.name,
        ), // Save enum name (e.g., 'lamp', 'outlet')
      );

      if (response.statusCode == 200) {
        selectedDeviceType.value = deviceType; // ✅ Update selected device type
        isEditingType.value = false;

        // Refresh device list
        final deviceC = Get.find<DeviceController>();
        await deviceC.loadDevices();

        Get.snackbar(
          'Berhasil',
          'Tipe device berhasil diperbarui',
          backgroundColor: AppTheme.sucessColor,
          colorText: Colors.white,
        );
      } else if (response.statusCode == 401) {
        throw "Token invalid or expired";
      } else {
        throw "Failed to update device type: ${response.statusCode}";
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui tipe device: $error',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  void copyDeviceId(String deviceId, String pesan) {
    Clipboard.setData(ClipboardData(text: deviceId));
    Get.snackbar(
      'Berhasil',
      pesan,
      backgroundColor: AppTheme.sucessColor,
      colorText: Colors.white,
    );
  }

  // ✅ Initialize selected device type
  void setInitialDeviceType(DeviceType deviceType) {
    selectedDeviceType.value = deviceType;
  }

  // ✅ Update selected device type (for UI selection)
  void updateSelectedDeviceType(DeviceType deviceType) {
    selectedDeviceType.value = deviceType;
  }
}
