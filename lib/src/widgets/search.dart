import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigma_home/src/controllers/filter_controller.dart';
import 'package:sigma_home/src/theme/theme.dart';

class Search extends StatefulWidget {
  final Widget icon;
  final String hint;
  final VoidCallback? onPressed;

  const Search({
    super.key,
    required this.icon,
    required this.hint,
    this.onPressed,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController textController;
  final filterC = Get.find<FilterController>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();

    // ✅ Sync dengan FilterController RxString
    ever(filterC.searchQuery, (String query) {
      if (textController.text != query) {
        textController.text = query;
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTheme.bodyM.copyWith(color: AppTheme.defaultTextColor),
          prefixIcon: widget.icon,
          suffixIcon:
              // ✅ Reactive clear button
              filterC.hasSearchQuery
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.onDefaultColor),
                  onPressed: () {
                    filterC.clearSearch();
                  },
                )
              : const SizedBox.shrink(),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          // ✅ Update FilterController RxString
          filterC.setSearchQuery(value);
        },
        onSubmitted: (value) {
          filterC.setSearchQuery(value);
          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        },
      ),
    );
  }
}
