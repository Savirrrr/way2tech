import 'package:flutter/material.dart';

class OTPVerificationPage extends StatelessWidget {
  final String email;
  final bool isRegistration;
  final String username;

  const OTPVerificationPage({
    Key? key,
    required this.email,
    required this.isRegistration,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
      ),
      body: Center(
        child: Text("OTP verification for $email"),
      ),
    );
  }
}