import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';

class MyAppbar extends StatelessWidget implements PreferredSize {
  final String title;
  final TextStyle? titleStyle;
  final bool isCenter;
  final List<Widget>? actions;
  final bool isLeadingImplied;
  const MyAppbar({
    super.key,
    required this.title,
    this.isCenter = false,
    this.actions,
    this.isLeadingImplied = true,
    this.titleStyle = headerStyle,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title, style: titleStyle),
      centerTitle: isCenter,
      elevation: 0,
      backgroundColor: Colors.white,
      actions: actions ?? [],
      leading: isLeadingImplied
          ? GestureDetector(
              onTap: () => context.pop(true),
              child: Image.asset(arrowLeftIcon),
            )
          : null,
    );
  }
  
  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
  
  @override
  final Size preferredSize;
}
