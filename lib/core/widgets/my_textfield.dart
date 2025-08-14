import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final bool isPassword;
  final String? errorText;
  final int? maxLines;
  final int? maxLength;
  final String? initialValue;
  final bool isReadOnly;
  final TextInputType? keyBoardType;
  final String? prefixIcon;

  const MyTextField({
    super.key,
    this.label = "",
    this.isPassword = false,
    this.controller,
    this.errorText,
    this.maxLines,
    this.maxLength,
    this.initialValue,
    this.isReadOnly = false,
    this.keyBoardType,
    this.prefixIcon,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isHiddenPassword = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: contentStyle.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8.0),
        TextField(
          readOnly: widget.isReadOnly,
          controller: widget.controller,
          keyboardType: widget.keyBoardType ?? TextInputType.text,
          decoration: InputDecoration(
            hintText: widget.initialValue,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: grayBorderColor, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: primaryColor, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: alertColor, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: alertColor, width: 1.0),
            ),
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon != null
                ? Image.asset(widget.prefixIcon!)
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      isHiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: grayColor,
                    ),
                    onPressed: () {
                      setState(() {
                        isHiddenPassword = !isHiddenPassword;
                      });
                    },
                  )
                : null,
          ),
          obscureText: widget.isPassword ? isHiddenPassword : false,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines ?? 1,
        ),
      ],
    );
  }
}
