import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;
  Function(Map)? _onNewMessageCome;
  Function(Map)? _onMessageSent;

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
      if(_onNewMessageCome != null) _onNewMessageCome!(data);
      print('Receive message: $data');
    });

    socket!.on('message-sent', (data) {
      if(_onMessageSent != null) _onMessageSent!(data);
      print('Message sent confirm: $data');
    });
  }

  bool isConnected() {
    return socket?.connected ?? false;
  }

  set onNewMessageReceived(Function(Map) value) {
    _onNewMessageCome = value;
  }

  set onMessageSent(Function(Map) value) {
    _onMessageSent = value;
  }

  void sendMessage({
    String? conversationId,
    required String senderId,
    required String content,
    String type = 'text',
    String? fileUrl,
  }) {
    socket?.emit('send_message', {
      'conversionId': conversationId ?? "",
      'senderId': senderId,
      'content': content,
      'type': type,
      'fileUrl': fileUrl
    });
  }

  void disconnect() {
    socket?.disconnect();
  }
}
