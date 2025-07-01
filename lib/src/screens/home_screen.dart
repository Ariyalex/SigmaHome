import 'package:dynamic_weather_icons/dynamic_weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/controllers/device_controller.dart';
import 'package:sigma_home/src/controllers/filter_controller.dart';
import 'package:sigma_home/src/controllers/room_controller.dart';
import 'package:sigma_home/src/controllers/weather_controller.dart';
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStatus = Get.put(RoomController());
    final authC = Get.find<AuthController>();
    final deviceC = Get.find<DeviceController>();
    final filterC = Get.find<FilterController>();
    final weatherC = Get.find<WeatherController>();

    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;

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
                  try {
                    Get.toNamed(RouteNamed.addDevice);
                  } catch (error) {
                    Get.snackbar(
                      "error",
                      error.toString(),
                      backgroundColor: AppTheme.errorColor,
                      colorText: AppTheme.surfaceColor,
                    );
                  }
                } else if (value == "about") {
                  try {
                    Get.toNamed(RouteNamed.about);
                  } catch (error) {
                    Get.snackbar(
                      "error",
                      error.toString(),
                      backgroundColor: AppTheme.errorColor,
                      colorText: AppTheme.surfaceColor,
                    );
                  }
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
                      Obx(
                        () => Text(
                          'Hello ${authC.userData.value?.username ?? 'default'}',
                          style: AppTheme.h1,
                        ),
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
              child: Obx(
                () => weatherC.isLoading.value
                    ? SizedBox(
                        width: mediaQueryWidth,
                        height: 100,
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            WeatherIcon.getIcon(weatherC.weatherIcon.value),
                            color: AppTheme.secondaryColor,
                            size: 50,
                          ),
                          SizedBox(
                            width: mediaQueryWidth / 1.7,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GetUtils.capitalize(
                                    weatherC.weatheraStatus.value,
                                  ).toString(),
                                  style: AppTheme.h1,
                                ),
                                Text(
                                  weatherC.celcius.value,
                                  style: AppTheme.h2,
                                ),
                                Text(
                                  GetUtils.capitalize(
                                    weatherC.locations.value,
                                  ).toString(),
                                  style: AppTheme.actionS,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
              //loading pertamakali
              if (deviceC.devices.isEmpty &&
                  deviceC.isLoading.value == true &&
                  deviceC.isInitialized.value == false) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Loading devices...",
                          style: AppTheme.bodyL.copyWith(
                            color: AppTheme.onDefaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (deviceC.devices.isEmpty &&
                  deviceC.isLoading.value == false &&
                  deviceC.isInitialized.value == true) {
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

              if (finalFilteredDevices.isEmpty && deviceC.isInitialized.value) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.devices,
                          size: 64,
                          color: AppTheme.onDefaultColor,
                        ),
                        const SizedBox(height: 16),
                        Text("Tidak ada device di $selectedRoom"),
                        const Text(
                          "Coba ubah filter atau tambahkan device baru",
                        ),
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
                          await showMaterialModalBottomSheet<
                            Map<String, dynamic>
                          >(
                            expand: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            useRootNavigator: true,
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
