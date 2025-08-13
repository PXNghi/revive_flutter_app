import 'dart:convert';

import 'package:http/http.dart';
import 'package:revive_flutter_project/core/configs/apis/api_urls.dart';
import 'package:revive_flutter_project/core/services/api_services.dart';
import 'package:revive_flutter_project/features/chat/models/conversation.dart';
import 'package:revive_flutter_project/features/chat/models/message.dart';

class ChatUsecases {
  static final ChatUsecases _singleton = ChatUsecases._internal();

  factory ChatUsecases() => _singleton;

  ChatUsecases._internal();

  Future<List<Conversation>> getAllConversations() async {
    try {
      final Response response =
          await ApiService().get(ApiUrls().apiGetAllConversations());
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List)
            .map((e) => Conversation.fromJson(e))
            .toList();
      } else {
        print("Error at get conversations");
        return [];
      }
    } catch (e) {
      print("Error at get all conversation usecase: $e");
      rethrow;
    }
  }

  Future<List<Message>> getMessages(String conversationId) async {
    try {
      if (conversationId.isNotEmpty) {
        final Response response = await ApiService()
            .get(ApiUrls().apiGetMessagesFromConversation(conversationId));
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return (data['messages'] as List)
              .map((e) => Message.fromJson(e))
              .toList();
        } else {
          print("Error at get messages");
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print("Error at get messages usecase: $e");
      rethrow;
    }
  }
}
