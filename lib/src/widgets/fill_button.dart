import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

enum ButtonType {
  filled,
  text,
  outlined,
}

class FillButton extends StatelessWidget {
  final String content;
  final VoidCallback? onPressed;
  final ButtonType buttonType;
  final Color color;
  final bool isLoading;

  const FillButton({
    super.key,
    required this.content,
    required this.onPressed,
    this.color = AppTheme.primaryColor,
    this.buttonType = ButtonType.filled,
    this.isLoading = false,
  });

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
          onPressed: isLoading ? null : onPressed,
          style: commonStyle.copyWith(
            backgroundColor: WidgetStateProperty.all(
              isLoading ? color.withValues(alpha: 0.6) : color,
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  content,
                  style: TextStyle(color: Colors.white),
                ),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: commonStyle,
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              : Text(
                  content,
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: commonStyle.copyWith(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            side: WidgetStateProperty.all(
              BorderSide(
                color: isLoading
                    ? AppTheme.primaryColor.withValues(alpha: 0.6)
                    : AppTheme.primaryColor,
                width: 1.5,
              ),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              : Text(
                  content,
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
        );
    }
  }
}
