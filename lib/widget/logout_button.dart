// lib/widgets/logout_button.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogoutButton extends StatelessWidget {
  final Function onLogout;

  const LogoutButton({Key? key, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onLogout(),
        child: Text(
          'Log Out',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}