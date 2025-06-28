import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum DeviceType {
  lamp('Lampu', 'lamp_icon'),
  fan('Kipas', 'fan_icon'),
  tv('TV', 'tv_icon'),
  airConditioner('AC', 'ac_icon'),
  outlet('Outlet', 'outlet_icon'),
  router('Router', 'router_icon');

  const DeviceType(this.displayName, this.iconName);

  final String displayName;
  final String iconName;
  IconData get icon {
    return switch (this) {
      DeviceType.lamp => LucideIcons.lightbulb300,
      DeviceType.fan => LucideIcons.fan300,
      DeviceType.tv => LucideIcons.tv300,
      DeviceType.airConditioner => LucideIcons.airVent300,
      DeviceType.outlet => LucideIcons.plugZap300,
      DeviceType.router => LucideIcons.router300,
    };
  }
}
