import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPass = TextEditingController();
  final username = TextEditingController();

  RxnBool terms = RxnBool();
}
