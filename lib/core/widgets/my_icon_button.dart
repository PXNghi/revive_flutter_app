import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;
  final double size;
  const MyIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 20.0
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        icon,
        height: size,
        width: size,
      ),
    );
  }
}