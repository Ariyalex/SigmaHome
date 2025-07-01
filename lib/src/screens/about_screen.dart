import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/models/about_content.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/my_card.dart';
import 'package:sigma_home/src/widgets/my_card_title.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = Get.height;
    final mediaQueryWidth = Get.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("About SigmaHome", style: AppTheme.h3),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(26),
        width: mediaQueryWidth,
        height: mediaQueryHeight,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 21,
            children: [
              MyCardTitle(
                title: AboutContent.perkenalan["title"],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Text(
                      AboutContent.perkenalan["description1"]!,
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyM.copyWith(color: AppTheme.textColor),
                    ),
                    Text(
                      AboutContent.perkenalan["description2"]!,
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyM.copyWith(color: AppTheme.textColor),
                    ),
                  ],
                ),
              ),
              MyCardTitle(
                title: AboutContent.caraKerja["title"],
                child: Column(
                  spacing: 12,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    (AboutContent.caraKerja["content"] as List).length,
                    (index) => MyCard(
                      color: const Color(0xffB4DBFF),
                      child: Text(
                        AboutContent.caraKerja["content"][index],
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyM,
                      ),
                    ),
                  ),
                ),
              ),
              MyCardTitle(
                title: AboutContent.langkahPenggunaan["title"],
                child: Column(
                  spacing: 12,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    (AboutContent.langkahPenggunaan["content"] as List).length,
                    (index) {
                      if (index == 4) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryColor,
                            child: Text(
                              (index + 1).toString(),
                              style: AppTheme.actionS.copyWith(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "Setup microcontoller sesuai contoh kode pada ",
                                  style: AppTheme.actionS.copyWith(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "repository github",
                                  style: AppTheme.actionS.copyWith(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    color: AppTheme.primaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrl(
                                        Uri.parse(
                                          'https://github.com/Ariyalex/SigmaHome',
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor,
                          child: Text(
                            (index + 1).toString(),
                            style: AppTheme.actionS.copyWith(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          AboutContent.langkahPenggunaan["content"][index],
                          style: AppTheme.actionS.copyWith(
                            fontSize: 14,
                            color: AppTheme.textColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
