import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:logging/logging.dart';
import '../config/config.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;

  final String _socketUrl = socketUrl;
  late socket_io.Socket _socket;
  final Logger _logger = Logger('WebSocketService');

  WebSocketService._internal();

  void connect(String email) {
    _socket = socket_io.io(_socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'email': email},
    });

    _socket.connect();

    _socket.onConnect((_) {
      _logger.info('Connected to WebSocket server');
    });

    _socket.emit('register', email);

    _socket.onDisconnect((_) {
      _logger.warning('Disconnected from WebSocket server');
    });

    _socket.onConnectError((error) {
      _logger.severe('Connection error: $error');
    });

    _socket.onError((error) {
      _logger.severe('Socket error: $error');
    });
  }

  void sendMessage(Map<String, dynamic> messageData) {
    _socket.emit('sendMessage', messageData);
    _logger.info('Message sent: $messageData');
  }

  void disconnect() {
    _socket.disconnect();
    _logger.info('Connection closed');
  }

  socket_io.Socket get socket => _socket;
}
