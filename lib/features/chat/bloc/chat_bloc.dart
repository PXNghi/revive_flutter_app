import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/services/socket_service.dart';
import 'package:revive_flutter_project/features/chat/chat_usecases.dart';
import 'package:revive_flutter_project/features/chat/models/conversation.dart';
import 'package:revive_flutter_project/features/chat/models/message.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatUsecases _chatUsecases = ChatUsecases();
  final SocketService _socketService = SocketService();
  ChatBloc() : super(const ChatState.initial()) {
    _socketService.connect(SessionData.mine!.id);
    _socketService.onNewMessage = (data) => add(const _GetAllConversations());
    on<_Started>(_handleStarted);
    on<_GetAllConversations>(_handleGetAllConversations);
    on<_UpdateConversation>(_handleUpdateConversation);
  }

  FutureOr<void> _handleStarted(
    _Started event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final List<Conversation> conversations =
          await _chatUsecases.getAllConversations();
      emit(ChatState.loaded(conversations: conversations));
    } catch (e) {
      print("Error started event at chat bloc: $e");
    }
  }

  FutureOr<void> _handleGetAllConversations(
    _GetAllConversations event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(const ChatState.loading());
      final List<Conversation> conversations =
          await _chatUsecases.getAllConversations();
      emit(ChatState.loaded(conversations: conversations));
    } catch (e) {
      print("Error get all conversations: $e");
    }
  }

  FutureOr<void> _handleUpdateConversation(
    _UpdateConversation event,
    Emitter<ChatState> emit,
  ) async {
    try {
      if (state is Loaded) {
        final loadedState = state as Loaded;
        final updatedList = state.conversations.map((c) {
          if (c.id == event.conversationId) {
            return c.copyWith(
              lastMessage: event.message,
              updatedAt: DateTime.now(),
            );
          }
          return c;
        }).toList();

        updatedList.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

        emit(loadedState.copyWith(conversations: updatedList));
      }
    } catch (e) {
      print("Error update conversation: $e");
    }
  }
}
