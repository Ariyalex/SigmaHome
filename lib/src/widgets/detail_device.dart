import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/controllers/detail_device_controller.dart';
import 'package:sigma_home/src/models/device_model.dart';
import 'package:sigma_home/src/models/device_type.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/device_type_widget.dart';

class DetailDevice extends StatefulWidget {
  final DeviceModel device;
  const DetailDevice({super.key, required this.device});

  @override
  State<DetailDevice> createState() => _DetailDeviceState();
}

class _DetailDeviceState extends State<DetailDevice> {
  final List<DeviceType> deviceTypes = DeviceType.values;

  late TextEditingController deviceNameController;
  late TextEditingController roomNameController;
  final detailDeviceC = Get.find<DetailDeviceController>();
  final authC = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    deviceNameController = TextEditingController(text: widget.device.name);
    roomNameController = TextEditingController(text: widget.device.roomName);

    // ✅ Initialize the selected device type in controller
    detailDeviceC.setInitialDeviceType(widget.device.deviceType);
  }

  @override
  void dispose() {
    deviceNameController.dispose();
    roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String databasePath =
        "${authC.currentUserEmail!.replaceAll('.', '_')}/${widget.device.id}/device_status";

    return Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Header with close button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Detail Device", style: AppTheme.h2),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text("Path Realtime Database", style: AppTheme.h4),
                            Text(
                              databasePath,
                              style: AppTheme.bodyM.copyWith(
                                color: AppTheme.primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text(
                              "Device ID ini digunakan untuk konfigurasi microcontroller",
                              style: AppTheme.actionS,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => detailDeviceC.copyDeviceId(
                          databasePath,
                          "Berhasil copy path",
                        ),
                        icon: Icon(Icons.copy, color: AppTheme.primaryColor),
                        tooltip: "Copy Device ID",
                      ),
                    ],
                  ),
                ),

                //idtoken dan refresh token
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with refresh button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Authentication Tokens", style: AppTheme.h3),
                          IconButton(
                            onPressed: () async {
                              try {
                                await authC.refreshIdToken();
                                Get.snackbar(
                                  "Berhasil!",
                                  "Token berhasil di-refresh",
                                  backgroundColor: AppTheme.sucessColor,
                                  colorText: Colors.white,
                                );
                              } catch (error) {
                                Get.snackbar(
                                  "Error!",
                                  "Gagal refresh token: $error",
                                  backgroundColor: AppTheme.errorColor,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: AppTheme.primaryColor,
                            ),
                            tooltip: "Refresh Tokens",
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Refresh Token
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Refresh Token", style: AppTheme.h4),
                                Obx(
                                  () => Text(
                                    authC.refreshTkn.value,
                                    style: AppTheme.bodyM.copyWith(
                                      color: AppTheme.primaryColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => detailDeviceC.copyDeviceId(
                              authC.refreshTkn.value,
                              "Berhasil copy refresh token",
                            ),
                            icon: Icon(
                              Icons.copy,
                              color: AppTheme.primaryColor,
                            ),
                            tooltip: "Copy Refresh Token",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Token Description
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Informasi Token",
                            style: AppTheme.h4.copyWith(
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Refresh Token Description
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "• Refresh Token: ",
                                style: AppTheme.bodyM.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              Text(
                                "Token yang digunakan untuk mendapatkan ID Token baru ketika token lama sudah expired. Token ini memiliki masa aktif yang lebih lama.",
                                style: AppTheme.bodyS.copyWith(
                                  color: Colors.blue.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Usage Description
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "• Penggunaan: ",
                                style: AppTheme.bodyM.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              Text(
                                "Token ini diperlukan untuk microcontroller agar bisa mengakses Firebase Realtime Database dengan izin yang sesuai.",
                                style: AppTheme.bodyS.copyWith(
                                  color: Colors.blue.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.accentColor,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  height: 190,
                  child: Column(
                    children: [
                      // ✅ Header with edit button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Device Type", style: AppTheme.h4),
                          Obx(
                            () => IconButton(
                              onPressed: detailDeviceC.isSaving.value
                                  ? null
                                  : () {
                                      if (detailDeviceC.isEditingType.value) {
                                        // ✅ Save the selected device type
                                        detailDeviceC.saveDeviceType(
                                          widget.device.id,
                                          detailDeviceC
                                              .selectedDeviceType
                                              .value,
                                        );
                                      } else {
                                        detailDeviceC.isEditingType.value =
                                            true;
                                      }
                                    },
                              icon:
                                  detailDeviceC.isSaving.value &&
                                      detailDeviceC.isEditingType.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      detailDeviceC.isEditingType.value
                                          ? Icons.check
                                          : Icons.edit,
                                      color: AppTheme.primaryColor,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      // ✅ Device type list - Reactive
                      Expanded(
                        child: ListView.builder(
                          itemCount: deviceTypes.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  // ✅ Only allow selection when editing
                                  if (detailDeviceC.isEditingType.value) {
                                    detailDeviceC.saveDeviceType(
                                      widget.device.id,
                                      deviceTypes[index],
                                    );
                                  }
                                },
                                child: Obx(
                                  () => DeviceTypeWidget(
                                    icon: deviceTypes[index].icon,
                                    name: deviceTypes[index].displayName,
                                    isActive:
                                        detailDeviceC
                                            .selectedDeviceType
                                            .value ==
                                        deviceTypes[index],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Device type chips
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Nama Device", style: AppTheme.h4),
                          Obx(
                            () => IconButton(
                              onPressed: detailDeviceC.isSaving.value
                                  ? null
                                  : () {
                                      if (detailDeviceC.isEditingName.value) {
                                        detailDeviceC.saveDeviceName(
                                          deviceNameController.text,
                                          widget.device.id,
                                        );
                                      } else {
                                        detailDeviceC.isEditingName.value =
                                            true;
                                      }
                                    },
                              icon:
                                  detailDeviceC.isSaving.value &&
                                      detailDeviceC.isEditingName.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      detailDeviceC.isEditingName.value
                                          ? Icons.save
                                          : Icons.edit,
                                      color: AppTheme.primaryColor,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        if (detailDeviceC.isEditingName.value) {
                          return TextField(
                            controller: deviceNameController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: "Masukkan nama device",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onSubmitted: (_) => detailDeviceC.saveDeviceName(
                              deviceNameController.text,
                              widget.device.id,
                            ),
                          );
                        } else {
                          return Text(
                            widget.device.name,
                            style: AppTheme.bodyL,
                          );
                        }
                      }),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Nama Ruangan", style: AppTheme.h4),
                          Obx(
                            () => IconButton(
                              onPressed: detailDeviceC.isSaving.value
                                  ? null
                                  : () {
                                      if (detailDeviceC.isEditingRoom.value) {
                                        detailDeviceC.saveRoomName(
                                          widget.device.id,
                                          roomNameController.text,
                                        );
                                      } else {
                                        setState(() {
                                          detailDeviceC.isEditingRoom.value =
                                              true;
                                        });
                                      }
                                    },
                              icon:
                                  detailDeviceC.isSaving.value &&
                                      detailDeviceC.isEditingRoom.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      detailDeviceC.isEditingRoom.value
                                          ? Icons.save
                                          : Icons.edit,
                                      color: AppTheme.primaryColor,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        if (detailDeviceC.isEditingRoom.value) {
                          return TextField(
                            controller: roomNameController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: "Masukkan nama ruangan",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onSubmitted: (_) => detailDeviceC.saveRoomName(
                              widget.device.id,
                              roomNameController.text,
                            ),
                          );
                        } else {
                          return Text(
                            widget.device.roomName,
                            style: AppTheme.bodyL,
                          );
                        }
                      }),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
