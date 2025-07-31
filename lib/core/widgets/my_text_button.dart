import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onTap;
  const MyTextButton({
    super.key,
    required this.text,
    this.color = primaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: contentStyle.copyWith(
          color: color,
          decoration: TextDecoration.underline,
          decorationColor: color,
        ),
      ),
    );
  }
}
