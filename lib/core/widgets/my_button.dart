import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class MyButton extends StatelessWidget {
  final String label;
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;
  const MyButton({
    super.key,
    this.label = "",
    this.width = 175.0,
    this.height = 45.0,
    this.color = primaryColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: color,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: defaultFontSize,
              fontWeight: FontWeight.w600,
              fontFamily: montFont,
            ),
          ),
        ),
      ),
    );
  }
}
