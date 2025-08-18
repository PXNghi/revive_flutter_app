part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = Initial;
  const factory ChatState.loading() = Loading;
  const factory ChatState.loaded({
    @Default([]) List<Conversation> conversations,
    @Default([]) List<Message> messages,
    String? conversationId,
    @Default(1) int currentPage,
    @Default(false) bool isLoadingMore,
    int? totalPages,
  }) = Loaded;
  const factory ChatState.success() = Success;
  const factory ChatState.error(String message) = Error;

  const ChatState._();

  List<Conversation> get conversations => mapOrNull(loaded: (state) => state.conversations) ?? [];
  List<Message> get messages => mapOrNull(loaded: (state) => state.messages) ?? [];
  String? get conversationId => mapOrNull(loaded: (state) => state.conversationId);
  int get currentPage => mapOrNull(loaded: (state) => state.currentPage) ?? 1;
  int? get totalPages => mapOrNull(loaded: (state) => state.totalPages);
  bool get isLoadingMore => mapOrNull(loaded: (state) => state.isLoadingMore) ?? false;
}
