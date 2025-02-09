import 'package:flutter/material.dart';

class CaughtUpPage extends StatelessWidget {
  const CaughtUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "You're all caught up!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}