import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

enum ButtonType {
  filled,
  text,
  outlined,
}

class FillButton extends StatelessWidget {
  final String? content;
  final VoidCallback? onPressed;
  final ButtonType buttonType;

  const FillButton(
      {super.key,
      required this.content,
      required this.onPressed,
      this.buttonType = ButtonType.filled});

  @override
  Widget build(BuildContext context) {
    final commonStyle = ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, 39),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ));

    switch (buttonType) {
      case ButtonType.filled:
        return FilledButton(
          onPressed: onPressed,
          style: commonStyle,
          child: Text(content!),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: commonStyle,
          child: Text(content!),
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: commonStyle.copyWith(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            side: WidgetStateProperty.all(
              const BorderSide(
                color: AppTheme.primaryColor,
                width: 1.5,
              ),
            ),
          ),
          child: Text(content!),
        );
    }
  }
}
