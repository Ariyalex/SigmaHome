import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sigma_home/src/controllers/text_controller.dart';
import 'package:sigma_home/src/providers/add_switch.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/device_type.dart';

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
    final addDeviceC = Get.put(AddDeviceC());
    final addDevice = Get.put(AddSwitch());
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Switch"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 20),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
