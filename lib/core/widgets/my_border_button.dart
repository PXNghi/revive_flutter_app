import 'package:flutter/material.dart';

class MyBorderButton extends StatefulWidget {
  const MyBorderButton({super.key});

  @override
  State<MyBorderButton> createState() => _MyBorderButtonState();
}

class _MyBorderButtonState extends State<MyBorderButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}