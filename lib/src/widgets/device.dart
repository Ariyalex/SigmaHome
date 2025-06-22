import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

class Device extends StatefulWidget {
  final bool isOn;
  final IconData icon;
  final String name;

  const Device({
    super.key,
    this.isOn = false,
    required this.icon,
    required this.name,
  });

  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    return _isOn
        ? Container(
            width: 178.50,
            height: 178.50,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  widget.icon,
                  color: AppTheme.iconColor,
                  size: 84,
                  weight: 3,
                ),
                Text(widget.name,
                    style: AppTheme.h2.copyWith(
                      color: AppTheme.iconColor,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "On",
                      style: AppTheme.bodyXL
                          .copyWith(color: AppTheme.secondaryColor),
                    ),
                    Switch(
                        value: _isOn,
                        activeTrackColor: AppTheme.secondaryColor,
                        activeColor: Colors.white,
                        inactiveTrackColor: const Color(0xffC5C6CC),
                        inactiveThumbColor: Colors.white,
                        trackOutlineColor:
                            WidgetStateProperty.all(AppTheme.secondaryColor),
                        onChanged: (value) => setState(() {
                              _isOn = value;
                            }))
                  ],
                )
              ],
            ),
          )
        : Container(
            width: 178.50,
            height: 178.50,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.defaultColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  widget.icon,
                  color: AppTheme.onDefaultColor,
                  size: 84,
                  weight: 3,
                ),
                Text(widget.name,
                    style: AppTheme.h2.copyWith(
                      color: const Color(0xff494A50),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Off",
                      style: AppTheme.bodyXL
                          .copyWith(color: AppTheme.defaultTextColor),
                    ),
                    Switch(
                      value: _isOn,
                      inactiveTrackColor: const Color(0xffC5C6CC),
                      inactiveThumbColor: Colors.white,
                      activeTrackColor: AppTheme.secondaryColor,
                      activeColor: Colors.white,
                      trackOutlineColor:
                          WidgetStateProperty.all(const Color(0xffC5C6CC)),
                      onChanged: (value) => setState(
                        () {
                          _isOn = value;
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }
}
