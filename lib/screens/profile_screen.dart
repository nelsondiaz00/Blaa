import 'package:blaa/entity/user.dart';
import 'package:blaa/widgets/user/user_profile_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushReplacementNamed(context, '/messaging');
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF00A5E),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF00A5E),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Perfil',
            style: TextStyle(
              fontFamily: 'Coolvetica',
              fontSize: 22,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: ProfileWidget(user: user),
      ),
    );
  }
}
