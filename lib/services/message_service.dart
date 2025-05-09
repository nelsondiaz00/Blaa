import 'dart:convert';
import 'package:blaa/entity/message.dart';
import 'package:blaa/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import '../config/config.dart';

class MessageService {
  static final MessageService _instance = MessageService._internal();
  factory MessageService() => _instance;

  final Logger _logger = Logger('MessageService');
  final String _baseUrl = baseUrl;

  MessageService._internal();

  Future<List<Message>> getMessages(String emailRecipient) async {
    try {
      final loginToken = await AuthService().getStoredToken();

      final response = await http.get(
        Uri.parse('$_baseUrl/message/$emailRecipient'),
        headers: {
          'Authorization': 'Bearer $loginToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Message> messages =
            data.map((json) => Message.fromJson(json)).toList();
        return messages;
      } else {
        _logger.warning('Failed to load messages: ${response.body}');
        return [];
      }
    } catch (e) {
      _logger.severe('Error fetching messages: $e');
      return [];
    }
  }

  Future<bool> sendMessage({
    required String recipientEmail,
    required String title,
    required String body,
  }) async {
    try {
      final loginToken = await AuthService().getStoredToken();

      final response = await http.post(
        Uri.parse('$_baseUrl/message/send'),
        headers: {
          'Authorization': 'Bearer $loginToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'recipientEmail': recipientEmail,
          'title': title,
          'body': body,
        }),
      );

      if (response.statusCode == 200) {
        _logger.info('Message sent successfully');
        return true;
      } else {
        _logger.warning('Failed to send message: ${response.body}');
        return false;
      }
    } catch (e) {
      _logger.severe('Error sending message: $e');
      return false;
    }
  }
}
