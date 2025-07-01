import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text("Device ID", style: AppTheme.h4),

                        SelectableText(
                          widget.device.id,
                          style: AppTheme.bodyM.copyWith(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        Text(
                          "Device ID ini digunakan untuk konfigurasi microcontroller",
                          style: AppTheme.actionS,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () =>
                          detailDeviceC.copyDeviceId(widget.device.id),
                      icon: Icon(Icons.copy, color: AppTheme.primaryColor),
                      tooltip: "Copy Device ID",
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
                                        detailDeviceC.selectedDeviceType.value,
                                      );
                                    } else {
                                      detailDeviceC.isEditingType.value = true;
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
                                      detailDeviceC.selectedDeviceType.value ==
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
                                      detailDeviceC.isEditingName.value = true;
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
                        return Text(widget.device.name, style: AppTheme.bodyL);
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
    );
  }
}
