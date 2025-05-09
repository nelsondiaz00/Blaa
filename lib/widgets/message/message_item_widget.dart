import 'package:blaa/entity/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  final bool ownMessage;

  const MessageItem({
    super.key,
    required this.message,
    required this.ownMessage,
  });

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm').format(message.createdAt);
    final Color myMessageColor = const Color(0xFFFFD1E3);
    final Color otherMessageColor = const Color(0xFFE4E4E4);
    final Color timeColor = Colors.black45;
    final Color textColor = const Color(0xFF54005F);

    final emailToShow =
        ownMessage ? message.recipientEmail : message.senderEmail;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment:
            ownMessage ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment:
                ownMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Text(
                emailToShow,
                style: const TextStyle(
                  fontFamily: 'Coolvetica',
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            constraints: const BoxConstraints(
              minWidth: 100,
              maxWidth: 280,
              minHeight: 60,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: ownMessage ? myMessageColor : otherMessageColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(ownMessage ? 0 : 16),
                bottomRight: Radius.circular(ownMessage ? 16 : 0),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Text(
                    message.body.isNotEmpty ? message.body : ' ',
                    style: TextStyle(
                      fontFamily: 'Coolvetica',
                      fontSize: 16,
                      color: textColor,
                      height: 1.4,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text(
                    timeString,
                    style: TextStyle(
                      fontFamily: 'Coolvetica',
                      fontSize: 10,
                      color: timeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
