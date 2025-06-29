import 'package:flutter/material.dart';
import 'package:sigma_home/src/theme/theme.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const MyTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.textInputAction,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = widget.controller;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(widget.labelText, style: AppTheme.h5),
          ),
          const SizedBox(height: 8),
          TextField(
            keyboardType: widget.keyboardType,
            controller: _textController,
            textInputAction: widget.textInputAction,
            obscureText: widget.isPassword ? _obscureText : false,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: AppTheme.defaultTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xffC5C6CC),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1.5,
                  color: AppTheme.primaryColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1,
                  color: AppTheme.errorColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1.5,
                  color: AppTheme.errorColor,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1,
                  color: Color(0xffC5C6CC),
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: _togglePasswordVisibility,
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppTheme.onDefaultColor,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
