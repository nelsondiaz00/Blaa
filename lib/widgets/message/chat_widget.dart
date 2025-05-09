import 'dart:async';

import 'package:blaa/entity/message.dart';
import 'package:blaa/entity/user.dart';
import 'package:blaa/services/auth_service.dart';
import 'package:blaa/services/message_service.dart';
import 'package:blaa/services/web_socket_service.dart';
import 'package:blaa/widgets/message/message_item_widget.dart';
import 'package:blaa/widgets/shared/loading_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ChatWidget extends StatefulWidget {
  final User userRecipient;

  const ChatWidget({super.key, required this.userRecipient});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final Logger _logger = Logger('ChatWidget');
  late StreamController<List<Message>> _messagesStreamController;
  final TextEditingController _messageController = TextEditingController();
  String _currentUserEmail = '';
  final List<Message> _messages = [];
  final StreamController<Message> _newMessageController =
      StreamController<Message>();
  late final StreamSubscription<Message> _newMessageSubscription;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _messagesStreamController = StreamController<List<Message>>.broadcast();
    _loadCurrentUser();
    _messageController.addListener(_updateSendButtonState);

    _newMessageSubscription = _newMessageController.stream.listen((message) {
      if (!mounted) return;

      final alreadyExists = _messages.any((m) => m.id == message.id);
      if (!alreadyExists) {
        setState(() {
          _messages.insert(0, message);
          _messagesStreamController.add(List.from(_messages));
        });
      }
    });
  }

  Future<void> _loadCurrentUser() async {
    final user = await AuthService().getUserLogged();
    if (!mounted) return;

    setState(() {
      _currentUserEmail = user?.email ?? '';
    });

    final socketService = WebSocketService();
    socketService.connect(user!.email);

    final initialMessages = await MessageService().getMessages(
      widget.userRecipient.email,
    );
    _messages.addAll(initialMessages.reversed);
    _messagesStreamController.add(List.from(_messages));

    socketService.socket.on('receive_message', (data) {
      _logger.info(data);
      final message = Message.fromJson(data);
      if (message.senderEmail == widget.userRecipient.email ||
          message.recipientEmail == widget.userRecipient.email) {
        if (!_newMessageController.isClosed) {
          _newMessageController.add(message);
        }
      }
    });
  }

  void _updateSendButtonState() {
    setState(() {});
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _currentUserEmail.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    final success = await MessageService().sendMessage(
      recipientEmail: widget.userRecipient.email,
      body: text,
      title: '${widget.userRecipient.fullName} te ha enviado un mensaje',
    );

    if (success) {
      _messageController.clear();
    } else {
      _logger.warning('Mensaje no enviado');
    }

    if (mounted) {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFF00A5E);
    const inputBackground = Color(0xFFFDE9F1);

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<Message>>(
            stream: _messagesStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay mensajes'));
              }

              final messages = snapshot.data!;
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isOwnMessage = msg.senderEmail == _currentUserEmail;

                  return Align(
                    alignment:
                        isOwnMessage
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                    child: MessageItem(message: msg, ownMessage: isOwnMessage),
                  );
                },
              );
            },
          ),
        ),
        const Divider(height: 1, color: Colors.black12),
        Container(
          color: inputBackground,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(
                    fontFamily: 'Coolvetica',
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    hintStyle: TextStyle(
                      fontFamily: 'Coolvetica',
                      color: Colors.grey.shade600,
                      letterSpacing: 0.3,
                      fontSize: 16,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color:
                      _messageController.text.trim().isEmpty || _isSending
                          ? Colors.grey.shade300
                          : primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon:
                      _isSending
                          ? const LoadingIcon(
                            icon: Icons.refresh,
                            size: 20,
                            color: Color(0xFFF8045C),
                          )
                          : const Icon(Icons.send_rounded),
                  onPressed:
                      _messageController.text.trim().isEmpty || _isSending
                          ? null
                          : _sendMessage,
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 4, right: 0),
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    WebSocketService().disconnect();
    _messageController.removeListener(_updateSendButtonState);
    _messageController.dispose();
    _messagesStreamController.close();
    _newMessageController.close();
    _newMessageSubscription.cancel();
    super.dispose();
  }
}
