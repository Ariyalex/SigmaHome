import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/device_controller.dart';
import 'package:sigma_home/src/controllers/add_device_controller.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:textfield_search/textfield_search.dart';

class RoomSelection extends StatelessWidget {
  const RoomSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final addDevice = Get.find<AddDeviceController>();
    final deviceC = Get.find<DeviceController>();

    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          const Text("Ruangan", style: AppTheme.h5),
          TextFieldSearch(
            initialList: deviceC.roomNames,
            autoClear: false,
            label: "Kamar",
            controller: addDevice.roomNameController,
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
              hintText: "Ruangan",
              hintStyle: const TextStyle(
                color: AppTheme.defaultTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xffC5C6CC),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1.5,
                  color: AppTheme.primaryColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1,
                  color: AppTheme.errorColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1.5,
                  color: AppTheme.errorColor,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xffC5C6CC),
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const Text(
            "*tambahkan ruangan baru atau pilih ruangan yang sudah ada",
            style: AppTheme.actionS,
          ),
        ],
      ),
    );
  }
}
