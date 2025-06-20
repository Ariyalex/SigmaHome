import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

class MyCheckBox extends StatelessWidget {
  final ValueChanged<bool?> onChanged;
  final bool value;
  const MyCheckBox({
    super.key,
    required this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      side: const BorderSide(
        color: Color(0xffC5C6CC),
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      activeColor: AppTheme.primaryColor,
      checkColor: Colors.white,
    );
  }
}
