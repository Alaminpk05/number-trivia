import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String message,
  Color backgroundColor = Colors.black87,
  Duration duration = const Duration(seconds: 2),
  SnackBarAction? action,
}) {
  ScaffoldMessenger.of(context).clearSnackBars(); // Optional: avoid stacking
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: duration,
      action: action,
    ),
  );
}
