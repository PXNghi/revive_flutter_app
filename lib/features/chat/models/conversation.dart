import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/chat/models/participant.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    @JsonKey(name: '_id') @Default('') String id,
    @JsonKey(name: 'participants') required List<Participant> participants,
    @JsonKey(name: 'lastMessage') LastMessage? lastMessage,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, Object?> json) =>
      _$ConversationFromJson(json);
}

@freezed
class LastMessage with _$LastMessage {
  const factory LastMessage({
    @JsonKey(name: '_id') @Default('') String id,
    @JsonKey(name: 'conversationId') @Default('') String conversationId,
    @JsonKey(name: 'senderId') @Default('') String senderId,
    @JsonKey(name: 'senderRole') @Default('User') String userRole,
    @JsonKey(name: 'content') @Default('') String content,
    @JsonKey(name: 'isRead') @Default(false) bool isRead,
    @JsonKey(name: 'readAt') DateTime? readAt,
    @JsonKey(name: 'type') @Default('text') String type,
    @JsonKey(name: 'fileUrl') String? fileUrl,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _LastMessage;

  factory LastMessage.fromJson(Map<String, Object?> json) =>
      _$LastMessageFromJson(json);
}
