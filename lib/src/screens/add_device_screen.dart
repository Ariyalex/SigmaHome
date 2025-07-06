import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/models/device_type.dart';
import 'package:sigma_home/src/controllers/add_device_controller.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/device_type_widget.dart';
import 'package:sigma_home/src/widgets/generate_device_id.dart';
import 'package:sigma_home/src/widgets/room_selection.dart';
import 'package:sigma_home/src/widgets/text_field_support.dart';

class AddDeviceScreen extends StatelessWidget {
  const AddDeviceScreen({super.key});
  final List<DeviceType> deviceTypes = DeviceType.values;

  @override
  Widget build(BuildContext context) {
    final addDevice = Get.find<AddDeviceController>();

    final mediaQueryWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Add New Switch", style: AppTheme.h3),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 24,
          children: [
            Container(
              width: mediaQueryWidth,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Pilih Device Baru", style: AppTheme.h3),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.accentColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                    height: 135,
                    child: ListView.builder(
                      itemCount: deviceTypes.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => addDevice.selectDevice(
                              index,
                              deviceTypes[index],
                            ),
                            child: Obx(
                              () => DeviceTypeWidget(
                                icon: deviceTypes[index].icon,
                                name: deviceTypes[index].displayName,
                                isActive:
                                    index ==
                                    addDevice.selectedDeviceIndex.value,
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: BoxBorder.all(color: const Color(0xffD4D6DD)),
              ),
              child: Column(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFieldSupport(
                    labelText: "Nama Device",
                    hintText: "Ex: lampu fufufafa",
                    suportText: "*Berikan device nama",
                    keyboardType: TextInputType.text,
                    controller: addDevice.deviceNameController,
                  ),
                  RoomSelection(),
                ],
              ),
            ),
            OutlinedButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                  const BorderSide(color: AppTheme.primaryColor, width: 1.5),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              onPressed: addDevice.isGeneratingId.value
                  ? null
                  : () {
                      if (addDevice.deviceNameController.text.isNotEmpty &&
                          addDevice.roomNameController.text.isNotEmpty &&
                          addDevice.selectedDeviceType.value != null) {
                        addDevice.generateDeviceId();
                      } else {
                        Get.snackbar(
                          'Data tidak lengkap',
                          'Lengkapi form yang dibutuhkan dulu!',
                          backgroundColor: AppTheme.errorColor,
                          colorText: Colors.white,
                        );
                      }
                    },
              child: const Text("Generate Device ID"),
            ),
            Obx(() {
              if (addDevice.generatedId.isNotEmpty) {
                return GenerateDeviceId();
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
