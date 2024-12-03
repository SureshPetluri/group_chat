import 'package:flutter/material.dart';
import '../../main.dart';

class SnackNotification {

  static void showCustomSnackBar(String? message,
      {bool isError = false,
      bool isWarning = false,
      Color testColor = Colors.white}) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).hideCurrentSnackBar();
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message ?? "Please try again",
            style: TextStyle(
              color: Color(0xFF201B59),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: isError
            ? Colors.red
            : isWarning
                ? Color(0xFFF67434)
                : const Color(0xFFE9F6FF),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
