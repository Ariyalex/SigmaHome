import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/fill_button.dart';
import 'package:sigma_home/src/widgets/text_field.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.put(AuthController());

    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
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
                style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 14,
                children: [
                  //container untuk form
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 28),
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
                        AuthTextField(
                          controller: authC.email,
                          labelText: "Email",
                          hintText: "contoh@mail.com",
                        ),
                        AuthTextField(
                          controller: authC.password,
                          isPassword: true,
                          labelText: "Password",
                          hintText: "contoh@mail.com",
                        ),
                        Column(
                          children: [
                            FillButton(
                              content: "Sign In",
                              onPressed: () {},
                              buttonType: ButtonType.filled,
                            ),
                            FillButton(
                              content: "Forgot Password?",
                              onPressed: () {},
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
                      Text("Or sign in with"),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        splashColor: AppTheme.accentColor,
                        onTap: () async {
                          // try {
                          //   setState(() {
                          //     _isLoadingGoogle = true;
                          //   });

                          //   await authController.signInWithGoogle();

                          //   if (!mounted) return;

                          //   Get.offNamed(RouteNamed.homePage);
                          // } catch (error) {
                          //   Get.snackbar(
                          //     "Error!",
                          //     error.toString(),
                          //     backgroundColor: color.colorScheme.error,
                          //     colorText: color.colorScheme.onError,
                          //   );
                          // } finally {
                          //   if (mounted) {
                          //     setState(() {
                          //       _isLoadingGoogle = false;
                          //     });
                          //   }
                          // }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Icon(
                            FontAwesomeIcons.google,
                            color: AppTheme.primaryColor,
                            size: 30,
                          ),
                        ),
                      ),
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
                                  // Get.toNamed(RouteNamed.signUpScreen);
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
    );
  }
}
