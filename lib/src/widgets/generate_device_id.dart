import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/providers/add_device.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class GenerateDeviceId extends StatelessWidget {
  GenerateDeviceId({super.key});
  final addDevice = Get.find<AddDeviceProvider>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: "Device ID: ", style: AppTheme.bodyL),
                TextSpan(
                  text: addDevice.generatedId.value,
                  style: AppTheme.bodyL.copyWith(color: AppTheme.primaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Clipboard.setData(
                        ClipboardData(text: addDevice.generatedId.value),
                      );
                      Get.snackbar(
                        'Berhasil disalin',
                        'Id: ${addDevice.generatedId.value}',
                        backgroundColor: AppTheme.sucessColor,
                        colorText: Colors.white,
                      );
                    },
                ),
              ],
            ),
          ),
          Text(
            "Gunakan Device ID ini untuk code microcontroller",
            style: AppTheme.bodyM,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Contoh code Micorcontroller ada di ",
                  style: AppTheme.actionS.copyWith(color: Colors.black),
                ),
                TextSpan(
                  text: "repository github",
                  style: AppTheme.actionS.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(
                        Uri.parse('https://github.com/Ariyalex/SigmaHome'),
                      );
                    },
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await addDevice.addDevice();
              } catch (error) {
                Get.snackbar('Error', error.toString());
              }
            },
            child: Text("Create Device"),
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
