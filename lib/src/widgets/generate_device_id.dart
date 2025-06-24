import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

class GenerateDeviceId extends StatelessWidget {
  const GenerateDeviceId({super.key});

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
                const TextSpan(
                  text: "Device ID: ",
                  style: AppTheme.bodyL,
                ),
                TextSpan(
                  text: "ZETA-DVC01",
                  style: AppTheme.bodyL.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print(
                        "ZETA-DVC01",
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
                      print(
                        "ZETA-DVC01",
                      );
                    },
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {},
            child: Text("Create Device"),
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
