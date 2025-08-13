import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/services/socket_service.dart';
import 'package:revive_flutter_project/features/chat/chat_usecases.dart';
import 'package:revive_flutter_project/features/chat/models/conversation.dart';
import 'package:revive_flutter_project/features/chat/models/message.dart';
import 'package:revive_flutter_project/features/person/models/user.dart';
import 'package:revive_flutter_project/features/person/user_usecases.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatUsecases _chatUsecases = ChatUsecases();
  final SocketService _socketService = SocketService();
  final UserUsecases _userUsecases = UserUsecases();
  String? conversationId = "";
  ChatBloc() : super(const ChatState.initial()) {
    _socketService.connect(SessionData.mine!.id);
    _socketService.onNewMessageReceived = (data) {
      add(const _GetAllConversations());
      add(_GetMessages(data["message"]["conversationId"]));
    };
    on<_Started>(_handleStarted);
    on<_GetAllConversations>(_handleGetAllConversations);
    on<_UpdateConversation>(_handleUpdateConversation);
    on<_GetMessages>(_handleGetMessages);
    on<_SendMessage>(_handleSendMessage);
    on<_ChoosePicture>(_handleChoosePicture);
    on<_ChooseCamera>(_handleChooseCamera);
  }

  FutureOr<void> _handleStarted(
    _Started event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final List<Conversation> conversations =
          await _chatUsecases.getAllConversations();
      List<Message> messages = [];
      if (SessionData.mine?.role == "User") {
        if (conversations.isNotEmpty) {
          conversationId = conversations[0].id;
        }
        messages = await _chatUsecases.getMessages(conversationId ?? "");
      }

      emit(ChatState.loaded(
        conversations: conversations,
        conversationId: conversationId,
        messages: messages,
      ));
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

  FutureOr<void> _handleGetMessages(
    _GetMessages event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final List<Message> messages =
          await _chatUsecases.getMessages(event.conversationId);
      conversationId = event.conversationId;
      emit(ChatState.loaded(messages: messages));
    } catch (e) {
      print("Error get messages: $e");
    }
  }

  FutureOr<void> _handleSendMessage(
    _SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      if (state is Initial) {
        emit(const ChatState.loaded());
      }
      if (state is Loaded) {
        final loadedState = state as Loaded;
        final User user = await _userUsecases.getUserById(event.senderId);
        final Message message = Message(
          sender: user,
          content: event.content,
          type: event.type,
          fileUrl: event.fileUrl,
          createdAt: DateTime.now(),
        );
        final messages = [message, ...loadedState.messages];
        emit(loadedState.copyWith(messages: messages));
      }
      if (conversationId == null) {
        _socketService.sendMessage(
          senderId: event.senderId,
          content: event.content,
          type: event.type,
          fileUrl: event.fileUrl,
        );
      } else {
        _socketService.sendMessage(
          conversationId: conversationId,
          senderId: event.senderId,
          content: event.content,
          type: event.type,
          fileUrl: event.fileUrl,
        );
      }
    } catch (e) {
      print("Error send message: $e");
    }
  }

  FutureOr<void> _handleChoosePicture(
    _ChoosePicture event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final result = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (result != null) {
        final uploadedImage = await ApiService()
            .uploadImage(ApiUrls().apiUploadImage(), [result.path]);
        add(
          ChatEvent.sendMessage(
            senderId: SessionData.mine!.id,
            receiverId: "",
            content: "",
            fileUrl: uploadedImage.url.first.toString(),
            type: "image",
          ),
        );
      }
    } catch (e) {
      print("Error choose picture: $e");
    }
  }

  FutureOr<void> _handleChooseCamera(
    _ChooseCamera event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final result = await ImagePicker().pickImage(source: ImageSource.camera);
      if (result != null) {
        final uploadedImage = await ApiService()
            .uploadImage(ApiUrls().apiUploadImage(), [result.path]);
        add(
          ChatEvent.sendMessage(
            senderId: SessionData.mine!.id,
            receiverId: "",
            content: "",
            fileUrl: uploadedImage.url.first.toString(),
            type: "image",
          ),
        );
      }
    } catch (e) {
      print("Error choose camera: $e");
    }
  }
}
