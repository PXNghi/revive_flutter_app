import 'package:flutter/material.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback? onSendTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onPhotoTap;
  const ChatInput({
    super.key,
    required this.messageController,
    this.onSendTap,
    this.onCameraTap,
    this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyIconButton(
          icon: cameraIcon,
          onTap: onCameraTap,
          size: 30,
        ),
        const SizedBox(width: 12),
        MyIconButton(
          icon: photoIcon,
          onTap: onPhotoTap,
          size: 30,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: messageController,
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Nhập tin nhắn...",
              contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: grayBorderColor,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        MyIconButton(
          icon: sendIcon,
          size: 30,
          onTap: onSendTap,
        ),
      ],
    );
  }
}
