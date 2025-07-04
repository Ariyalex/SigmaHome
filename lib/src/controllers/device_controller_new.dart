import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sigma_home/firebase_options.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/models/device_model.dart';

class DeviceController extends GetxController {
  final RxList<DeviceModel> devices = <DeviceModel>[].obs;

  //loading state
  RxBool isLoading = false.obs;
  RxBool isInitialized = false.obs;

  //timer for polling updates (replaces real-time listener)
  Timer? _devicePollingTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeDevices();
  }

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

  Future<void> _initializeDevices() async {
    try {
      isLoading.value = true;
      debugPrint("🔄 Initializing device data with HTTP REST API...");

      // Load devices using HTTP REST API
      await loadDevices();

      // Start polling for updates (replaces real-time listener)
      _startDevicePolling();

      isInitialized.value = true;
      debugPrint("✅ Device controller initialized with HTTP REST API");
    } catch (error) {
      debugPrint("❌ Error initializing devices: $error");
      isInitialized.value = true; // Still set to true to show error state
    } finally {
      isLoading.value = false;
    }
  }

  /// Load devices using HTTP REST API
  Future<void> loadDevices() async {
    try {
      final url = "$userPath?auth=$idToken";

      debugPrint("🔄 Loading devices from: $url");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data == null) {
          devices.clear();
          debugPrint("📱 No devices found for user");
          return;
        }

        final Map<String, dynamic> devicesMap = Map<String, dynamic>.from(data);
        final List<DeviceModel> loadedDevices = [];

        devicesMap.forEach((deviceId, deviceData) {
          try {
            final device = DeviceModel.fromRealtimeDB(deviceId, deviceData);
            loadedDevices.add(device);
            debugPrint("✅ Device loaded: ${device.name}");
          } catch (error) {
            debugPrint("❌ Error parsing device $deviceId: $error");
          }
        });

        devices.assignAll(loadedDevices);
        debugPrint("📱 Total devices loaded: ${devices.length}");
      } else if (response.statusCode == 401) {
        debugPrint("❌ Unauthorized access, token might be invalid");
        throw "Token invalid or expired";
      } else {
        debugPrint("❌ Failed to load devices: ${response.statusCode}");
        throw "Failed to load devices: ${response.statusCode}";
      }
    } catch (error) {
      debugPrint("❌ Error loading devices: $error");
      rethrow;
    }
  }

  /// Start polling for device updates (replaces real-time listener)
  void _startDevicePolling() {
    _devicePollingTimer = Timer.periodic(
      const Duration(seconds: 5), // Poll every 5 seconds
      (timer) async {
        try {
          await loadDevices();
        } catch (error) {
          debugPrint("❌ Error during device polling: $error");
        }
      },
    );
  }

  Future<void> addDevice(DeviceModel device) async {
    try {
      isLoading.value = true;
      debugPrint("🔥 Adding device with HTTP REST API: ${device.name}");

      final url = "$userPath/${device.id}.json?auth=$idToken";
      final deviceData = device.toRealtimeDB();

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(deviceData),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Device added successfully: ${device.name}");

        // Add to local list if not already there
        if (!devices.any((d) => d.id == device.id)) {
          devices.add(device);
          debugPrint("✅ Device added to local list: ${device.name}");
        }
      } else if (response.statusCode == 401) {
        debugPrint("❌ Unauthorized access when adding device");
        throw "Token invalid or expired";
      } else {
        debugPrint("❌ Failed to add device: ${response.statusCode}");
        throw "Failed to add device: ${response.statusCode}";
      }
    } catch (error) {
      debugPrint("❌ Error adding device: $error");
      throw "Gagal menambahkan device: $error";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDeviceStatus(String deviceId, bool status) async {
    try {
      final url = "$userPath/$deviceId/device_status.json?auth=$idToken";

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(status),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Device status updated: $deviceId -> $status");

        // Reload devices to get updated status
        await loadDevices();
      } else if (response.statusCode == 401) {
        debugPrint("❌ Unauthorized access when updating device status");
        throw "Token invalid or expired";
      } else {
        debugPrint("❌ Failed to update device status: ${response.statusCode}");
        throw "Failed to update device status: ${response.statusCode}";
      }
    } catch (error) {
      debugPrint("❌ Error updating device status: $error");
      throw "Gagal mengubah status device: $error";
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
      final url = "$userPath/$deviceId.json?auth=$idToken";

      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        debugPrint("✅ Device deleted: $deviceId");

        // Remove from local list
        devices.removeWhere((d) => d.id == deviceId);
      } else if (response.statusCode == 401) {
        debugPrint("❌ Unauthorized access when deleting device");
        throw "Token invalid or expired";
      } else {
        debugPrint("❌ Failed to delete device: ${response.statusCode}");
        throw "Failed to delete device: ${response.statusCode}";
      }
    } catch (error) {
      debugPrint('❌ Error deleting device: $error');
      throw 'Gagal menghapus device: $error';
    }
  }

  Map<String, List<DeviceModel>> get devicesByRoom {
    final Map<String, List<DeviceModel>> grouped = {};

    for (final device in devices) {
      final roomName = device.roomName;
      if (grouped[roomName] == null) {
        grouped[roomName] = [];
      }
      grouped[roomName]!.add(device);
    }

    final sortedMap = Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return sortedMap;
  }

  List<String> get roomNames {
    return devices.map((device) => device.roomName).toSet().toList()..sort();
  }

  List<DeviceModel> getDevicesByRoom(String roomName) {
    return devices.where((device) => device.roomName == roomName).toList();
  }

  //get device by id
  DeviceModel? getDeviceById(String deviceId) {
    try {
      return devices.firstWhere((device) => device.id == deviceId);
    } catch (error) {
      return null;
    }
  }

  //toggle device status
  Future<void> toggleDeviceStatus(String deviceId) async {
    try {
      debugPrint("🔥 Toggling device status for: $deviceId");

      // Get current status from REST API
      final url = "$userPath/$deviceId/device_status.json?auth=$idToken";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final currentStatus = jsonDecode(response.body) as bool? ?? false;
        debugPrint("🔥 Current status from REST API: $currentStatus");

        final newStatus = !currentStatus;
        debugPrint("🔥 New status will be: $newStatus");

        await updateDeviceStatus(deviceId, newStatus);
      } else if (response.statusCode == 401) {
        debugPrint("❌ Unauthorized access when getting device status");
        throw "Token invalid or expired";
      } else {
        debugPrint("❌ Failed to get device status: ${response.statusCode}");

        // Fallback: Use local device data
        final device = getDeviceById(deviceId);
        if (device != null) {
          debugPrint("🔥 Using local device status: ${device.deviceStatus}");
          await updateDeviceStatus(deviceId, !device.deviceStatus);
        } else {
          debugPrint("❌ Device not found in local list: $deviceId");
          throw "Device tidak ditemukan";
        }
      }
    } catch (error) {
      debugPrint("❌ Error toggling device status: $error");
      throw "Gagal mengubah status device: $error";
    }
  }

  @override
  void onClose() {
    _devicePollingTimer?.cancel();
    super.onClose();
  }
}
