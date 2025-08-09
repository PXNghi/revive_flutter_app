import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/person/models/user.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    @JsonKey(name: '_id') @Default('') String id,
    @JsonKey(name: 'conversationId') @Default('') String conversationId,
    @JsonKey(name: 'senderId') required User sender,
    @JsonKey(name: 'senderRole') @Default('User') String userRole,
    @JsonKey(name: 'content') @Default('') String content,
    @JsonKey(name: 'isRead') @Default(false) bool isRead,
    @JsonKey(name: 'readAt') DateTime? readAt,
    @JsonKey(name: 'type') @Default('text') String type,
    @JsonKey(name: 'fileUrl') String? fileUrl,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}