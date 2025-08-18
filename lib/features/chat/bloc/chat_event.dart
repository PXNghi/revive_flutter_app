part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.started() = _Started;
  const factory ChatEvent.getAllConversations() = _GetAllConversations;
  const factory ChatEvent.getMessages(String conversationId) = _GetMessages;
  const factory ChatEvent.sendMessage({
    String? conversationId,
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
  const factory ChatEvent.choosePicture({String? picturePath}) = _ChoosePicture;
  const factory ChatEvent.chooseCamera() = _ChooseCamera;
  const factory ChatEvent.loadMore(String conversationId, {int? page, int? limit}) = _LoadMore;
}
