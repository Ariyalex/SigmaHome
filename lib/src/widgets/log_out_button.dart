import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/routes/route_named.dart';
import 'package:sigma_home/src/theme/theme.dart';

class LogOutButton extends StatefulWidget {
  const LogOutButton({super.key});

  @override
  State<LogOutButton> createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<LogOutButton> {
  final authC = Get.find<AuthController>();

  void _logOut() {
    Get.defaultDialog(
      title: "Log Out",
      content: Text("Yakin Log Out dari account"),
      cancel: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text("Tidak"),
      ),
      confirm: FilledButton(
        onPressed: () async {
          // Tutup dialog konfirmasi
          Get.back();

          // Tampilkan indikator loading
          Get.dialog(
            const Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );

          try {
            // Dapatkan controller yang diperlukan

            // Lakukan proses logout
            await authC.signOut();

            // Tutup loading dialog
            Get.back();

            Get.offNamed(RouteNamed.signIn);
          } catch (e) {
            // Tutup loading dialog jika terjadi error
            Get.back();

            // Tampilkan pesan error
            Get.snackbar(
              'Gagal Logout',
              'Terjadi kesalahan: $e',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppTheme.errorColor,
              colorText: AppTheme.surfaceColor,
            );
          }
        },
        child: const Text("Ya"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _logOut(),
      child: const ListTile(
        leading: Icon(
          Icons.logout,
          color: AppTheme.errorColor,
        ),
        title: Text(
          "Log out",
          style: TextStyle(
            color: AppTheme.errorColor,
          ),
        ),
      ),
    );
    ;
  }
}
