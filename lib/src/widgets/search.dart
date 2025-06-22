import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

class Search extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final TextEditingController textController;
  final String? hint;

  const Search({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.textController,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xffF8F9FE),
      ),
      child: Row(
        children: [
          IconButton(
            icon: icon,
            onPressed: onPressed,
            color: AppTheme.textColor,
          ),
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  color: AppTheme.defaultTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
              style: const TextStyle(
                color: AppTheme.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
