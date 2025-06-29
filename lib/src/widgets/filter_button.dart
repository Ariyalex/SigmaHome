import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/filter_controller.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/filter_modal.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final filterC = Get.find<FilterController>();

    return Obx(
      () => InkWell(
        onTap: () async {
          final result = await showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => FilterModal(
              initialDeviceType: filterC.selectedDeviceType.value,
              initialActiveOnly: filterC.showActiveOnly.value,
            ),
          );

          if (result != null) {
            filterC.setDeviceTypeFilter(result['deviceType'] ?? 'All');
            filterC.setActiveOnlyFilter(result['activeOnly'] ?? false);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: filterC.hasActiveFilters
                ? AppTheme.primaryColor.withOpacity(0.1)
                : AppTheme.accentColor,
            borderRadius: BorderRadius.circular(12),
            border: filterC.hasActiveFilters
                ? Border.all(color: AppTheme.primaryColor)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                filterC.hasSearchQuery ? Icons.search : Icons.filter_list,
                color: filterC.hasActiveFilters
                    ? AppTheme.primaryColor
                    : AppTheme.iconColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                filterC.hasSearchQuery ? 'Search' : 'Filter',
                style: TextStyle(
                  color: filterC.hasActiveFilters
                      ? AppTheme.primaryColor
                      : AppTheme.textColor,
                  fontWeight: filterC.hasActiveFilters
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              if (filterC.hasActiveFilters) ...[
                const SizedBox(width: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
