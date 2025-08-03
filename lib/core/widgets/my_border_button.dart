import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class MyBorderButton extends StatefulWidget {
  final bool isChosen;
  final Widget? customWidget;
  final VoidCallback? onTap;
  const MyBorderButton({
    super.key,
    this.customWidget,
    this.onTap,
    this.isChosen = false,
  });

  @override
  State<MyBorderButton> createState() => _MyBorderButtonState();
}

class _MyBorderButtonState extends State<MyBorderButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: cardBorderRadius,
          border: Border.all(color: widget.isChosen ? primaryColor : grayBorderColor),
          color: widget.isChosen ? primaryColor.withOpacity(0.1) : Colors.white,
        ),
        child: widget.customWidget,
      ),
    );
  }
}
