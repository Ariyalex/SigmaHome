import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/controllers/device_controller.dart';
import 'package:sigma_home/src/controllers/filter_controller.dart';
import 'package:sigma_home/src/controllers/room_controller.dart';
import 'package:sigma_home/src/routes/route_named.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/detail_device.dart';
import 'package:sigma_home/src/widgets/device_widget.dart';
import 'package:sigma_home/src/widgets/edit_profile.dart';
import 'package:sigma_home/src/widgets/fill_button.dart';
import 'package:sigma_home/src/widgets/filter_button.dart';
import 'package:sigma_home/src/widgets/log_out_button.dart';
import 'package:sigma_home/src/widgets/room.dart';
import 'package:sigma_home/src/widgets/search.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStatus = Get.put(RoomController());
    final authC = Get.find<AuthController>();
    final deviceC = Get.find<DeviceController>();
    final filterC = Get.find<FilterController>();

    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('SigmaHome', style: AppTheme.h3),
        actions: [
          Builder(
            builder: (context) => PopupMenuButton<String>(
              icon: const Icon(
                Icons.menu,
                color: AppTheme.iconColor,
              ), // Burger Icon
              onSelected: (value) {
                if (value == "device") {
                  Get.toNamed(RouteNamed.addDevice);
                } else if (value == "profile") {
                  // _logout(context);
                } else if (value == "about") {
                  // clearAllData(context);
                }
              },

              position: PopupMenuPosition.under,
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: "device",
                  child: ListTile(
                    leading: Icon(Icons.add, color: AppTheme.iconColor),
                    title: Text("Add Device"),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: "profile",
                  child: EditProfile(),
                ),
                const PopupMenuItem<String>(
                  value: "about",
                  child: ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: AppTheme.iconColor,
                    ),
                    title: Text("About"),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: "logout",
                  child: LogOutButton(),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: mediaQueryWidth,
        height: mediaQueryHeight,
        child: Column(
          spacing: 12,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello ${authC.userData.value?.username ?? 'default'}',
                        style: AppTheme.h1,
                      ),
                      Text(
                        "Welcome to SigmaHome",
                        style: TextStyle(
                          color: AppTheme.onDefaultColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              //container cuaca
              margin: EdgeInsets.symmetric(horizontal: 28),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.accentColor,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.max,
                spacing: 22,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BoxedIcon(
                    WeatherIcons.day_cloudy,
                    color: AppTheme.secondaryColor,
                    size: 50,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cerah Berawan", style: AppTheme.h1),
                      Text("24°C", style: AppTheme.h2),
                      Text(
                        "Ngemplak, Sleman, Yogyakarta",
                        style: AppTheme.actionS,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(flex: 4, child: FilterButton()),
                  Flexible(
                    flex: 7,
                    child: Search(
                      icon: Icon(Icons.search),
                      hint: "Search Device",
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              final roomNames = ['All', ...deviceC.roomNames];

              if (roomNames.length <= 1) {
                return const SizedBox.shrink();
              }

              return Container(
                width: mediaQueryWidth,
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: roomNames.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final roomName = roomNames[index];
                    return InkWell(
                      splashColor: AppTheme.accentColor,
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => buttonStatus.selectedRoom(index, roomName),

                      child: Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Room(
                            name: roomName,
                            isActive:
                                index == buttonStatus.activeRoomIndex.value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            Obx(() {
              if (deviceC.devices.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.devices, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Belum ada device'),
                        Text('Tambahkan device pertama Anda'),
                      ],
                    ),
                  ),
                );
              }

              final selectedRoom = buttonStatus.selectedRoomName.value;

              final roomFilteredDevices =
                  selectedRoom.isEmpty || selectedRoom == 'All'
                  ? deviceC.devices
                  : deviceC.devices
                        .where((device) => device.roomName == selectedRoom)
                        .toList();

              final finalFilteredDevices = filterC.filterDevices(
                roomFilteredDevices,
              );

              debugPrint("🏠 Room filter: $selectedRoom");
              debugPrint("🔍 Additional filters: ${filterC.filterSummary}");
              debugPrint(
                "📱 Final devices count: ${finalFilteredDevices.length}",
              );

              if (finalFilteredDevices.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.devices,
                          size: 64,
                          color: AppTheme.onDefaultColor,
                        ),
                        const SizedBox(height: 16),
                        Text("Tidak ada device di $selectedRoom"),
                        const Text("Tambahkan device untuk ruangan ini"),
                      ],
                    ),
                  ),
                );
              }

              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 18.0,
                          mainAxisSpacing: 18.0,
                          childAspectRatio: 1,
                        ),
                    itemCount: finalFilteredDevices.length,
                    itemBuilder: (context, index) {
                      final device = finalFilteredDevices[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onLongPress: () {
                          Get.defaultDialog(
                            title: "Hapus device",
                            content: Text("Yakin hapus device?"),
                            cancel: TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("Tidak"),
                            ),
                            confirm: FilledButton(
                              onPressed: () async {
                                Get.back();

                                Get.dialog(
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  barrierDismissible: false,
                                );

                                try {
                                  deviceC.deleteDevice(device.id);
                                  Get.back();
                                } catch (e) {
                                  Get.back();

                                  Get.snackbar(
                                    'Gagal menghapus device',
                                    'Terjadi kesalahan: $e',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: AppTheme.errorColor,
                                    colorText: AppTheme.surfaceColor,
                                  );
                                }
                              },
                              child: const Text("Ya"),
                            ),
                          );
                        },
                        onDoubleTap: () async {
                          await showModalBottomSheet<Map<String, dynamic>>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => DetailDevice(device: device),
                          );
                        },
                        child: DeviceWidget(
                          icon: device.deviceType.icon,
                          name: device.name,
                          roomName: device.roomName,
                          isOn: device.deviceStatus,
                          onToggle: () => deviceC.toggleDeviceStatus(device.id),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),

            Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: FillButton(
                content: "ADD NEW DEVICE",
                color: Color(0xff2897FF),
                onPressed: () {
                  Get.toNamed(RouteNamed.addDevice);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
