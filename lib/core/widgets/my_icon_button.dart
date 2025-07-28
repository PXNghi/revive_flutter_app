import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class MyIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;
  final double size;
  final bool isCircleIcon;
  final double circleSize;
  const MyIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 20.0,
    this.isCircleIcon = false,
    this.circleSize = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isCircleIcon ? circleSize : size,
        height: isCircleIcon ? circleSize : size,
        decoration: isCircleIcon
            ? BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.3),
                border: Border.all(color: primaryColor, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  ),
                ],
              )
            : null,
        child: Image.asset(
          icon,
          height: size,
          width: size,
        ),
      ),
    );
  }
}