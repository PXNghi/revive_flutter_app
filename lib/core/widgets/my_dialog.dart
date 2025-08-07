import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final Widget child;
  final EdgeInsets insetPadding;
  final ShapeBorder? shape;

  const MyDialog({
    super.key,
    required this.child,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 24.0),
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: insetPadding,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(
              color: Colors.green, // hoặc primaryColor
              width: 1.0,
            ),
          ),
      child: child,
    );
  }
}
