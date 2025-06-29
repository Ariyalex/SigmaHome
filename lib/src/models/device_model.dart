import 'package:sigma_home/src/models/device_type.dart';

class DeviceModel {
  final String name;
  final String id;
  final DeviceType deviceType;
  final bool deviceStatus;
  final String roomName;

  DeviceModel({
    required this.name,
    required this.id,
    required this.deviceType,
    required this.deviceStatus,
    required this.roomName,
  });

  factory DeviceModel.fromRealtimeDB(String id, Map<dynamic, dynamic> map) {
    return DeviceModel(
      id: id,
      name: map['device_name']?.toString() ?? '',
      deviceType: DeviceType.values.firstWhere(
        (type) => type.name == map['device_type']?.toString(),
        orElse: () => DeviceType.outlet, // Default fallback
      ),
      roomName: map['room_name']?.toString() ?? 'Ruang Utama',
      deviceStatus:
          map['device_status'] == true || map['device_status'] == 'true',
    );
  }

  Map<String, dynamic> toRealtimeDB() {
    return {
      'device_name': name,
      'device_type': deviceType.name, // Simpan sebagai string di database
      'room_name': roomName,
      'device_status': deviceStatus,
    };
  }
}
