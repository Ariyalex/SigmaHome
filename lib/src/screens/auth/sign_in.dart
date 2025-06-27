import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/routes/route_named.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/fill_button.dart';
import 'package:sigma_home/src/widgets/my_text_field.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;

    Future<String?> authUser() async {
      authC.isLoading.value = true;

      debugPrint('Name: ${authC.email.text}, Password: ${authC.password.text}');

      try {
        //cek email or password kosong
        if (authC.email.text.trim().isEmpty ||
            authC.password.text.trim().isEmpty) {
          throw "Email dan Password tidak boleh kosong";
        }

        await authC.signIn(
          authC.email.text.trim(),
          authC.password.text.trim(),
        );

        Get.offAllNamed(RouteNamed.homeScreen);
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

    Future<void> authWithGoogle() async {
      try {
        await authC.signInWithGoogle();

        Get.offAllNamed(RouteNamed.homeScreen);
      } catch (error) {
        print(error);
        Get.snackbar(
          "Error!",
          error.toString(),
          backgroundColor: AppTheme.errorColor,
          colorText: AppTheme.surfaceColor,
        );
      } finally {
        authC.isLoadingGoogle.value = false;
      }
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
                      color: AppTheme.textColor),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 14,
                  children: [
                    //container untuk form
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 28),
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
                              "Login to your account",
                              style: AppTheme.h3,
                            ),
                          ),
                          MyTextField(
                            controller: authC.email,
                            labelText: "Email",
                            hintText: "contoh@mail.com",
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          MyTextField(
                            controller: authC.password,
                            isPassword: true,
                            labelText: "Password",
                            hintText: "ex: user123",
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          Column(
                            children: [
                              Obx(() => FillButton(
                                    content: "Sign In",
                                    onPressed: () {
                                      authUser();
                                    },
                                    buttonType: ButtonType.filled,
                                    isLoading: authC.isLoading.value,
                                  )),
                              FillButton(
                                content: "Forgot Password?",
                                onPressed: () {
                                  Get.toNamed(RouteNamed.forgotPass);
                                },
                                buttonType: ButtonType.text,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        const Text(
                          "-Or sign in with-",
                          style: AppTheme.h3,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          splashColor: AppTheme.accentColor,
                          onTap: authWithGoogle,
                          child: Obx(() => Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppTheme.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                child: authC.isLoadingGoogle.value
                                    ? const CircularProgressIndicator(
                                        strokeWidth: 4,
                                        color: AppTheme.iconColor,
                                      )
                                    : const Icon(
                                        FontAwesomeIcons.google,
                                        color: AppTheme.primaryColor,
                                        size: 30,
                                      ),
                              )),
                        ),
                        //navigasi sign up
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(color: AppTheme.textColor)),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: TextButton(
                                  onPressed: () {
                                    Get.offNamed(RouteNamed.signUp);
                                  },
                                  child: const Text(
                                    "Sign up",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
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
