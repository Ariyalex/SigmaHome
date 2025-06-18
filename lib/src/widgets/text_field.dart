import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  const AuthTextField({
    super.key,
    this.labelText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(labelText!),
        TextField(
          controller: controller,
        ),
      ],
    );
  }
}
