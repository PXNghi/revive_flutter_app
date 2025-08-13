import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/chat_input.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/features/chat/bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  final String? conversationId;
  const ChatPage({super.key, this.conversationId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const MyAppbar(
          title: "",
          isLeadingImplied: true,
        ),
        body: Padding(
          padding: pageHorizontalPadding,
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is Initial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("CHAT", style: headerStyle),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Visibility(
                      visible: state.messages.isNotEmpty,
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        reverse: true,
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          final isMe =
                              message.sender.id == SessionData.mine?.id;
                          final vietnamTime =
                              (message.createdAt ?? DateTime.now()).toLocal();

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!isMe) ...[
                                  Image.asset(
                                    userDefaultImage,
                                    width: 35,
                                    height: 35,
                                  ), // avatar
                                  const SizedBox(width: 6),
                                ],
                                Flexible(
                                  child: message.fileUrl != null
                                      ? GestureDetector(
                                          onTap: () {
                                            _showFullImageDialog(context,
                                                networkImageUrl:
                                                    "${Enviroment.baseUrl}${message.fileUrl}");
                                          },
                                          child: ClipRRect(
                                            borderRadius: cardBorderRadius,
                                            child: Image.network(
                                              "${Enviroment.baseUrl}${message.fileUrl}",
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.error),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.all(12),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          decoration: BoxDecoration(
                                              color: isMe
                                                  ? chatGreenBoxColor
                                                  : chatGrayBoxColor,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(
                                                    isMe ? 16 : 3),
                                                bottomRight: Radius.circular(
                                                    isMe ? 3 : 16),
                                                topLeft:
                                                    const Radius.circular(16),
                                                topRight:
                                                    const Radius.circular(16),
                                              )),
                                          child: Text(
                                            message.content,
                                            style: TextStyle(
                                              color: isMe
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  DateFormat('hh:mm a', 'vi')
                                      .format(vietnamTime),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ChatInput(
                    messageController: _messageController,
                    onCameraTap: () {
                      context
                          .read<ChatBloc>()
                          .add(const ChatEvent.chooseCamera());
                    },
                    onPhotoTap: () {
                      context
                          .read<ChatBloc>()
                          .add(const ChatEvent.choosePicture());
                    },
                    onSendTap: () {
                      context.read<ChatBloc>().add(
                            ChatEvent.sendMessage(
                              senderId: SessionData.mine?.id ?? "",
                              receiverId: widget.conversationId ?? "",
                              conversationId: widget.conversationId,
                              content: _messageController.text,
                            ),
                          );
                      _messageController.clear();
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showFullImageDialog(
    BuildContext context, {
    File? localImage,
    String? networkImageUrl,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: localImage != null
                ? Image.file(localImage, fit: BoxFit.cover)
                : Image.network(networkImageUrl!, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
