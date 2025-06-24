import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/my_switch.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  // State variables for filter selections
  final List<String> _deviceTypes = [
    'All',
    'Lights',
    'AC',
    'TV',
    'Speaker',
    'Router'
  ];
  String _selectedDeviceType = 'All';
  bool _showActiveOnly = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Header with close button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter Devices",
                    style: AppTheme.h2,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Device Type Filter section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                "Device Type",
                style: AppTheme.h4,
              ),
            ),

            // Device type chips
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Wrap(
                spacing: 8,
                children: _deviceTypes.map((type) {
                  return FilterChip(
                    label: Text(type),
                    selected: _selectedDeviceType == type,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDeviceType = type;
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: AppTheme.accentColor,
                    checkmarkColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(color: AppTheme.textColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Show Active Only toggle
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Show Active Devices Only",
                    style: AppTheme.bodyM,
                  ),
                  Myswitch(
                    isOn: _showActiveOnly,
                    onChanged: (value) {
                      setState(
                        () {
                          _showActiveOnly = value;
                        },
                      );
                    },
                  )
                ],
              ),
            ),

            // Apply and Reset buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedDeviceType = 'All';
                          _showActiveOnly = false;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        // Return the filter selections to the calling screen
                        Navigator.of(context).pop({
                          'deviceType': _selectedDeviceType,
                          'activeOnly': _showActiveOnly,
                        });
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
