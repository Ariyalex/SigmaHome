import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/my_text_field.dart';

class TextFieldSupport extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String suportText;
  final TextEditingController controller;

  const TextFieldSupport({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.suportText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MyTextField(
            labelText: labelText, hintText: hintText, controller: controller),
        Text(
          suportText,
          style: AppTheme.actionS,
        ),
      ],
    );
  }
}
