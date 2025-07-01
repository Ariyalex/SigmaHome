import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/firebase_options.dart';
import 'package:sigma_home/src/controllers/auth_controller.dart';
import 'package:sigma_home/src/controllers/weather_controller.dart';

import 'src/app.dart';

void main() async {
  //memastika semua yang dilakukan di bawah terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  //inisialisasi firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authC = Get.put(AuthController(), permanent: true);

  //tunggu inisialisasi auth selesai
  await authC.initializedAuth();

  Get.put(WeatherController());

  runApp(const MyApp());
}
