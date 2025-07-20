import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final bool isPassword;
  
  const MyTextField({
    super.key,
    this.label = "",
    this.isPassword = false,
    this.controller,
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
          style: contentStyle,
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: grayBorderColor, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: primaryColor, width: 1.0),
            ),
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
        ),
      ],
    );
  }
}
