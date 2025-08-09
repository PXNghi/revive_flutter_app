import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/chat/chat_usecases.dart';
import 'package:revive_flutter_project/features/chat/models/conversation.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatUsecases _chatUsecases = ChatUsecases();
  ChatBloc() : super(const ChatState.initial()) {
    on<_Started>(_handleStarted);
    on<_GetAllConversations>(_handleGetAllConversations);
  }

  FutureOr<void> _handleStarted(
    _Started event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final List<Conversation> conversations = await _chatUsecases.getAllConversations();
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
      final List<Conversation> conversations = await _chatUsecases.getAllConversations();
      emit(ChatState.loaded(conversations: conversations));
    } catch (e) {
      print("Error get all conversations: $e");
    }
  }
}
