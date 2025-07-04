import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionControl extends GetxController {
  Future<void> checkForUpdate() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      //interfal fetch
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      //ambil data terbaru dari firebase
      await remoteConfig.fetchAndActivate();

      //dapatkan versi aplikasi yang sedang berjalan
      final packageInfo = await PackageInfo.fromPlatform();

      //gunakan build number untuk perbandingan
      int currentVersionCode = int.parse(packageInfo.buildNumber);

      //dapatkan varsi terbaru dari remote config
      int latestVersionCode = remoteConfig.getInt('latest_version_code');
      String latestVersionName = remoteConfig.getString('latest_version_name');
      String downloadUrl = remoteConfig.getString('download_url');
      bool isUpdateMandatory = remoteConfig.getBool('is_update_mandatory');

      debugPrint("Current version code: $currentVersionCode");
      debugPrint("latest version code from firebase: $latestVersionCode");
      debugPrint("latest version name: $latestVersionName");
      debugPrint("update mandatory: $isUpdateMandatory");

      //membandingkan version code
      if (latestVersionCode > currentVersionCode) {
        showUpdateDialog(latestVersionName, downloadUrl, isUpdateMandatory);
      }
    } catch (error) {
      debugPrint("gagal mengecek update: $error");
    }
  }

  void showUpdateDialog(String versionName, String url, bool isMandatory) {
    Get.defaultDialog(
      barrierDismissible: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      titlePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      title: "Update tersedia!",
      content: Text(
        "Jaku versi $versionName telah dirilis. Mohon perbarui aplikasi untuk mendapatkan fitur terbaru.",
      ),
      cancel: !isMandatory
          ? OutlinedButton(
              onPressed: () => Get.back(),
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                side: WidgetStateProperty.all(
                  const BorderSide(color: AppTheme.primaryColor, width: 1.5),
                ),
              ),
              child: const Text("nanti"),
            )
          : null,
      confirm: FilledButton(
        onPressed: () async {
          final Uri downloadUrl = Uri.parse(url);
          if (await canLaunchUrl(downloadUrl)) {
            await launchUrl(downloadUrl, mode: LaunchMode.externalApplication);
          } else {
            Get.snackbar(
              "Error",
              "Tidak dapat membuka link download",
              backgroundColor: AppTheme.errorColor,
            );
          }
        },
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        child: const Text("Update Sekarang"),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    checkForUpdate();
  }
}
