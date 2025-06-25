import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

class Search extends StatefulWidget {
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
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // Create a FocusNode to manage focus
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Initialize the focus node
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the widget is disposed
    _focusNode.dispose();
    super.dispose();
  }

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
            icon: widget.icon,
            onPressed: widget.onPressed,
            color: AppTheme.textColor,
          ),
          Expanded(
            child: TextField(
              autofocus: false,
              focusNode: _focusNode, // Use the properly managed focus node
              controller: widget.textController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: widget.hint,
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
