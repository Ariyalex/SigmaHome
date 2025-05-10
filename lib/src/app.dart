import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/routes/page_route.dart';
import 'package:sigma_home/src/screens/home_screen.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      getPages: AppPage.pages,
    );
  }
}
