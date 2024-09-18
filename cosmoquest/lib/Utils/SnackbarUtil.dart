import 'package:flutter/material.dart';

class SnackBarUtil {
  // General method to show a SnackBar from anywhere in the app
  static void showSnackbar(BuildContext context, String message,
      {Color backgroundColor = Colors.redAccent,
        SnackBarBehavior behavior = SnackBarBehavior.floating,
        int durationInSeconds = 3}) {
    // Display the SnackBar using ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: behavior,
        duration: Duration(seconds: durationInSeconds),
      ),
    );
  }
}