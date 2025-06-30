import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/models/device_model.dart';

class DeviceController extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<DeviceModel> devices = <DeviceModel>[].obs;
  final RxBool isLoading = false.obs;

  //stream subscription
  StreamSubscription<DatabaseEvent>? _devicesSubsciription;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      listenToDevices();
    });
  }

  String get userEmail {
    final email = _auth.currentUser?.email;
    if (email == null) throw "User not logged in";
    return email.replaceAll(".", "_");
  }

  DatabaseReference get userDevicesRef {
    return _database.child(userEmail);
  }

  //listen to real-time changes
  void listenToDevices() {
    try {
      _devicesSubsciription = userDevicesRef.onValue.listen(
        (DatabaseEvent event) {
          final data = event.snapshot.value;

          if (data == null) {
            devices.clear();
            return;
          }

          try {
            final Map<dynamic, dynamic> devicesMap =
                data as Map<dynamic, dynamic>;
            final List<DeviceModel> loadedDevices = [];

            devicesMap.forEach((deviceId, deviceData) {
              try {
                final Map<String, dynamic> properDeviceData = {};
                if (deviceData is Map) {
                  deviceData.forEach((key, value) {
                    properDeviceData[key.toString()] = value;
                  });
                }
                final device = DeviceModel.fromRealtimeDB(
                  deviceId.toString(),
                  deviceData,
                );
                loadedDevices.add(device);
                debugPrint("✅ Device loaded: ${device.name}");
              } catch (error) {
                debugPrint("❌ Error parsing device $deviceId: $error");
              }
            });
            devices.assignAll(loadedDevices);
            debugPrint("devices laoded: ${devices.length}");
          } catch (error) {
            debugPrint("❌ Error processing devices data: $error");
          }
        },
        onError: (error) {
          debugPrint("error listening to devices: $error");
        },
      );
    } catch (error) {
      debugPrint("error setting up device listener: $error");
    }
  }

  Future<void> addDevice(DeviceModel device) async {
    try {
      isLoading.value = true;
      debugPrint("🔥 Adding device to Firebase: ${device.name}");
      await userDevicesRef.child(device.id).set(device.toRealtimeDB());
      debugPrint("device added: ${device.name}");

      if (!devices.any((d) => d.id == device.id)) {
        devices.add(device);
        debugPrint("✅ Device added to local list: ${device.name}");
      }
    } catch (error) {
      debugPrint("error adding device: $error");
      throw "gagal menambahkan device: $error";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDeviceStatus(String deviceId, bool status) async {
    try {
      await userDevicesRef.child(deviceId).child('device_status').set(status);
      debugPrint("device status updated: $deviceId -> $status");
    } catch (error) {
      debugPrint("error updating device status: $error");
      throw "gagal mengubah status device: $error";
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
      await userDevicesRef.child(deviceId).remove();
      debugPrint("Device deleted: $deviceId");
    } catch (error) {
      debugPrint('Error deleting device: $error');
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

      // ✅ Get current status from Firebase directly (more reliable)
      final snapshot = await userDevicesRef
          .child(deviceId)
          .child('device_status')
          .get();
      final currentStatus = snapshot.value as bool? ?? false;

      debugPrint("🔥 Current status from Firebase: $currentStatus");

      final newStatus = !currentStatus;

      debugPrint("🔥 New status will be: $newStatus");

      await updateDeviceStatus(deviceId, newStatus);
    } catch (error) {
      debugPrint("❌ Error toggling device status: $error");

      // ✅ Fallback: Use local device data
      final device = getDeviceById(deviceId);
      if (device != null) {
        debugPrint("🔥 Using local device status: ${device.deviceStatus}");
        await updateDeviceStatus(deviceId, !device.deviceStatus);
      } else {
        debugPrint("❌ Device not found in local list: $deviceId");
        throw "Device tidak ditemukan";
      }
    }
  }

  @override
  void onClose() {
    _devicesSubsciription?.cancel();
    super.onClose();
  }
}
