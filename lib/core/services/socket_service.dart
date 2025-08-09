import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;
  Function(Map)? _onNewMessage;

  void connect(String userId) {
    socket = IO.io(
      Enviroment.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print('Socket connected: ${socket!.id}');
      socket!.emit('register_user', userId);
    });

    socket!.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket!.on('receive-message', (data) {
      if(_onNewMessage != null) _onNewMessage!(data);
      print('Receive message: $data');
    });

    socket!.on('message-sent', (data) {
      print('Message sent confirm: $data');
    });
  }

  bool isConnected() {
    return socket?.connected ?? false;
  }

  set onNewMessage(Function(Map) value) {
    _onNewMessage = value;
  }

  void sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    String type = 'text',
    String? fileUrl,
  }) {
    socket?.emit('send_message', {
      'conversionId': conversationId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type,
      'fileUrl': fileUrl
    });
  }

  void disconnect() {
    socket?.disconnect();
  }
}
