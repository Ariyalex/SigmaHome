import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

class MyCardTitle extends StatelessWidget {
  final Widget child;
  final String? title;
  final double width;
  const MyCardTitle({
    super.key,
    required this.child,
    this.title,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          title!.isNotEmpty
              ? Text(title!, style: AppTheme.h1, textAlign: TextAlign.center)
              : const SizedBox.shrink(),
          child,
        ],
      ),
    );
  }
}
