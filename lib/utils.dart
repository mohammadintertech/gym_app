import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppStyle {
  static Color backgroundColor = const Color.fromARGB(255, 255, 244, 215);

  static TextStyle mainButtons = TextStyle(
      fontSize: 30,
      fontFamily: 'Cairo',
      color: Colors.black,
      fontWeight: FontWeight.bold);
}

class Helpers {
  static void showErrorMessage({String? msg, BuildContext? context}) {
    ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      content: Text(msg!),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.red,
    ));
  }
}
