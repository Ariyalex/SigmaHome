import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

class Room extends StatelessWidget {
  final String name;
  final bool isActive;
  const Room({
    super.key,
    required this.name,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return isActive
        ? Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: AppTheme.h4.copyWith(color: Colors.black),
              ),
              Container(
                width: 24,
                height: 4,
                decoration: ShapeDecoration(
                  color: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          )
        : Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: AppTheme.bodyM,
              ),
            ],
          );
  }
}
