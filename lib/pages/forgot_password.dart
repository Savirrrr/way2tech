import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _forgotpwd() async {
    String email = _emailController.text;
    final response = await http.post(
      Uri.parse('http://192.168.106.119:3000/forgotpwd'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sent succesfully!')),
      );
    }
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email ')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 40),
              const Center(
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  bottom: 6.0,
                ),
                child: Text(
                  "Enter the email associated with your account and we’ll send an email with code to reset your password",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                  bottom: 4.0,
                ),
                child: Text("Email"),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  bottom: 4.0,
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Text your email',
                    hintStyle: const TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _forgotpwd,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 120,
                    ),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
