import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class MyTabItem extends StatefulWidget {
  final String text;
  final bool isChosen;
  final VoidCallback? onTap;
  const MyTabItem({
    super.key,
    required this.text,
    this.isChosen = false,
    this.onTap,
  });

  @override
  State<MyTabItem> createState() => _MyTabItemState();
}

class _MyTabItemState extends State<MyTabItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: IntrinsicWidth(
          stepWidth: 5.0,
          child: Column(
            children: [
              Text(
                widget.text,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: widget.isChosen ? FontWeight.bold : FontWeight.w500,
                  color: widget.isChosen ? primaryColor : Colors.black,
                  fontFamily: montFont,
                ),
              ),
              const SizedBox(height: 6),
              Visibility(
                visible: widget.isChosen,
                child: Container(
                  height: 2,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
