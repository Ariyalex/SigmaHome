import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/add_device_controller.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class GenerateDeviceId extends StatelessWidget {
  const GenerateDeviceId({super.key});

  @override
  Widget build(BuildContext context) {
    final addDeviceC = Get.find<AddDeviceController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          // Device ID Display
          Obx(
            () => RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: "Device ID: ", style: AppTheme.bodyL),
                  TextSpan(
                    text: addDeviceC.generatedId.value,
                    style: AppTheme.bodyL.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Clipboard.setData(
                          ClipboardData(text: addDeviceC.generatedId.value),
                        );
                        Get.snackbar(
                          'Berhasil disalin',
                          'Id: ${addDeviceC.generatedId.value}',
                          backgroundColor: AppTheme.sucessColor,
                          colorText: Colors.white,
                        );
                      },
                  ),
                ],
              ),
            ),
          ),

          const Text(
            "Device ID digunakan untuk path database, bahan-bahan yang diperlukan untuk microcontroller ada di detail device dengan double click device",
            style: AppTheme.bodyM,
          ),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Detail instruksi ada di readme ",
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

          // ✅ Create Device Button dengan loading state
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    addDeviceC.canAddDevice && !addDeviceC.isLoading.value
                    ? () async {
                        try {
                          debugPrint("🔥 Creating device...");
                          await addDeviceC.addDevice();
                          debugPrint("✅ Device created successfully");
                        } catch (error) {
                          debugPrint("❌ Error creating device: $error");
                          Get.snackbar(
                            'Error',
                            error.toString(),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      }
                    : null,
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: addDeviceC.isLoading.value
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text("Creating..."),
                        ],
                      )
                    : const Text("Create Device"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
