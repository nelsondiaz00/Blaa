import 'package:blaa/entity/user.dart';
import 'package:blaa/widgets/message/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:blaa/screens/profile_screen.dart';

class ChatScreen extends StatelessWidget {
  final User userRecipient;

  const ChatScreen({super.key, required this.userRecipient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(user: userRecipient),
              ),
            );
          },
          child: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: const Color(0xFFF8045C),
            leadingWidth: 30,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userRecipient.photoUrl),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    userRecipient.fullName,
                    style: const TextStyle(
                      fontFamily: 'Coolvetica',
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                      letterSpacing: 1.3,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ChatWidget(userRecipient: userRecipient),
    );
  }
}
