part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = Initial;
  const factory ChatState.loading() = Loading;
  const factory ChatState.loaded({
    @Default([]) List<Conversation> conversations,
  }) = Loaded;
  const factory ChatState.success() = Success;
  const factory ChatState.error(String message) = Error;

  const ChatState._();

  List<Conversation> get conversations => mapOrNull(loaded: (state) => state.conversations) ?? [];
}
