import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

class Myswitch extends StatefulWidget {
  final bool isOn;
  final ValueChanged<bool> onChanged;
  const Myswitch({super.key, required this.isOn, required this.onChanged});

  @override
  State<Myswitch> createState() => _MyswitchState();
}

class _MyswitchState extends State<Myswitch> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.isOn;
  }

  @override
  void didUpdateWidget(Myswitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOn != widget.isOn) {
      isOn = widget.isOn;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isOn,
      activeTrackColor: AppTheme.secondaryColor,
      activeColor: Colors.white,
      inactiveTrackColor: const Color(0xffC5C6CC),
      inactiveThumbColor: Colors.white,
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      onChanged: (value) {
        setState(() {
          isOn = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
