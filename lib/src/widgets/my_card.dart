import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

class MyCard extends StatelessWidget {
  final Widget child;
  final double width;
  final Color color;
  const MyCard({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.color = AppTheme.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
