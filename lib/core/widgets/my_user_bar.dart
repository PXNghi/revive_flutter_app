import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';

class UserInformationBar extends StatelessWidget {
  final String userName;
  final String userId;
  final bool isChatList;
  final VoidCallback? onEditTap;
  final VoidCallback? onActivateTap;
  const UserInformationBar({
    super.key,
    required this.userName,
    required this.userId,
    this.isChatList = false,
    this.onEditTap,
    this.onActivateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(userDefaultImage, width: 50, height: 50),
        const SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName, style: contentStyle),
            const SizedBox(height: 4.0),
            Text("ID: $userId", style: contentStyle),
          ],
        ),
        const Spacer(),
        Visibility(
          visible: isChatList == false,
          child: Row(
            children: [
              MyIconButton(
                icon: editIcon,
                size: 30,
                onTap: () {},
              ),
              const SizedBox(width: 8.0),
              MyIconButton(
                icon: alertIcon,
                size: 30,
                onTap: () {},
              ),
            ],
          ),
        )
      ],
    );
  }
}
