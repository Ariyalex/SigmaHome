import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/routes/route_named.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/check_box.dart';
import 'package:sigma_home/src/widgets/fill_button.dart';
import 'package:sigma_home/src/widgets/my_text_field.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;

    const textStyleTerms = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: AppTheme.textColor,
    );

    Future<String?> signUpUser() async {
      authC.isLoading.value = true;

      debugPrint(
        "email: ${authC.email.text}, password: ${authC.password.text}, confirm: ${authC.confirmPass.text}",
      );

      try {
        if (authC.email.text.trim().isEmpty ||
            authC.password.text.trim().isEmpty) {
          throw "Email dan Password tidak boleh kosong";
        } else if (authC.confirmPass.text.trim() !=
            authC.password.text.trim()) {
          throw "Confirm password tidak sama dengan new password";
        } else if (authC.confirmPass.text.trim().isEmpty) {
          throw "Confirm password tidak boleh kosong";
        } else if (authC.confirmPass.text.trim().length < 6) {
          throw ("password harus lebih dari 6 karakter");
        }

        if (authC.terms.value == true) {
          await authC.signUp(
            authC.email.text.trim(),
            authC.confirmPass.text.trim(),
            authC.username.text,
          );

          Get.offAllNamed(RouteNamed.homeScreen);
          Get.snackbar(
            "Success!",
            "Sign up berhasil!",
            backgroundColor: AppTheme.sucessColor,
            colorText: AppTheme.surfaceColor,
          );
        } else {
          throw "setujui syarat dan ketentuan terlebihdulu";
        }
      } catch (error) {
        Get.snackbar(
          "Error!",
          error.toString(),
          backgroundColor: AppTheme.errorColor,
          colorText: AppTheme.surfaceColor,
        );
      } finally {
        authC.isLoading.value = false;
      }
      return null;
    }

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    color: AppTheme.textColor,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    //container untuk form
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 28,
                      ),
                      decoration: ShapeDecoration(
                        color: AppTheme.accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(18),
                        ),
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 18,
                        children: [
                          const SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Create new account",
                              style: AppTheme.h3,
                            ),
                          ),
                          MyTextField(
                            controller: authC.email,
                            labelText: "Email",
                            hintText: "contoh@mail.com",
                            keyboardType: TextInputType.emailAddress,
                          ),
                          MyTextField(
                            controller: authC.username,
                            labelText: "Username",
                            hintText: "new username",
                            keyboardType: TextInputType.name,
                          ),
                          MyTextField(
                            controller: authC.password,
                            isPassword: true,
                            labelText: "Password",
                            hintText: "new password",
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          MyTextField(
                            controller: authC.confirmPass,
                            isPassword: true,
                            labelText: "Confirm password",
                            hintText: "confirm password",
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => MyCheckBox(
                                      value: authC.terms.value ?? false,
                                      onChanged: (value) {
                                        authC.terms.value = value;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Saya menyetujui ",
                                            style: textStyleTerms,
                                          ),
                                          TextSpan(
                                            text: "syarat dan ketentuan",
                                            style: textStyleTerms.copyWith(
                                              color: AppTheme.primaryColor,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                print(
                                                  "syarat ketentuan routing nanti",
                                                );
                                              },
                                          ),
                                          const TextSpan(
                                            text:
                                                " untuk membuat account SigmaHome.",
                                            style: textStyleTerms,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Obx(
                                () => FillButton(
                                  content: "Sign Up",
                                  onPressed: () => signUpUser(),
                                  buttonType: ButtonType.filled,
                                  isLoading: authC.isLoading.value,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: AppTheme.textColor),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: TextButton(
                              onPressed: () {
                                Get.offNamed(RouteNamed.signIn);
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
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
