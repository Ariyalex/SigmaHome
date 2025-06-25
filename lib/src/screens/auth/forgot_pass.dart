import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/fill_button.dart';
import 'package:sigma_home/src/widgets/my_text_field.dart';

class ForgotPass extends StatelessWidget {
  const ForgotPass({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          height: mediaQueryHeight,
          width: mediaQueryWidth,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 48,
              children: [
                const Text(
                  "SigmaHome",
                  style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 14,
                  children: [
                    //container untuk form
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 24, horizontal: 28),
                      decoration: ShapeDecoration(
                          color: AppTheme.accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(18),
                          )),
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 18,
                        children: [
                          const SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Reset your password",
                              style: AppTheme.h3,
                            ),
                          ),
                          MyTextField(
                            controller: authC.email,
                            labelText: "Email",
                            hintText: "contoh@mail.com",
                          ),
                          const Expanded(
                            child: Text(
                              "We will send your email to reset your password. Email contains link to reset your password. Don’t reply this email",
                              style: AppTheme.bodyM,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Column(
                            children: [
                              FillButton(
                                content: "Recover",
                                onPressed: () {},
                                buttonType: ButtonType.filled,
                              ),
                              FillButton(
                                content: "Back?",
                                onPressed: () => Get.back(),
                                buttonType: ButtonType.outlined,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
