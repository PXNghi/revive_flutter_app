import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';

class MyOptionBar extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isHasArrowRight;
  const MyOptionBar({
    super.key,
    this.label = "",
    this.onTap,
    this.isHasArrowRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: primaryColor.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: contentStyle),
            Visibility(
              visible: isHasArrowRight,
              child: const MyIconButton(icon: arrowRightIcon),
            )
          ],
        ),
      ),
    );
  }
}
