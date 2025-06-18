import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const primaryColor = Color(0xff006FFD);
  static const secondaryColor = Color(0xff6FBAFF);
  static const accentColor = Color(0xffEAF2FF);
  static const surfaceColor = Colors.white;
  static const errorColor = Color(0xffED3241);
  static const sucessColor = Color(0xff298267);
  static const defaultColor = Color(0xffE8E9F1);
  static const onDefaultColor = Color(0xff71727A);

  static const textColor = Color(0xff2F3036);

  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      tertiary: accentColor,
      onTertiary: textColor,
      error: errorColor,
      onError: Colors.white,
      surface: surfaceColor,
      onSurface: textColor,
    ),
  );
}
