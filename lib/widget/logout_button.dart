// lib/widgets/logout_button.dart

import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final Function onLogout;

  const LogoutButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onLogout(),
        child: const Text(
          'Log Out',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}