import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/chat/models/message.dart';

part 'messages_response.freezed.dart';
part 'messages_response.g.dart';

@freezed 
class MessagesResponse with _$MessagesResponse {
  const factory MessagesResponse({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'conversationId') @Default('') String conversationId,
    @JsonKey(name: 'messages') @Default([]) List<Message> messages,
    @JsonKey(name: 'page') @Default(0) int page,
    @JsonKey(name: 'totalPages') @Default(0) int totalPages,
    @JsonKey(name: 'totalMessages') @Default(0) int totalMessages
  }) = _MessagesResponse;

  factory MessagesResponse.fromJson(Map<String, dynamic> json) => _$MessagesResponseFromJson(json);
}