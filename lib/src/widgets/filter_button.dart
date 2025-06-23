import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';
import 'package:sigma_home/src/widgets/filter_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => showMaterialModalBottomSheet(
        context: context,
        builder: (context) => FilterModal(),
      ),
      label: Text("Filter"),
      icon: Icon(
        Icons.filter_list,
      ),
      style: ButtonStyle(
        overlayColor:
            WidgetStatePropertyAll(Colors.grey.withValues(alpha: 0.2)),
        foregroundColor: WidgetStatePropertyAll(AppTheme.onDefaultColor),
        side: WidgetStateProperty.all(
          const BorderSide(
            color: Color(0xffC5C6CC),
            width: 1,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
