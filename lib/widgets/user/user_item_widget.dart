import 'package:blaa/entity/user.dart';
import 'package:blaa/services/auth_service.dart';
import 'package:flutter/material.dart';

class UserItemWidget extends StatefulWidget {
  final User user;
  final bool isRecent;

  const UserItemWidget({super.key, required this.user, required this.isRecent});

  @override
  State<UserItemWidget> createState() => _UserItemWidgetState();
}

class _UserItemWidgetState extends State<UserItemWidget> {
  String? _loggedEmail;

  @override
  void initState() {
    super.initState();
    _loadLoggedUser();
  }

  void _loadLoggedUser() async {
    final user = await AuthService().getUserLogged();
    setState(() {
      _loggedEmail = user?.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = _loggedEmail == widget.user.email;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: Colors.transparent,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            leading: CircleAvatar(
              radius: 40,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              backgroundImage:
                  Uri.tryParse(widget.user.photoUrl)?.isAbsolute == true
                      ? NetworkImage(widget.user.photoUrl)
                      : null,
              child:
                  Uri.tryParse(widget.user.photoUrl)?.isAbsolute == false ||
                          widget.user.photoUrl.isEmpty
                      ? Icon(
                        Icons.person,
                        size: 30,
                        color: const Color.fromARGB(255, 84, 0, 95),
                      )
                      : null,
            ),
            title: Text(
              isCurrentUser
                  ? '${widget.user.fullName} (tú)'
                  : widget.user.fullName,
              style: TextStyle(
                fontFamily: 'Coolvetica',
                fontSize: 18,
                color: const Color.fromARGB(255, 84, 0, 95),
                letterSpacing: 1.2,
              ),
            ),
            subtitle: Text(
              widget.user.email,
              style: TextStyle(
                fontFamily: 'Coolvetica',
                fontSize: 14,
                color: const Color.fromARGB(150, 84, 0, 95),
                letterSpacing: 1.2,
              ),
            ),
            trailing: Text(
              widget.user.position,
              style: TextStyle(
                fontFamily: 'Coolvetica',
                fontSize: 14,
                color: const Color.fromARGB(150, 84, 0, 95),
                letterSpacing: 1.2,
              ),
            ),
            onTap: () {
              if (widget.isRecent) {
                Navigator.pushNamed(context, '/chat', arguments: widget.user);
              } else {
                Navigator.pushNamed(
                  context,
                  '/profile',
                  arguments: widget.user,
                );
              }
            },
          ),
          Container(
            height: 1,
            color: const Color.fromARGB(70, 255, 169, 201),
            margin: const EdgeInsets.only(left: 90),
          ),
        ],
      ),
    );
  }
}
