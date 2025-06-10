import 'package:flutter/material.dart';

class NumberTriviaButtonWidget extends StatelessWidget {
  const NumberTriviaButtonWidget({
    super.key,
    required this.onPressed,
    required this.title,
    this.color,
    this.titleColor,
  });
  final void Function() onPressed;
  final String title;
  final Color? color;
  final Color? titleColor;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(),
        ),
        child: Text(title, style: TextStyle(color: titleColor)),
      ),
    );
  }
}
