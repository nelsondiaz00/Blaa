import 'package:flutter/material.dart';

void showCustomSnackbar(
  BuildContext context,
  String message,
  bool isSuccess,
) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(
        fontFamily: 'Coolvetica',
        fontSize: 17,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.8,
        color: Colors.white,
      ),
    ),
    backgroundColor:
        isSuccess ? Color(0xFFF00A5E) : Color.fromARGB(230, 112, 109, 110),
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
