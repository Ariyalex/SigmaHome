import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sigma_home/src/controllers/text_controller.dart';
import 'package:sigma_home/src/providers/add_device.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/device_type.dart';
import 'package:sigma_home/src/widgets/generate_device_id.dart';
import 'package:sigma_home/src/widgets/photo_profile.dart';
import 'package:sigma_home/src/widgets/room_selection.dart';
import 'package:sigma_home/src/widgets/text_field_support.dart';

final List<Map<String, dynamic>> deviceTypes = [
  {'icon': LucideIcons.fan300, 'name': 'Kipas'},
  {'icon': LucideIcons.lightbulb300, 'name': 'Lampu'},
  {'icon': LucideIcons.tv300, 'name': 'TV'},
  {'icon': LucideIcons.router300, 'name': 'Router'},
  {'icon': LucideIcons.speaker300, 'name': 'Speaker'},
  {'icon': LucideIcons.washingMachine300, 'name': 'Mesin Cuci'},
];

class AddDevice extends StatelessWidget {
  const AddDevice({super.key});

  @override
  Widget build(BuildContext context) {
    final addDeviceC = Get.find<AddDeviceC>();
    final addDevice = Get.find<AddDeviceProvider>();

    final mediaQueryWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Add New Switch",
          style: AppTheme.h3,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppTheme.primaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PhotoProfile(),
          ),
        ],
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
                        color: AppTheme.accentColor),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                    height: 135,
                    child: ListView.builder(
                      itemCount: deviceTypes.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => addDevice.selected(index),
                            child: Obx(() => DeviceType(
                                  icon: deviceTypes[index]['icon'],
                                  name: deviceTypes[index]['name'],
                                  isActive: index == addDevice.selected.value,
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: BoxBorder.all(
                  color: Color(0xffD4D6DD),
                ),
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
                    controller: TextEditingController(),
                  ),
                  RoomSelection(),
                ],
              ),
            ),
            OutlinedButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                  const BorderSide(
                    color: AppTheme.primaryColor,
                    width: 1.5,
                  ),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              onPressed: () {},
              child: Text("Generate Device ID"),
            ),
            GenerateDeviceId(),
          ],
        ),
      ),
    );
  }
}
