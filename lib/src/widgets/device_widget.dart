import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/my_switch.dart';

class DeviceWidget extends StatefulWidget {
  final bool isOn;
  final IconData icon;
  final String name;
  final VoidCallback? onToggle;
  final String? roomName;

  const DeviceWidget({
    super.key,
    required this.isOn,
    required this.icon,
    required this.name,
    this.onToggle,
    this.roomName,
  });

  @override
  State<DeviceWidget> createState() => _DeviceWidgetState();
}

class _DeviceWidgetState extends State<DeviceWidget> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.isOn;
  }

  // ✅ Update state saat widget properties berubah
  @override
  void didUpdateWidget(DeviceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOn != widget.isOn) {
      _isOn = widget.isOn;
    }
  }

  // ✅ Handle toggle dengan callback
  void _handleToggle(bool value) {
    setState(() {
      _isOn = value;
    });

    // ✅ Call parent callback jika ada
    if (widget.onToggle != null) {
      widget.onToggle!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isOn
        ? Container(
            width: 178.50,
            height: 178.50,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        widget.icon,
                        color: AppTheme.iconColor,
                        size: 70,
                        weight: 3,
                      ),
                      if (widget.roomName != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Text(
                            widget.roomName!,
                            style: AppTheme.actionS,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.name,
                    style: AppTheme.h2.copyWith(color: AppTheme.iconColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "On",
                        style: AppTheme.bodyXL.copyWith(
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                      Myswitch(
                        isOn: _isOn,
                        onChanged: _handleToggle, // ✅ Use handler function
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: 178.50,
            height: 178.50,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.defaultColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        widget.icon,
                        color: AppTheme.onDefaultColor,
                        size: 70,
                        weight: 3,
                      ),
                      if (widget.roomName != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Text(
                            widget.roomName!,
                            style: AppTheme.actionS,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.name,
                    style: AppTheme.h2.copyWith(color: const Color(0xff494A50)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Off",
                        style: AppTheme.bodyXL.copyWith(
                          color: AppTheme.defaultTextColor,
                        ),
                      ),
                      Myswitch(
                        isOn: _isOn,
                        onChanged: _handleToggle, // ✅ Use handler function
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
