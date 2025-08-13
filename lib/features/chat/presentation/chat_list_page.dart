import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/features/chat/bloc/chat_bloc.dart';
import 'package:revive_flutter_project/features/chat/models/participant.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppbar(
        title: "",
        isLeadingImplied: true,
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "DANH SÁCH CHAT",
              style: headerStyle,
            ),
            const SizedBox(height: 40),
            _buildChatListSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatListSection() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 16.0),
          shrinkWrap: true,
          itemCount: state.conversations.length,
          itemBuilder: (context, index) {
            final conversation = state.conversations[index];
            final Participant sender = conversation.participants.firstWhere((p) => p.user.id != SessionData.mine!.id);
            String lastMessage = "";
            bool isMe = false;
            if (conversation.lastMessage != null) {
              if (conversation.lastMessage!.senderId == SessionData.mine!.id) {
                isMe = true;
              }
              if (conversation.lastMessage!.content != "") {
                lastMessage = conversation.lastMessage!.content;
              } else {
                if (conversation.lastMessage!.fileUrl != null) {
                  lastMessage = "Đã gửi một ảnh mới";
                }
              }
            }
            return GestureDetector(
              onTap: () async {
                final shouldRefresh = await context.pushNamed('chat-page', queryParameters: {
                  "conversationId": conversation.id,
                });
                if (shouldRefresh == true) {
                  context.read<ChatBloc>().add(const ChatEvent.getAllConversations());
                }
              },
              child: Row(
                children: [
                  Image.asset(userDefaultImage, width: 50, height: 50),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sender.user.name,
                        style: contentStyle.copyWith(
                          fontWeight: (conversation.lastMessage?.isRead == true || isMe == true)
                              ? FontWeight.normal
                              : FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "ID: ${sender.user.id}",
                        style: contentStyle.copyWith(
                          fontWeight: (conversation.lastMessage?.isRead == true || isMe == true)
                              ? FontWeight.normal
                              : FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${isMe ? "Bạn:" : ""} $lastMessage",
                        style: contentStyle.copyWith(
                          color: grayContentColor,
                          fontWeight: (conversation.lastMessage?.isRead == true || isMe == true)
                              ? FontWeight.normal
                              : FontWeight.w700,
                        ),
                      ),
                    ],  
                  ),
                  const Spacer(),
                  Visibility(
                    visible: conversation.lastMessage?.isRead == false && isMe == false,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: alertColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
