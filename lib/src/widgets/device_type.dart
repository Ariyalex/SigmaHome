import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

class DeviceType extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool isActive;

  DeviceType({
    super.key,
    required this.icon,
    required this.name,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return isActive
        ? Container(
            height: 115,
            width: 105,
            decoration: BoxDecoration(
              color: Color(0xff6FBAFF),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  weight: 3,
                  size: 70,
                ),
                Text(
                  name,
                  style: AppTheme.h4.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ))
        : Container(
            height: 115,
            width: 105,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: AppTheme.iconColor,
                  weight: 3,
                  size: 70,
                ),
                Text(
                  name,
                  style: AppTheme.h4.copyWith(
                    color: AppTheme.iconColor,
                  ),
                ),
              ],
            ),
          );
  }
}
