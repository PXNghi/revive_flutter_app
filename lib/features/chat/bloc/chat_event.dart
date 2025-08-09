part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.started() = _Started;
  const factory ChatEvent.getAllConversations() = _GetAllConversations;
  const factory ChatEvent.getMessages(String conversationId) = _GetMessages;
  const factory ChatEvent.sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    @Default('text') String type,
    String? fileUrl,
  }) = _SendMessage;
  const factory ChatEvent.updateConversation({
    required String conversationId,
    required LastMessage message,
  }) = _UpdateConversation;
}
